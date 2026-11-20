#!/usr/bin/env bash
set -o errexit
set -o nounset

# The example dispatches this repository's CI workflow on GitHub,
# using the GitHub token of the gh CLI logged in user
printf "\n\n========================================\n"
printf "Run workflow with action\n"
cd .. && gh act -P ubuntu-26.04=catthehacker/ubuntu:act-latest -W examples/dispatch-workflow-action-workflow.yaml -s GITHUB_TOKEN="$(gh auth token)"
