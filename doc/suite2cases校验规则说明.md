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
| 9 | 用例脚本需要多台机器时（`NODE2_`~`NODE9_`、`TEST_NIC N`、`TEST_DISK N`、`--node N`、`REMOTE_REBOOT N`），生效的 `machine num` 必须足够大 |
| 10 | 用例脚本经 disk 库取盘时，生效的 `add disk` 列表长度必须覆盖脚本实际用到的 `local_diskN` 数量 |
| 11 | 用例脚本自己取非主网卡时（`get_free_eth N` / `ls /sys/class/net/` / `TEST_NIC` / `${NODE1_NIC[i]}`），生效的 `add network interface` 必须足够大 |
| 12 | 用例脚本依赖物理机独占能力时（`/dev/ipmi*`、`ipmitool`、SR-IOV），生效的 `machine type` 必须是 `physical` |

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

### 3.3 运行时风险检查（规则 9~12）

这四条规则会读取用例脚本内容，判断「脚本实际需要」是否被「声明值」覆盖。
它们才是**真正会导致用例运行失败**的检查项：

| 编号 | 触发条件 | 含义 |
| --- | --- | --- |
| 规则 9 | 脚本中出现多机信号，且最大编号 > 生效的 `machine num` | 脚本要操作第 N 台机器，但环境只申请了更少的机器 |
| 规则 10 | 脚本经 disk 库取盘，且生效的 `add disk` 长度 < 脚本实际需要的盘数 | 脚本要操作 N 块测试盘，但没有申请足够的磁盘 |
| 规则 11 | 脚本自己取非主网卡，且生效的 `add network interface` < 实际张数 | 脚本要操作额外网卡，但没有申请足够的网卡 |
| 规则 12 | 脚本依赖物理机独占能力，但生效的 `machine type` 不是 `physical` | 脚本要的设备在 KVM 上根本不存在 |

**规则 9 的多机信号清单**（四类都要算，缺一个就会漏检）：

| 信号 | 说明 |
| --- | --- |
| `NODE2_` ~ `NODE9_` | 直接引用第 N 台节点的环境变量 |
| `TEST_NIC N` / `TEST_DISK N` | **N 是节点号，不是网卡/磁盘张数**，见 `get_test_device.py` 的 `--node` 参数 |
| `--node N` | `P_SSH_CMD` / `P_SFTP` 等显式指定第 N 台 |
| `REMOTE_REBOOT N` / `REMOTE_REBOOT_WAIT N` | 重启第 N 台 |

> 重点坑：`TEST_NIC 2` 的语义常被误解为「需要 2 张网卡」，实际是「需要第 2 台机器上的额外网卡」。
> 依据：`libs/locallibs/common_lib_python.sh` 中 `TEST_NIC() { id=${1-1}; ... --node "$id"; }`，
> 以及 `libs/locallibs/get_test_device.py` 中 `node (int): 节点号`。

规则 10 的判定细节：

- **只有经 disk 库取盘的脚本才参与检查**，判定依据是脚本命中以下任一特征：
  出现 `TEST_DISK`，或 `source` 了 `disk_lib.sh` / `storage_disk_lib.sh` /
  `mdadm/common/common.sh`。有些脚本自己用 `lsblk` 算盘名，与 `add disk`
  声明无关，不参与本规则。
- **所需盘数由 `local_diskN` 推断**：只出现 `local_disk` 记 1 块，出现
  `local_disk1` 记 2 块，`local_disk2` 记 3 块，`local_disk3` 记 4 块，取最大值。
- `add disk` 为空列表时报 `add disk missing`；不为空但长度不够时报
  `add disk too small`，并在错误信息中同时给出「需要」与「实得」。

> 常见错例：脚本里写 `genfio -d /dev/${local_disk},/dev/${local_disk1},/dev/${local_disk2}`
> 却只声明两块盘。此时 `${local_disk2}` 为空，命令退化成操作 `/dev/` 目录。

> 说明：这里的「生效值」= 用例自己声明的值，未声明时取外层值（受继承规则影响）。

规则 11 的判定细节：

- `add network interface` 的语义是「**除主网卡之外额外申请**的网卡张数」，
  主网卡由 `NODE1_NIC` 提供，不占用这个额度。
- 触发信号与折算方式：

  | 信号 | 折算所需额外网卡数 | 依据 |
  | --- | --- | --- |
  | `get_free_eth N` | N | 用例自带的 `net_lib.sh` 中 `[ ${#LOCAL_ETH[@]} -ge ${num_eth} ] \|\| exit 1` |
  | `ls /sys/class/net/` + 过滤主网卡 | 1 | 脚本用 `grep -v "${NODE1_IPV4}"` 排除主网卡后取一张 |
  | `TEST_NIC N` | 1 | 返回该节点除主网卡外的网卡名，非空即必须有 1 张 |
  | `${NODE1_NIC[i]}` / `${NODE1_NIC[@]}` | 1 | 取额外网卡数组 |

