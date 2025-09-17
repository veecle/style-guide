#!/bin/sh

set -eu

query='.[] | pick(.path, .user.login, .body, .original_commit_id, .diff_hunk)'

gh api "repos/{owner}/{repo}/pulls/$1/comments" -q "$query"
