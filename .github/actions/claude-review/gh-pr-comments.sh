#!/bin/sh

set -eu

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
  echo "$body" | sed "s/^/${indent}> /"
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
    echo "$reactions" | jq -r '.[] | "\(.content):\(.users | join(","))"' | while IFS=: read -r reaction_type users; do
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

# Get only top-level comments (not replies).
top_level_comments=$(echo "$all_comments" | jq -c 'select(.in_reply_to_id == null)')

# Track the current file to group comments.
current_file=""

# Process each top-level comment.
echo "$top_level_comments" | while IFS= read -r comment; do
  [ -z "$comment" ] && continue

  comment_id=$(echo "$comment" | jq -r '.id')
  file_path=$(echo "$comment" | jq -r '.path')
  user=$(echo "$comment" | jq -r '.user_login')
  body=$(echo "$comment" | jq -r '.body')
  diff_hunk=$(echo "$comment" | jq -r '.diff_hunk')

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
    echo "$diff_hunk"
    echo '```'
    echo ""
  fi

  # Format the top-level comment.
  format_comment "$comment_id" "$user" "$body" "false"

  # Find and output replies to this comment.
  replies=$(echo "$all_comments" | jq -c "select(.in_reply_to_id == $comment_id)")

  echo "$replies" | while IFS= read -r reply; do
    [ -z "$reply" ] && continue

    reply_id=$(echo "$reply" | jq -r '.id')
    reply_user=$(echo "$reply" | jq -r '.user_login')
    reply_body=$(echo "$reply" | jq -r '.body')

    format_comment "$reply_id" "$reply_user" "$reply_body" "true"
  done

  echo "---"
  echo ""
done
