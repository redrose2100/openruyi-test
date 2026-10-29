# suite2cases 校验规则说明

本文说明 `suite2cases/` 目录下 JSON 文件的校验规则、校验脚本的用法，以及流水线中的执行策略。

## 1 规则总览

| 编号 | 规则 |
| --- | --- |
| 1 | `suite2cases/` 下的 JSON 文件必须是合法 JSON，能被正常解析 |
| 2 | JSON 中 `path` 指向的目录必须存在 |
| 3 | JSON 中 `cases` 里声明的每个用例名，都必须能在 `path` 指向的目录**及其子目录**中找到同名 `.sh` 文件 |
| 4 | `suite2cases/testsuite.json` 永久忽略，不做任何校验，也不做任何处理 |
| 5 | 套件外层 `machine num` 必须大于等于 `cases` 中每个用例的 `machine num` |
| 6 | 套件外层 `add network interface` 必须大于等于 `cases` 中每个用例的值 |
| 7 | `cases` 中任一用例声明 `machine type` 为 `physical`，套件外层 `machine type` 必须为 `physical` |
| 8 | `cases` 中每个用例使用的 `add disk` 取值，必须都被套件外层 `add disk` 列表覆盖 |
| 9 | 用例脚本引用 `NODE2_`~`NODE9_` 时，生效的 `machine num` 必须足够大 |
| 10 | 用例脚本引用 `TEST_DISK` 时，生效的 `add disk` 列表长度必须大于 0 |

## 2 校验规则详解

### 2.1 JSON 格式

- 文件必须能被 JSON 解析器正常读取。
- 顶层必须是对象，并且包含：
  - `path`：字符串类型。
  - `cases`：数组类型。
- 解析失败时会输出出错的行号与列号。

### 2.2 path 目录存在性

`path` 通常写成 `${OET_PATH}/testcases/xxx` 或 `$OET_PATH/testcases/xxx`。

校验脚本会把 `${OET_PATH}`、`$OET_PATH` 去掉，再拼到仓库根目录上，检查该目录是否存在。
写法上的差异不影响校验结果。

### 2.3 用例脚本存在性（重要）

判断规则：`cases` 中每个 `name` 对应的脚本文件名为 `name + ".sh"`。

查找范围是 `path` 目录**以及其所有子目录**（递归查找），因为仓库里用例存在两种存放形式：

- 用例直接放在 `path` 目录下：`<path>/<用例名>.sh`
- 用例放在与用例同名的子目录下：`<path>/<用例名>/<用例名>.sh`

> 注意：如果只查 `path` 顶层目录，仓库中会有 570 多个用例被误报为"脚本缺失"。
> 因此**必须递归查找**。

用例名比较时不区分大小写。

### 2.4 testsuite.json 永久忽略

`suite2cases/testsuite.json` 是团队约定的特殊文件，遵循以下**永久规则**：

- 校验脚本跳过它，不做 JSON 格式检查，也不检查其中声明的用例。
- 流水线中即使该文件发生变动，也不会对它执行任何检查。
- 后续所有与 `suite2cases` 相关的操作（脚本、流水线、工具）都必须遵循这一条。

## 3 字段一致性与运行时风险

### 3.1 字段的继承语义（重要）

规则 5~10 的依据是 `libs/locallibs/check_environment.py`。该文件对四个字段的取值方式为：

| 字段 | 生效值 | 不满足时的后果 |
| --- | --- | --- |
| `machine num` | `case.get('machine num', suite.get('machine num', 1))` | 实际机器数 < 声明值时 `sys.exit(1)` |
| `machine type` | `case.get('machine type', suite.get('machine type', 'kvm'))` | 实际为 `kvm` 而声明 `physical` 时失败 |
| `add network interface` | `case.get('add network interface', suite.get('add network interface', 0))` | 实际网卡数 < 声明值时 `sys.exit(1)` |
| `add disk` | `len(case.get('add disk', suite.get('add disk', [])))` | 实际磁盘数 < 列表长度时 `sys.exit(1)` |

两个关键结论：

1. **用例内层字段优先于套件外层字段。** 只要用例自己声明了该字段，外层写什么都不影响这个用例的运行。
   因此规则 5~8 属于**语义自洽性检查**，不是运行时崩溃点。
2. **`add disk` 只取列表长度。** 列表里的数值（磁盘大小，单位 GB）不参与任何判断，
   所以规则 8 检查的是「用例用到的值是否被外层列表包含」，属于文档语义问题。

> 注意：如果外层被写成更大更严格的值，那么**所有没有显式声明该字段的用例都会连带继承**这个新值。
> 修改外层字段时需要一并评估这一影响。

### 3.2 字段一致性规则（规则 5~8）

- 用例未声明某字段时，按上表的默认值与继承关系处理；外层缺失时视为取默认值
  （`machine num` 默认 1、`machine type` 默认 `kvm`、`add network interface` 默认 0、`add disk` 默认空列表）。
- 规则 7 的大小写不敏感比较：`Physical` 与 `physical` 等价。
- 判定为违规时，错误信息会给出用例名、用例值和外层值。

### 3.3 运行时风险检查（规则 9~10）

这两条规则会读取用例脚本内容，判断「脚本实际需要」是否被「声明值」覆盖。
它们才是**真正会导致用例运行失败**的检查项：

| 编号 | 触发条件 | 含义 |
| --- | --- | --- |
| 规则 9 | 脚本中出现 `NODE2_`~`NODE9_`，且最大编号 > 生效的 `machine num` | 脚本要操作第 N 台机器，但环境只申请了更少的机器 |
| 规则 10 | 脚本中出现 `TEST_DISK`，且生效的 `add disk` 列表为空 | 脚本要挂载额外磁盘，但没有申请磁盘 |

