---
name: mugen-git-flow
description: >
  Handles Git commit and push workflow with openEuler Embedded commit specification compliance.
  Use when user asks to 'git commit', 'git push', '提交代码', '推送代码', 'git status',
  'commit -s', 'DCO sign-off', 'check git message', 'euler compliance', '符合规范',
  'commit changes', '提交', '检查提交信息', '整理commit', 'reorganize commits',
  'push to fork', 'push to remote', or when preparing code for submission to mugen repository.
  Triggers for 'squash commits', 'rebase', 'amend commit', '修改提交信息', '重写历史'.
---

# mugen Git Workflow Guide

This skill automates code commit process for the **mugen** test framework repository
(`https://atomgit.com/openeuler/mugen`). The commit process enforces openEuler Embedded
commit message specification.

Reference: https://pages.openeuler.openatom.cn/embedded/docs/build/html/master/developer_guide/commit.html

## Core Specifications

### 0. Commit Scope — Only Commit What You Changed

Do NOT blindly `git add .` and commit everything. Before staging, carefully inspect
`git diff` and `git status` to ensure only files related to the current task are included.

**Build artifacts exclusion rule:**

The following are build artifacts and must NEVER be committed:
- `*/tmp_test.tar` — compiled test binaries
- `*/tmp_download/` — downloaded source code
- `*/tmp_extract/` — extracted source code
- `*/tmp_test/` — extracted test data
- `testcases/embedded-test/third_party_packages_test/make` — cross-compiled make binary
- `testcases/embedded-test/version_basic_tests/make` — cross-compiled make binary
- `*.ko`, `*.o`, `*.mod`, `*.mod.c`, `*.mod.o` — kernel module build artifacts
- `tmp_0_*` — temporary combination files

Practical rule:
1. Review `git status` output carefully.
2. Stage only the files that belong to the current task using `git add <specific-paths>`.
3. If build artifacts appear in `git status`, exclude them with `.gitignore` or `git restore --staged`.
4. If unrelated files (not part of the current task) appear modified, skip them unless the user asks to include them.

### 1. Commit Message Format

Must strictly follow this structure with exactly one blank line between sections:

```
<area>: <subject>

<body>

<footer_tags>
```

**Header (`<area>: <subject>`):**
- Format: `<area>: <brief description>` (e.g., `mugen: Fix SSH remote execution`)
- Length limit: Non-revert commits max 80 chars, revert commits max 102 chars
- `area` is the file path or recipe name being changed (e.g., `mugen`, `os_basic_tests`,
  `third_party_packages_test`, `version_basic_tests`, `common_libs`)
- `subject` must use imperative present tense (e.g., "Fix" not "Fixed" or "Fixes")
- Subject must have at least 3 words, no trailing punctuation
- Exactly one space after colon
- No emojis, no Chinese characters in header
- For major changes (API breaks, version upgrades), add `!` after area: `mugen!: ...`

**Body:**
- Must provide detailed description explaining "why" (motivation), "what" (changes), and
  "how" (implementation approach), contrasted with previous behavior
- Each line max 100 characters (unless containing URL)
- No Chinese characters in body
- Can use bullet points with `*` or `-`, with hanging indent for readability
- If commit crosses 5 files or 50 lines, describe it in the body
- Can reference previous commits with 12-char SHA-1 and original header

**Footer (Tags):**
- Must include `Signed-off-by: Name <email>` (DCO sign-off, mandatory)
- `Signed-off-by` must be the last line
- Allowed tags: `Fixes`, `Closes`, `Co-developed-by`, `Link`
- Tags must start with capital letter, one space after colon
- `Fixes` format: `Fixes: <12-char-SHA1>(<original-commit-title>)`
- `Closes` format: `Closes: <full-issue-url>`

### 2. Revert Commit Format

```
revert: <12-char-SHA1>(<original-header>)

<reason for revert>

Signed-off-by: <name> <email>
```

### 3. Cherry-pick Commit

If commit is obtained via `git cherry-pick`, use `-x` flag to auto-generate source info:
```
(cherry picked from commit <full-SHA1>)
```
This line must be placed immediately after `Signed-off-by` with no blank line between them.

### 4. Mandatory Requirements

- All commits must be signed: Use `git commit -s` to auto-add `Signed-off-by` to footer
- Remote repositories:
  - `origin`: Personal fork (for pushing code)
  - `upstream`: Main project repo `https://atomgit.com/openeuler/mugen` (for submitting PRs)
- Suggest max 10 commits per Pull Request

## Execution Steps

### Status Determination

If user explicitly requests local commit only (e.g., "commit to local", "only commit no push"),
execute only Phase 1, 2, and local commit part of Phase 3. Skip push to remote and PR creation.

### Phase 1: Check and Summarize

1. Run `git status` in the repository root.
2. Run `git diff --stat` to see changed files summary.
3. Run `git log --oneline -5` to see recent commit history for style reference.
4. Summarize pending changes to user, noting:
   - Modified files (with categories: framework, test cases, configs)
   - New untracked files (distinguish source files from build artifacts)
   - Deleted files
5. If build artifacts are present, remind user they should not be committed.

### Phase 2: Compose Commit Message

1. Help user draft commit message (Title, Body, Footer) following specifications above.
2. Validate:
   - Title length ≤ 80 chars
   - Title format `<area>: <subject>` with exactly one space after colon
   - Subject uses imperative present tense
   - At least 3 words in subject
   - No trailing punctuation in subject
   - No Chinese characters
   - Blank lines between header/body and body/footer
3. Confirm staging scope: Show the user which files will be committed, explicitly noting
   any excluded files (especially build artifacts).
4. If multiple logical groups of changes exist, suggest splitting into multiple commits.

### Phase 3: Execute Commit and Push

1. Stage only the relevant files: `git add <specific-paths>` (NOT `git add .`).
2. If build artifacts were accidentally staged, unstage them:
   `git restore --staged <build-artifact-paths>`.
3. Verify staging area with `git diff --cached --stat` before committing.
4. Run `git commit -s -m "<message>"` or `git commit -s` for interactive editor.
5. If NOT "local commit only":
   - Execute `git push origin <branch>` (use `--force-with-lease` for amend push).
   - Get remote info: Extract username and repo name via `git remote get-url origin`.
   - Suggest creating PR via mugen-atomgit-pr skill or provide direct link:
     `https://atomgit.com/<username>/mugen/pull/new/<branch>`.

### Phase 4: Reorganize Commits (when requested)

If user asks to reorganize/squash/rebase commits (e.g., "整理commit", "squash commits"):
1. Identify the base commit: `git log --oneline` to find the starting point.
2. Soft reset to base: `git reset --soft <base-commit>`.
3. Unstage all: `git reset HEAD`.
4. Clean up build artifacts if any.
5. Stage and commit in logical groups, following the commit message specification.
6. Each commit should represent a coherent, self-contained change.

## Common Commands Reference

- Signed commit: `git commit -s -m "<message>"` or `git commit -s` (opens editor)
- Push to personal fork: `git push origin <branch>`
- Force push (amend): `git push origin <branch> --force-with-lease`
- Undo last commit (keep changes): `git reset --soft HEAD~1`
- Soft reset to base: `git reset --soft <base-commit>`
- Check staged changes: `git diff --cached --stat`
- Unstage specific files: `git restore --staged <paths>`
