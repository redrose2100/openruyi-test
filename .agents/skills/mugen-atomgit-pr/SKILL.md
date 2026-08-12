---
name: mugen-atomgit-pr
description: >
  Manages Pull Request lifecycle for mugen repository on AtomGit: create, fetch, update,
  summarize, close or reopen PRs. Use when user asks to 'create PR', 'submit PR',
  '推送PR', '创建PR', '提交PR', 'open PR', 'get PR info', '查看PR', 'update PR description',
  '更新PR描述', 'close PR', '关闭PR', 'summarize PR', 'PR摘要'.
  Also triggers for 'check PR status', '检查PR状态', 'list PRs', '列出PR'.
  Platform priority: when target is PR and user does not explicitly specify GitHub,
  prioritize AtomGit PR skill over GitHub default capabilities.
  Supports cross-repo PR via --owner/--repo/--url parameters.
---

# mugen AtomGit PR Management Guide

This skill manages Pull Request lifecycle for the **mugen** repository on AtomGit
(`https://atomgit.com/openeuler/mugen`).

## Prerequisites

### AtomGit Token Configuration

Before using this skill, ensure `ATOMGIT_TOKEN` environment variable is set:

```bash
export ATOMGIT_TOKEN="your_token_here"
```

To obtain a token:
1. Visit https://atomgit.com and log in
2. Click avatar (top right) → Personal Settings
3. Find "Access Tokens" option
4. Click "New Access Token", check `repo` and `pull_request` permissions
5. Copy and save the token immediately (shown only once)

### Repository Configuration

The `config.json` in the repository root stores AtomGit API configuration:

```json
{
  "atomgit": {
    "token": "$ATOMGIT_TOKEN",
    "owner": "openEuler",
    "repo": "mugen",
    "baseUrl": "https://api.atomgit.com"
  }
}
```

## Execution Steps

### 1. Create PR

**Trigger**: "create PR", "提交PR", "创建PR", "submit PR"

1. Determine source branch: `git branch --show-current`
2. Determine target branch: usually `master` (confirm with user if unsure)
3. Ensure all commits are pushed to origin (personal fork):
   - `git push origin <branch>`
4. Gather PR context:
   - `git log --oneline <target-branch>..HEAD` — list all commits in the PR
   - `git diff --stat <target-branch>..HEAD` — list changed files
   - `git diff <target-branch>..HEAD` — full diff for analysis
5. Compose PR description (Chinese by default, unless user requests English):
   - **Summary**: 1-3 bullet points of main changes
   - **Test Results**: If test results are available, include them
   - **Commit List**: List all commits with their headers
6. Create PR via AtomGit API or provide direct link:
   ```
   https://atomgit.com/<username>/mugen/pull/new?source=<source-branch>&target=master
   ```
7. If using API (requires `ATOMGIT_TOKEN`):
   ```bash
   curl -s -X POST "https://api.atomgit.com/api/v1/repos/openEuler/mugen/pulls" \
     -H "Authorization: token $ATOMGIT_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{
       "title": "<pr-title>",
       "head": "<username>:<source-branch>",
       "base": "master",
       "body": "<pr-description>"
     }'
   ```
8. Return the PR URL to the user.

### 2. Fetch PR Info

**Trigger**: "get PR info", "查看PR", "check PR status", "检查PR状态"

1. Parse PR number from user input or URL.
2. Fetch PR details via API:
   ```bash
   curl -s "https://api.atomgit.com/api/v1/repos/openEuler/mugen/pulls/<PR_NUMBER>" \
     -H "Authorization: token $ATOMGIT_TOKEN"
   ```
3. Summarize: title, status, mergeable, commit count, file count, review status.

### 3. Update PR Description

**Trigger**: "update PR description", "更新PR描述", "refresh PR"

1. Fetch existing PR info (step 2 above).
2. Gather latest commit context from local repo.
3. Regenerate PR description covering all commits.
4. Update PR via API:
   ```bash
   curl -s -X PATCH "https://api.atomgit.com/api/v1/repos/openEuler/mugen/pulls/<PR_NUMBER>" \
     -H "Authorization: token $ATOMGIT_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"body": "<updated-description>"}'
   ```

### 4. List PRs

**Trigger**: "list PRs", "列出PR", "show my PRs"

1. List open PRs:
   ```bash
   curl -s "https://api.atomgit.com/api/v1/repos/openEuler/mugen/pulls?state=open" \
     -H "Authorization: token $ATOMGIT_TOKEN"
   ```
2. Format as table: PR#, Title, Status, Author, Updated.

### 5. Close/Reopen PR

**Trigger**: "close PR", "关闭PR", "reopen PR"

1. Close: `PATCH .../pulls/<PR_NUMBER>` with `{"state": "closed"}`
2. Reopen: `PATCH .../pulls/<PR_NUMBER>` with `{"state": "open"}`

## PR Description Template

```markdown
## Summary
<1-3 bullet points describing main changes>

## Changes
<List of commits with headers, grouped by area>

## Test Results
<If available, include test execution results>

## Checklist
- [ ] Commits follow openEuler Embedded commit specification
- [ ] All changes tested on QEMU aarch64 devices
- [ ] No build artifacts committed
- [ ] Signed-off-by present in all commits
```

## Cross-Repository Support

For PRs in other repositories, use `--owner` and `--repo` parameters or parse from URL:
```bash
curl -s "https://api.atomgit.com/api/v1/repos/<owner>/<repo>/pulls" \
  -H "Authorization: token $ATOMGIT_TOKEN"
```

## Error Handling

- **401 Unauthorized**: Token invalid or expired. Remind user to regenerate token.
- **404 Not Found**: PR number or repository path incorrect.
- **409 Conflict**: PR already exists for this branch.
- **422 Unprocessable**: Branch not pushed to remote or branches identical.
