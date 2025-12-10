#!/bin/sh

set -eu

# Helper to run jq on a string (avoids shell-dependent echo behavior).
jqs() {
  string="$1"
  shift
  printf '%s\n' "$string" | jq "$@"
}

# Map reaction types to emoji.
reaction_emoji() {
  case "$1" in
    "+1") echo "👍" ;;
    "-1") echo "👎" ;;
    "laugh") echo "😄" ;;
    "confused") echo "😕" ;;
    "heart") echo "❤️" ;;
    "hooray") echo "🎉" ;;
    "rocket") echo "🚀" ;;
    "eyes") echo "👀" ;;
    *) echo "$1" ;;
  esac
}

# Format a single comment (parent or reply).
format_comment() {
  comment_id="$1"
  user="$2"
  body="$3"
  is_reply="$4"

  # Set indentation for replies.
  if [ "$is_reply" = "true" ]; then
    indent="  "
    header_prefix="replied"
  else
    indent=""
    header_prefix="commented"
  fi

  # Print the comment header.
  echo "${indent}**@$user** $header_prefix:"
  echo ""

  # Print the comment body as a blockquote.
  printf '%s\n' "$body" | sed "s/^/${indent}> /"
  echo ""

  # Fetch and format reactions.
  reactions=$(gh api "repos/{owner}/{repo}/pulls/comments/$comment_id/reactions" --jq '
    group_by(.content) |
    map({content: .[0].content, users: map(.user.login)}) |
    map(select(.users | length > 0))
  ')

  if [ "$reactions" != "[]" ]; then
    printf "%s**Reactions:** " "$indent"

    # Format reactions with emoji and users.
    first=true
    jqs "$reactions" -r '.[] | "\(.content):\(.users | join(","))"' | while IFS=: read -r reaction_type users; do
      emoji=$(reaction_emoji "$reaction_type")
      if [ "$first" = true ]; then
        first=false
      else
        printf " · "
      fi
      printf "%s %s" "$emoji" "$users"
    done

    echo ""
    echo ""
  fi
}

# Fetch all PR comments with reply information.
all_comments=$(gh api "repos/{owner}/{repo}/pulls/$1/comments" --jq '.[] | {
  id: .id,
  path: .path,
  user_login: .user.login,
  body: .body,
  original_commit_id: .original_commit_id,
  diff_hunk: .diff_hunk,
  in_reply_to_id: .in_reply_to_id
}')

# Track the current file to group comments.
current_file=""

# Process each top-level comment (not replies).
jqs "$all_comments" -c 'select(.in_reply_to_id == null)' | while IFS= read -r comment; do
  [ -z "$comment" ] && continue

  comment_id=$(jqs "$comment" -r '.id')
  file_path=$(jqs "$comment" -r '.path')
  user=$(jqs "$comment" -r '.user_login')
  body=$(jqs "$comment" -r '.body')
  diff_hunk=$(jqs "$comment" -r '.diff_hunk')

  # Print the file header if it changed.
  if [ "$file_path" != "$current_file" ]; then
    if [ -n "$current_file" ]; then
      echo ""
    fi
    echo "## $file_path"
    echo ""
    current_file="$file_path"
  fi

  # Print the diff hunk first (code context).
  if [ "$diff_hunk" != "null" ]; then
    echo '```diff'
    printf '%s\n' "$diff_hunk"
    echo '```'
    echo ""
  fi

  # Format the top-level comment.
  format_comment "$comment_id" "$user" "$body" "false"

  # Find and output replies to this comment.
  jqs "$all_comments" -c "select(.in_reply_to_id == $comment_id)" | while IFS= read -r reply; do
    [ -z "$reply" ] && continue

    reply_id=$(jqs "$reply" -r '.id')
    reply_user=$(jqs "$reply" -r '.user_login')
    reply_body=$(jqs "$reply" -r '.body')

    format_comment "$reply_id" "$reply_user" "$reply_body" "true"
  done

  echo "---"
  echo ""
done
