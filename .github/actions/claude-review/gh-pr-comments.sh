#!/bin/sh

set -eu

# Fetch all PR comments with their IDs
comments=$(gh api "repos/{owner}/{repo}/pulls/$1/comments" --jq '.[] | {
  id: .id,
  path: .path,
  user_login: .user.login,
  body: .body,
  original_commit_id: .original_commit_id,
  diff_hunk: .diff_hunk
}')

# Process each comment to add reactions
echo "$comments" | jq -c '.' | while IFS= read -r comment; do
  comment_id=$(echo "$comment" | jq -r '.id')

  # Fetch reactions for this comment
  reactions=$(gh api "repos/{owner}/{repo}/pulls/comments/$comment_id/reactions" --jq '
    group_by(.content) | map({
      key: .[0].content,
      value: map(.user.login)
    }) | from_entries
  ')

  # Only include non-empty reactions object
  if [ "$reactions" != "{}" ]; then
    echo "$comment" | jq --argjson reactions "$reactions" '. + {reactions: $reactions}'
  else
    echo "$comment"
  fi
done | jq -s '.'
