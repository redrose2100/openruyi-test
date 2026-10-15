# commit 规范说明

本文定义本仓库的 commit message 规范，以及流水线中的校验方式。

## 1 采用的标准

本仓库采用 **Conventional Commits（通用提交规范）**。

## 2 提交信息格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

- `<type>`：必填，见第 3 节。
- `<scope>`：可选，用括号括起来，表示影响范围，例如 `suite2cases`、`ci`。
- `<subject>`：必填，冒号后**必须有一个空格**。
- `<body>`：可选，与 header 之间空一行。
- `<footer>`：可选，用于声明破坏性变更等。

## 3 允许的 type

| type | 含义 |
| --- | --- |
| `feat` | 新增功能 |
| `fix` | 修复缺陷 |
| `docs` | 文档变更 |
| `style` | 代码格式调整，不影响逻辑 |
| `refactor` | 重构，既不新增功能也不修复缺陷 |
| `perf` | 性能优化 |
| `test` | 测试相关 |
| `build` | 构建系统或依赖变更 |
| `ci` | CI 配置或脚本变更 |
| `chore` | 其他杂项 |
| `revert` | 回滚提交 |

使用上表以外的 type 会被判定为不合规。

## 4 破坏性变更

有两种写法，任选其一：

- header 中加 `!`，例如 `fix(suite2cases)!: 调整用例条目结构`
- 在 footer 中声明：

```
BREAKING CHANGE: 用例条目结构发生变化
```

## 5 长度限制

**header（首行）长度不得超过 100 个字符。**

## 6 免检提交

以下自动生成的提交不参与校验：

- `Merge ...`
- `Revert ...`
- `fixup! ...`
- `squash! ...`
- `amend! ...`

## 7 明确允许的写法

- **subject 允许使用中文。**
- **不要求** `Signed-off-by`（不强制 DCO）。
- **不限制** subject 的词数、也不禁止首字母大写。

## 8 校验范围

流水线只校验**本次 push 或本次 PR 中新增的提交**，不会回溯校验历史提交：

- `push` 场景：校验 `before..after` 范围内的提交。
- `pull_request` 场景：校验 base 与 head 之间的提交。
- 新分支首次推送时没有 `before`，此时降级为只校验最新一个提交，并输出一条 warning。

## 9 示例

合规：

```
feat(suite2cases): 增加 json 用例一致性校验脚本
fix(ci): 修正 push 场景下的 diff 范围计算
docs: 补充提交规范说明
chore(deps): 升级 actions/checkout 到 v4
```

不合规：

```
增加 json 用例一致性校验脚本          # 缺少 type
feat:增加校验脚本                    # 冒号后缺少空格
unknown: 一些改动                    # 未知的 type
chore: 修正问题。                    # subject 以句号结尾
```

## 10 校验脚本

脚本位置：`.github/scripts/check_commit_msg.py`。

### 10.1 使用方式

```bash
# 校验两次提交之间的提交
python3 .github/scripts/check_commit_msg.py --rev-range v1.0..v1.1

# 本地用消息文件测试，多条消息之间用单独一行 '---' 分隔
python3 .github/scripts/check_commit_msg.py --messages-file /tmp/messages.txt
```

### 10.2 退出码

| 退出码 | 含义 |
| --- | --- |
| 0 | 全部合规，或没有需要校验的提交 |
| 1 | 存在不合规提交 |
| 2 | 内部错误（例如 `git log` 执行失败） |

### 10.3 GitHub Annotations

在 GitHub Actions 环境下，不合规的提交会以 `::error title=commit message::...` 注解的形式输出。
可通过 `--github-annotations` / `--no-github-annotations` 强制控制。
