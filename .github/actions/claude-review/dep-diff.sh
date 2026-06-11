#!/usr/bin/env bash
#
# Fetch the source diff and commit log between two refs of a GitHub repository.
#
# Usage: dep-diff.sh <owner/repo> <base-ref> <head-ref> <output-dir>
#
# Outputs:
#   <output-dir>/<repo>-<base>..<head>.diff  — raw source diff
#   <output-dir>/<repo>-<base>..<head>.log   — commit messages with diffstats
#
# Prints the path and line count of each output file to stdout.

set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "Usage: dep-diff.sh <owner/repo> <base-ref> <head-ref> <output-dir>" >&2
  exit 1
fi

repo="$1"
base="$2"
head="$3"
output_dir="$4"

if [[ ! -d "$output_dir" ]]; then
  echo "Error: output directory does not exist: $output_dir" >&2
  exit 1
fi

# Sanitize for filenames: owner/repo -> owner-repo, and escape any odd chars in refs.
safe_repo="${repo//\//-}"
safe_base="${base//\//-}"
safe_head="${head//\//-}"
prefix="${output_dir}/${safe_repo}-${safe_base}..${safe_head}"

diff_file="${prefix}.diff"
log_file="${prefix}.log"

# Fetch raw diff.
if ! gh api "repos/${repo}/compare/${base}...${head}" \
  -H 'Accept: application/vnd.github.v3.diff' \
  > "$diff_file" 2>/dev/null; then
  echo "Error: failed to fetch diff for ${repo} ${base}...${head}" >&2
  echo "Check that the repository and refs exist." >&2
  echo "" >&2
  echo "Available tags on ${repo}:" >&2
  if ! gh api "repos/${repo}/tags" --paginate --jq '.[].name' >&2; then
    echo "  (failed to list tags)" >&2
  fi
  rm -f "$diff_file"
  exit 1
fi

# Fetch compare JSON for commit messages and stats.
compare_json="${prefix}.json"
if ! gh api "repos/${repo}/compare/${base}...${head}" \
  > "$compare_json" 2>/dev/null; then
  echo "Error: failed to fetch compare data for ${repo} ${base}...${head}" >&2
  rm -f "$compare_json"
  exit 1
fi

# Build the log file from the JSON response.
jq -r '
  # Overall diffstat summary.
  "\(.total_commits) commits, " +
    "\(.files | length) files changed, " +
    "\([.files[].additions] | add // 0) insertions(+), " +
    "\([.files[].deletions] | add // 0) deletions(-)",
  "",
  # Per-file diffstat.
  (.files[] |
    "  \(.additions)\t\(.deletions)\t\(.filename)" +
    (if .previous_filename then " (renamed from \(.previous_filename))" else "" end)
  ),
  "",
  # Commit messages.
  (.commits[] |
    (.sha[:8]) + " " + .commit.message,
    ""
  )
' "$compare_json" > "$log_file"

rm -f "$compare_json"

diff_lines=$(wc -l < "$diff_file")
log_lines=$(wc -l < "$log_file")

echo "${diff_file} (${diff_lines} lines)"
echo "${log_file} (${log_lines} lines)"