- 多处信号取**最大值**，不做累加（同一张网卡会被不同语句重复引用）。
- 只引用 `${NODE1_NIC}`（不带下标）视为使用主网卡，不需要额外网卡，不参与本规则。

> 常见错例：脚本用
> `test_eth1=$(ls /sys/class/net/ | grep -vE 'lo\|bond\|vlan' | grep -v "$(ip route ... ${NODE1_IPV4} ...)" | sed -n 1p)`
> 取一张非主网卡，但 JSON 里把 `add network interface` 声明成 `0`。此时 `test_eth1` 为空，
> 后面的 `ip addr add ... dev "${test_eth1}"` 会直接失败。

规则 12 的判定细节：

- 只收**在 KVM 上必然拿不到**的特征，避免把「验证包自身功能」的用例误判成需要物理机：

  | 信号 | 说明 |
  | --- | --- |
  | `/dev/ipmi*` | IPMI 设备节点，虚拟机不提供 |
  | `ipmitool` | 依赖前者的带外管理工具 |
  | `sriov_numvfs` / `/sys/class/net/*/device/sriov` | SR-IOV 虚拟功能，需物理网卡支持 |

- **刻意排除**以下信号，它们不能作为「需要物理机」的判据：

  | 信号 | 排除原因 |
  | --- | --- |
  | `/dev/mem`、`dmidecode`、`lspci` | KVM 上均可正常执行，用例本身就是在验证命令可用性 |
  | `/dev/mcelog` | 用例自带 `! -e /dev/mcelog` → `exit 255` 的优雅跳过，缺设备只会 skip 不会 fail |

> 判定原则：**缺设备会导致用例 fail 才算缺陷；只导致 skip 的不算**。
> 因此给带跳过保护的用例强制声明 `physical` 只会浪费物理机资源。

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

### 6.3 额外网卡与物理机要求落地时的修正

引入规则 11~12、并把规则 9 的多机信号补全为四类后，重新做了一次
「声明值 vs 脚本实际需求」的全量审计（514 个套件、4166 个带脚本的用例），
四个维度结果如下：

| 维度 | 检查项 | 不合规数 |
| --- | --- | --- |
| 机器数 | 规则 9（四类多机信号） | 0 |
| 额外网卡 | 规则 11 | 7 |
| 额外磁盘 | 规则 10 | 0 |
| 机器类型 | 规则 12 | 0 |

7 条不合规全部集中在同一个文件，已一并修正：

| 文件 | 用例 | 问题 | 处理 |
| --- | --- | --- | --- |
| `function-test/basic-test/admin_guide.json` | `oe_test_ip_cmd_addr` | 脚本 L25 用 `ls /sys/class/net/` 排除主网卡取一张，声明为 0 | `add network interface` 由 `0` 改为 `1` |
| 同上 | `oe_test_ip_cmd_route` | 同上 | 同上 |
| 同上 | `oe_test_ip_cmd_rule` | 同上 | 同上 |
| 同上 | `oe_test_ip_config_mtu` | 同上 | 同上 |
| 同上 | `oe_test_ip_config_multiple_address` | 同上 | 同上 |
| 同上 | `oe_test_ip_config_static_address` | 同上 | 同上 |
| 同上 | `oe_test_ip_config_static_route` | 同上 | 同上 |

修改后 `python3 .github/scripts/check_suite_cases.py --all` 返回 0 错误。

> 这 7 个用例原本显式声明了 `"machine num": 1, "add network interface": 0`，
> 属于**用例级覆盖**，会把套件外层的 `"add network interface": 2` 覆盖掉，
> 所以只看套件外层声明是查不出问题的——必须按脚本实际需求逐用例核对。

两个**经核实不属于缺陷**的候选，此处记录判定依据，避免后续重复排查：

| 候选 | 被误判的原因 | 实际判定 |
| --- | --- | --- |
| `function-test/pkgs-test/mcelog.json` | 脚本引用 `/dev/mcelog` | 脚本自带 `! -e /dev/mcelog` → `exit 255` 优雅跳过，缺设备只会 skip，不需要 `physical` |
| `function-test/pkgs-test/dmidecode.json` | `oe_test_biosdecode` 执行 `biosdecode -d /dev/mem` | `/dev/mem` 在 KVM 上同样存在，命令可正常执行，不需要 `physical` |