> 说明：这里的「生效值」= 用例自己声明的值，未声明时取外层值（受继承规则影响）。

## 4 校验脚本

脚本位置：`.github/scripts/check_suite_cases.py`。

### 4.1 三种执行模式

三种模式互斥，必须且只能指定一个：

| 参数 | 说明 |
| --- | --- |
| `--all` | 校验 `suite2cases/` 下全部 JSON 文件 |
| `--files JSON [JSON ...]` | 只校验指定的 JSON 文件 |
| `--changed-from REF [--changed-to REF]` | 校验相对于 `REF` 有变动的 JSON 文件 |

`--files` 传入的非 JSON 文件、以及不在 `suite2cases/` 目录下的文件会被自动忽略。

### 4.2 使用示例

```bash
# 全量校验
python3 .github/scripts/check_suite_cases.py --all

# 只校验指定文件
python3 .github/scripts/check_suite_cases.py --files suite2cases/kata-containers.json

# 校验工作区相对于 HEAD 的改动
python3 .github/scripts/check_suite_cases.py --changed-from HEAD

# 校验两次提交之间的改动
python3 .github/scripts/check_suite_cases.py --changed-from v1.0 --changed-to v1.1
```

### 4.3 退出码

| 退出码 | 含义 |
| --- | --- |
| 0 | 校验通过，或没有任何文件需要校验 |
| 1 | 存在校验错误 |
| 2 | 内部错误（例如 `git diff` 执行失败） |

### 4.4 输出说明

- 每条错误一行，以 `ERROR ` 开头。
- 结果汇总行格式：`checked N suite(s), M case(s); skipped K suite(s); E error(s)`。
- 其中 `skipped` 统计的就是被永久忽略的 `testsuite.json`。

### 4.5 GitHub Annotations

在 GitHub Actions 环境下，脚本会自动输出 `::error file=...,line=...,title=...::...` 形式的注解，
错误会直接标注在 PR 的 diff 对应行上，方便定位。

本地运行时默认不输出注解，可通过以下参数强制控制：

- `--github-annotations`：强制输出注解。
- `--no-github-annotations`：强制关闭注解。

## 5 流水线中的执行策略

流水线文件：`.github/workflows/quality-gate.yml`。

### 5.1 触发条件

- `pull_request`：目标分支为 `dev` 或 `master`。
- `push`：分支为 `dev` 或 `master`。

### 5.2 增量校验

只会校验**本次 push 或 PR 中发生变动**的 `suite2cases/*.json`，而不是全量校验：

- `push` 场景：用 `before..after` 计算变动文件。
- `pull_request` 场景：用 base 与 head 的三点范围计算变动文件。
- 变动的文件被删除（`--diff-filter=D`）时不需要校验。

如果本次改动不涉及 `suite2cases/` 下的 JSON，则跳过校验并以成功结束。

### 5.3 忽略 testsuite.json

流水线在收集变动文件时会显式排除 `suite2cases/testsuite.json`，
与该文件的永久忽略规则保持一致。

## 6 存量问题与本次修正

### 6.1 首次落地时的修正

本次校验首次落地时，仓库中存在 41 条不满足规则 3 的记录，已一并修正：

| 文件 | 问题 | 处理 |
| --- | --- | --- |
| `suite2cases/secscanner.json` | 声明了 300 个用例，其中 40 个没有对应 `.sh` 脚本 | 删除这 40 个用例条目 |
| `suite2cases/kata-containers.json` | 声明的 `oe_test_kata-containers` 没有对应脚本 | 改为真实存在的 `oe_test_kata-containers_kata-runtime` |

修正后 `python3 .github/scripts/check_suite_cases.py --all` 返回 0 错误。

### 6.2 字段一致性与运行时风险落地时的修正

引入规则 5~10 后，全量扫描 1048 个 JSON、6996 个用例，发现 7 个文件共 24 条不合规记录，已一并修正：

| 文件 | 问题规则 | 处理 |
| --- | --- | --- |
| `function-test/pkgs-test/kmod-kvdo.json` | 5、8 | 外层 `add disk` 由 `[130]` 改为 `[10, 130]` |
| `function-test/pkgs-test/libssh.json` | 5 | 外层新增 `"machine num": 2` |
| `function-test/pkgs-test/oedp.json` | 7 | 外层新增 `"machine type": "physical"` |
| `function-test/pkgs-test/libcap.json` | 6 | 外层新增 `"add network interface": 1` |
| `function-test/pkgs-test/sysmonitor-kmod.json` | 6 | 外层新增 `"add network interface": 1` |
| `smoke-test/smoke-baseinfo.json` | 5 | 外层新增 `"machine num": 2` |
| `function-test/pkgs-test/amanda.json` | 9 | 外层新增 `"machine num": 2` |
| `function-test/pkgs-test/cvs.json` | 9 | 外层新增 `"machine num": 2` |
| `function-test/pkgs-test/libfabric.json` | 9 | 外层新增 `"machine num": 2` |
| `function-test/pkgs-test/openscap.json` | 9 | 外层新增 `"machine num": 2` |
| `function-test/pkgs-test/sysSentry.json` | 10 | 外层新增 `"add disk": [10]` |
| `function-test/pkgs-test/firewalld.json` | 9 | 用例 `oe_test_firewalld_log_denied` 的 `machine num` 由 1 改为 2 |
| `function-test/compile-test/compile-test.json` | — | 外层 `machine type` 由 `"Kvm"` 改为 `"kvm"`（统一小写） |

修正后 `python3 .github/scripts/check_suite_cases.py --all` 返回 0 错误。

> 修改 `suite2cases` 下的 JSON 时必须保持原有文件格式（行尾、缩进），
> 不要用工具整体重新序列化，否则会产生大量无意义的 diff。
