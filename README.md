<!-- BEGIN:AVATAR -->
To be populated by generator-github-action github-action-partials
<!-- END:AVATAR -->

<!-- BEGIN:BADGES -->
To be populated by generator-github-action github-action-partials
<!-- END:BADGES -->

# Dispatch Workflow GitHub Action

Dispatch Workflow GitHub Action is a GitHub Action for dispatching workflows across repositories and waiting for completion.

The workflow is dispatched on all repositories in parallel, and the action waits until all of the workflow runs complete. The action fails when any of the workflow runs doesn't conclude successfully, which allows subsequent steps to depend on the dispatched workflows.

The workflow to be dispatched must have a `workflow_dispatch` trigger, and the GitHub token must have permission to dispatch and read workflow runs on all repositories, i.e. a fine-grained personal access token with `Actions: Read and write` repository permission, or a classic personal access token with `repo` scope.

The action uses [GitHub CLI](https://cli.github.com/) which is available on GitHub-hosted runners, the GitHub CLI version must print the dispatched workflow run URL.

## Usage

Dispatch a workflow on a repository and wait for completion:

```yaml
jobs:
  build:
    steps:
      - name: 'Upgrade dependencies of generator-node'
        uses: cliffano/dispatch-workflow-action@main
        with:
          workflow: 'upgrade-deps-workflow.yaml'
          repos: 'cliffano/generator-node'
          github_token: ${{ secrets.STUDIO_GITHUB_TOKEN }}
```

Dispatch a workflow on multiple repositories in parallel and wait for all of them to complete:

```yaml
jobs:
  build:
    steps:
      - name: 'Release suntory and olympia'
        uses: cliffano/dispatch-workflow-action@main
        with:
          workflow: 'release-minor-workflow.yaml'
          repos: 'cliffano/suntory, cliffano/olympia'
          github_token: ${{ secrets.STUDIO_GITHUB_TOKEN }}
```

Dispatch a workflow on a branch with workflow inputs:

```yaml
jobs:
  build:
    steps:
      - name: 'Release suntory from a branch'
        uses: cliffano/dispatch-workflow-action@main
        with:
          workflow: 'release-workflow.yaml'
          repos: 'cliffano/suntory'
          github_token: ${{ secrets.STUDIO_GITHUB_TOKEN }}
          ref: 'some-branch'
          inputs: '{"release_type": "minor"}'
```

Dispatch a workflow without waiting for completion:

```yaml
jobs:
  build:
    steps:
      - name: 'Trigger CI of suntory and olympia'
        uses: cliffano/dispatch-workflow-action@main
        with:
          workflow: 'ci-workflow.yaml'
          repos: 'cliffano/suntory, cliffano/olympia'
          github_token: ${{ secrets.STUDIO_GITHUB_TOKEN }}
          wait: 'false'
```

Access the workflow run URLs and conclusions:

```yaml
jobs:
  build:
    steps:
      - id: dispatch
        uses: cliffano/dispatch-workflow-action@main
        with:
          workflow: 'ci-workflow.yaml'
          repos: 'cliffano/suntory, cliffano/olympia'
          github_token: ${{ secrets.STUDIO_GITHUB_TOKEN }}
      - if: always()
        run: |
          echo "Run URLs: ${{ steps.dispatch.outputs.run_urls }}"
          echo "Conclusions: ${{ steps.dispatch.outputs.conclusions }}"
```

## Job Summary and Annotations

When all workflow runs complete, the action adds a table to the job summary, showing the result of each repository along with the link to its workflow run:

| Repository | Result | Run |
|------------|--------|-----|
| cliffano/suntory | ✅ success | [#1001](https://github.com/cliffano/suntory/actions/runs/1001) |
| cliffano/olympia | ❌ failure | [#1002](https://github.com/cliffano/olympia/actions/runs/1002) |
| cliffano/someproject | ❌ error: Unable to dispatch ci-workflow.yaml: HTTP 404: Not Found | - |

The action also adds an error annotation for each repository whose workflow run didn't succeed, or whose workflow couldn't be dispatched, which is displayed on the workflow run summary page.

## Configuration

| Input | Type | Description | Required | Default | Example |
|-------|------|-------------|----------|---------|---------|
| workflow | string | Workflow file name or ID to dispatch, the workflow must have a `workflow_dispatch` trigger | Yes | - | `release-minor-workflow.yaml` |
| repos | string | Comma-separated list of repositories in `owner/repo` format | Yes | - | `cliffano/suntory, cliffano/olympia` |
| github_token | string | GitHub token with permission to dispatch and read workflow runs on all repositories | Yes | - | `${{ secrets.STUDIO_GITHUB_TOKEN }}` |
| ref | string | Branch or tag containing the workflow to dispatch | No | Repository default branch | `some-branch` |
| inputs | string | Workflow inputs defined in a JSON object string | No | `{}` | `{"release_type": "minor"}` |
| wait | string | Whether to wait for the dispatched workflow runs to complete | No | `true` | `false` |
| poll_interval | string | Number of seconds between workflow run status checks | No | `30` | `60` |

| Output | Description | Example |
|--------|-------------|---------|
| run_urls | JSON object of each repository and its dispatched workflow run URL | `{"cliffano/suntory": "https://github.com/cliffano/suntory/actions/runs/1001"}` |
| conclusions | JSON object of each repository and its workflow run conclusion, empty when `wait` is `false`, or `error` when the workflow could not be dispatched or its run status could not be retrieved | `{"cliffano/suntory": "success"}` |

## Colophon

<!-- BEGIN:DEVELOPERS_GUIDE -->
To be populated by generator-github-action github-action-partials
<!-- END:DEVELOPERS_GUIDE -->

<!-- BEGIN:BUILD_REPORTS -->
To be populated by generator-github-action github-action-partials
<!-- END:BUILD_REPORTS -->
