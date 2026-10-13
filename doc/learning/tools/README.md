# doc/learning 自动化刷新机制（tools/）

本文档目录（`doc/learning/`）是**代码事实分析产物**。为了让它在两类场景下**永远保持最新**：

1. **你在本仓库提交新内容**（新增/修改测试用例、测试套、框架代码）；
2. **源仓库 openEuler/mugen 上游合入了他人新提交**（你的 fork 落后于上游）；

本目录提供一条**一键/自动**流水线：同步上游 → 重新扫描仓库 → 重新生成全部文档 → 提交 → 推送 fork。

---

## 1. 流水线组成

| 文件 | 作用 |
|------|------|
| `collect.py` | 扫描 `suite2cases/` + `testcases/`，生成 `data/` 数据快照（`case_extract.json`、`suite_catalog_expanded.json`、`subject_map.json`、`stats.json`） |
| `render.py` | 用 `data/stats.json` 渲染 `templates/` 中的章节 → 覆盖 `doc/learning/` 根目录章节 |
| `gen_appendix.py` | 生成 `09-附录-全量测试套清单.md`（套件全枚举） |
| `gen_features.py` | 生成 `features/` 逐特性文档（每套件一份 + 索引 README） |
| `verify_render.py` | 渲染后自检：无残留占位符、关键数字齐全、mermaid 括号配平 |
| `update_docs.sh` | **编排入口**：`--all / --prepush / --regen-only / --sync / --regen` |
| `hooks/pre-push` | git 钩子：推送 master 时自动执行 `update_docs.sh --prepush` |
| `setup_automation.ps1` | 一次性配置：添加 `upstream` 远端 + 启用钩子 + 创建计划任务 |
| `run_daily.ps1` | Windows 计划任务每日调用 `update_docs.sh --all` |
| `templates/` | **手写章节的权威源**（带 `{{占位符}}`，由 render.py 填充） |
| `data/` | 最新数据快照（提交入库，便于追溯） |
| `logs/` | 计划任务运行日志 |

依赖：`git`、`python`（Windows 下请在 **git-bash** 中运行 `bash` 脚本）。

## 2. 章节谁在管？

| 章节 | 来源 |
|------|------|
| `README.md`、`00`、`06`、`07`、`08`、`10`、`11` | **模板驱动**：`templates/` 同名文件 + `data/stats.json` 自动渲染 |
| `09-附录`、`features/` | **全自动生成**（collect → gen_appendix/gen_features） |
| `01`、`02`、`03`、`04`、`05` | **人工精读章节**：框架结构/函数级分析，不随测试内容自动变化 |

> ⚠️ **不要直接修改渲染产物章节**（README/00/06/07/08/10/11 与 09/features/）——下一次运行会被覆盖。
> 想改文案，请改 `templates/` 中对应的模板文件（保持 `{{占位符}}` 不变）。
> 框架层（`libs/`、`mugen.sh` 等）变化会使 01-05 章结构分析过时，`update_docs.sh` 会在提交信息里给出"需人工复核"警告。

## 3. 用法

### 3.1 一次性配置（只需一次）

```bash
# 在 git-bash 中，仓库根目录
powershell -ExecutionPolicy Bypass -File doc/learning/tools/setup_automation.ps1
```

该脚本会：
- 添加 `upstream = https://gitcode.com/openeuler/mugen.git`（源项目）；
- 设置 `git config core.hooksPath doc/learning/tools/hooks`；
- 创建 Windows 计划任务 `mugen-docs-refresh`（默认每日 08:00）。

### 3.2 日常使用

```bash
# 手动一键：同步上游 → 刷新文档 → 提交 → 推送个人 fork（origin/master）
bash doc/learning/tools/update_docs.sh --all

# 只同步上游（不刷新不推送）
bash doc/learning/tools/update_docs.sh --sync

# 只刷新+提交（离线场景）
bash doc/learning/tools/update_docs.sh --regen-only

# 推送到 fork 时自动触发（无需手动）：git push origin master
```

### 3.3 触发方式汇总

| 触发 | 机制 | 说明 |
|------|------|------|
| 你 `git push origin master` | pre-push 钩子 → `--prepush` | 推送前同步上游 + 刷新 + 提交（文档随推送一起更新） |
| 每天定时 | Windows 计划任务 → `--all` | 即使你没有推送，上游新提交也会在每日刷新时同步进来 |
| 手动 | `update_docs.sh --all` | 随时强制执行 |

## 4. 数据口径（与文档一致）

- **域**：按 `suite2cases` JSON `path` 中 `testcases/<域>/` 首段推导（`category` 为 `?` 的套件：`security_test`/`smoke`/`smoke-syscare`/`testsuite` 据此归位）。
- **类型粗分**：`stats_dim` 同款关键字顺序匹配（功能/安全/配置/可靠性/兼容/性能），仅作量级参考。
- **主题分类**：套件名词边界关键词匹配（`subject_map.json`），全库 + 按域两套口径。
- **孤儿**：脚本名不在任何注册用例名集合中（`879` 个；其中 503 个含 `run_test`，376 个辅助/库）。
- **缺失**：注册用例在套件路径下无对应脚本（`41` 个：secscanner 40 + kata-containers 1）。

## 5. 排障

| 现象 | 处理 |
|------|------|
| `update_docs.sh` 报 merge 冲突 | 手工解决冲突后重跑 `--all` |
| `python` 找不到 | 确认 git-bash 的 PATH 含 python；或改用 `py`/绝对路径 |
| 计划任务日志 | 查看 `tools/logs/daily_*.log` |
| 渲染后仍有 `{{XXX}}` | 说明模板新增了占位符但 render.py 未定义，检查 `render.py` 的 `ctx` |
| 钩子未生效 | 确认 `git config core.hooksPath` 指向 `doc/learning/tools/hooks` |
