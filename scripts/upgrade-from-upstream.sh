#!/usr/bin/env bash
# Upgrade this fork from Microsoft upstream (e.g. v0.52.2).
# Does NOT create any folder inside the fork; uses GitHub upstream only.
# Run from the os-monaco-editor repo root.
#
# Usage: ./scripts/upgrade-from-upstream.sh [TAG]
# Default TAG: v0.52.2

set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"
if [[ ! -d .git ]]; then
  echo "Must run from os-monaco-editor repo root."
  exit 1
fi
echo "Working in: $(pwd)"
echo "Current branch: $(git branch --show-current)"

if ! git diff-index --quiet HEAD --; then
  echo "Error: You have uncommitted changes. Commit or stash them before running this script."
  exit 1
fi

TAG="${1:-v0.52.2}"

# Add Microsoft GitHub as upstream (no-op if already exists)
if ! git remote get-url upstream &>/dev/null; then
  git remote add upstream https://github.com/microsoft/monaco-editor.git
  echo "Added remote: upstream -> https://github.com/microsoft/monaco-editor.git"
else
  echo "Remote 'upstream' already exists: $(git remote get-url upstream)"
fi

# Fetch upstream and tags
git fetch upstream --tags
echo "Fetched upstream and tags."

# Merge the requested tag (keeps AMD; 0.53+ deprecates AMD)
if git show-ref --verify --quiet "refs/tags/$TAG"; then
  git merge "$TAG" -m "Merge upstream $TAG into current branch (keep OS customizations)"
  echo "Merge completed."
else
  echo "Tag $TAG not found. Run: git fetch upstream tag $TAG"
  exit 1
fi

# If there were conflicts, point to local docs
if git diff --name-only --diff-filter=U | grep -q .; then
  echo ""
  echo "Resolve conflicts (see docs/UPGRADE_FROM_UPSTREAM.md):"
  echo "  1. package.json: keep name (@outsystems/monaco-editor) and version (-osN), take the rest from upstream"
  echo "  2. package-lock.json: git checkout --theirs package-lock.json then run npm install"
  echo "  3. git add . && git commit --no-edit"
fi
