# AI Agent 技能库 (Skills)

此目录包含了专为 AI Agent（如 Claude Code、OpenCode 等）设计的技能插件，用于自动化 mugen 测试框架项目中的各种开发工作流。每个技能都定义了精准的触发条件（Description），并提供了执行复杂任务所需的工具和上下文。

## 技能清单

| 技能名称 | 分类 | 主要触发场景 (Triggers) |
|----------|------|------------------------|
| [mugen-git-flow](./mugen-git-flow) | 工作流 | 提交代码、推送至个人仓库、整理commit、确保符合 openEuler DCO/Commit 规范。 |
| [mugen-atomgit-pr](./mugen-atomgit-pr) | AtomGit | 管理 PR 生命周期：创建、读取上下文、更新描述、列出、关闭/重开。 |

## 技能分类说明

### 工作流

- **工程规范 ([mugen-git-flow](./mugen-git-flow))**: 自动化执行 openEuler Embedded 社区的提交规范校验。涵盖 git commit、git push、commit message 格式验证、DCO sign-off、build artifact 排除、commit 重组等场景。参照 [openEuler Embedded 代码提交指导](https://pages.openeuler.openatom.cn/embedded/docs/build/html/master/developer_guide/commit.html) 规范。

### AtomGit 自动化工具

- **PR 工作流 ([mugen-atomgit-pr](./mugen-atomgit-pr))**: 管理 mugen 仓库在 AtomGit 上的 PR 全生命周期，包括创建、读取详情、更新描述、列表查询、关闭/重开。通过 AtomGit REST API 实现，支持跨仓库 PR 操作。

> **前置条件：配置 AtomGit Token**
>
> 使用 AtomGit 相关技能前，必须先配置 Personal Access Token：
>
> 1. 访问 https://atomgit.com 并登录
> 2. 点击右上角头像 → 个人设置
> 3. 找到「访问令牌」选项
> 4. 点击「新建访问令牌」，勾选 `repo` 和 `pull_request` 权限
> 5. **立即复制保存** Token（只显示一次）
>
> 设置环境变量：
> ```bash
> export ATOMGIT_TOKEN="your_token_here"
> ```
>
> Token 配置存储在项目根目录的 `config.json` 中，通过环境变量 `$ATOMGIT_TOKEN` 引用。

## 如何增加新技能

若要向本项目添加新技能，请遵循以下步骤：

1. 在 `.agents/skills/` 下创建一个新目录。
2. 添加 `SKILL.md` 文件，确保 `description` 字段采用 **if-then** 条件触发风格（包含中英双语关键词），并在涉及第三方平台时明确写出平台优先级。
3. 编写技能所需的配套脚本（Python/Bash）或库文件。
4. 更新此 `README.md` 文件，将新技能添加到清单表格中。
