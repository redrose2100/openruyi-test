# hwloc_1.11.9

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/hwloc` |
| 注册用例数 | 37 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_hwloc_base_hwloc-info_01 | Test hwloc-info | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-info_02 | Test hwloc-info | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-info_03 | Test hwloc-info | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-info_04 | Test hwloc-info | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-ps_01 | Test hwloc-ps | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-ps_02 | Test hwloc-ps | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-compress-dir | Test hwloc-compress-dir hwloc-gather-topology | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-distrib_01 | Test hwloc-distrib | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-distrib_02 | Test hwloc-distrib | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-bind_01 | Test hwloc-bind | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-bind_02 | Test hwloc-bind | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-bind_03 | Test hwloc-bind | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_hwloc_base_lstopo-no-graphics_01 | Test lstopo-no-graphics | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_hwloc_base_lstopo-no-graphics_02 | Test lstopo-no-graphics | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_lstopo-no-graphics_03 | Test lstopo-no-graphics | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_lstopo-no-graphics_04 | Test lstopo-no-graphics | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_hwloc_base_lstopo-no-graphics_05 | Test lstopo-no-graphics | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_hwloc_base_lstopo_01 | Test lstopo | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_hwloc_base_lstopo_02 | Test lstopo | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_lstopo_03 | Test lstopo | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_lstopo_04 | Test lstopo | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_hwloc_base_lstopo_05 | Test lstopo | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-calc_01 | Test hwloc-calc_1 | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-calc_02 | Test hwloc-calc_2 | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-calc_03 | Test hwloc-calc_1 | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-calc_04 | Test hwloc-calc_03,hwloc-diff | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-annotate | Test hwloc-annotate | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-ls_01 | Test hwloc-ls | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-ls_02 | Test hwloc-ls | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-ls_03 | Test hwloc-ls | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-ls_04 | Test hwloc-ls | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-ls_05 | Test hwloc-ps | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_hwloc_base_others | Test hwloc-gather-topology,hwloc-diff | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_hwloc_base_hwloc-patch | Test hwloc-patch | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_hwloc_1.11.9_hwloc-assembler | Test hwloc-assembler | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_hwloc_1.11.9_hwloc-distances_01 | Test hwloc-distances | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_hwloc_1.11.9_hwloc-distances_02 | Test hwloc-distances | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_hwloc_base_hwloc-info_01

- 描述：Test hwloc-info
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-info -h failed"
  CHECK_RESULT $? 0 0 "hwloc-info --version failed"
  CHECK_RESULT $? 0 0 "hwloc-info --object failed"
  CHECK_RESULT $? 0 0 "hwloc-info -i <file> failed"
  CHECK_RESULT $? 0 0 "hwloc-info -i <directory> failed"
  CHECK_RESULT $? 0 0 "hwloc-info -s failed"
  CHECK_RESULT $? 0 0 "hwloc-info -v failed"
  CHECK_RESULT $? 0 0 "hwloc-info --ancestors failed"
  CHECK_RESULT $? 0 0 "hwloc-info --ancestor <type> failed"
  CHECK_RESULT $? 0 0 "hwloc-info --thissystem failed"
```

- 涉及命令：hwloc-info×5, lstopo×2

#### oe_test_hwloc_base_hwloc-info_02

- 描述：Test hwloc-info
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-info --topology failed"
  CHECK_RESULT $? 0 0 "hwloc-info --support failed"
  CHECK_RESULT $? 0 0 "hwloc-info -p failed"
  CHECK_RESULT $? 0 0 "hwloc-info -l failed"
  CHECK_RESULT $? 0 0 "hwloc-info --children failed"
  CHECK_RESULT $? 0 0 "hwloc-info --descendants <type> failed"
  CHECK_RESULT $? 1 0 "hwloc-info --descendants <type> failed"
  CHECK_RESULT $? 1 0 "hwloc-info --no-icaches failed"
  CHECK_RESULT $? 1 0 "hwloc-info --no-io failed"
  CHECK_RESULT $? 0 0 "hwloc-info --no-bridges failed"
  CHECK_RESULT $? 0 0 "hwloc-info --input-format failed"
```

- 涉及命令：hwloc-info×2, lstopo×1

#### oe_test_hwloc_base_hwloc-info_03

- 描述：Test hwloc-info
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-info -h failed"
  CHECK_RESULT $? 0 0 "hwloc-info --physical failed"
  CHECK_RESULT $? 0 0 "hwloc-info --logical failed"
  CHECK_RESULT $? 0 0 "hwloc-info -v failed"
  CHECK_RESULT $? 0 0 "hwloc-info --slient failed"
  CHECK_RESULT $? 0 0 "hwloc-info -i 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "hwloc-info --whole-system failed"
  CHECK_RESULT $? 0 0 "hwloc-info --input failed"
  CHECK_RESULT $? 0 0 "hwloc-info --input <directory> failed"
  CHECK_RESULT $? 0 0 "hwloc-info --if <format> failed"
```

- 涉及命令：hwloc-info×2, lstopo×1

#### oe_test_hwloc_base_hwloc-info_04

- 描述：Test hwloc-info
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-info -n failed"
  CHECK_RESULT $? 0 0 "hwloc-info --whole-io failed"
  CHECK_RESULT $? 0 0 "hwloc-info --input 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "hwloc-info --restrict <cpuset> failed"
  CHECK_RESULT $? 0 0 "hwloc-info --restrict binding failed"
  CHECK_RESULT $? 0 0 "hwloc-info --pid <pid> failed"
```

- 涉及命令：hwloc-info×1

#### oe_test_hwloc_base_hwloc-ps_01

- 描述：Test hwloc-ps
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-ps -a failed"
  CHECK_RESULT $? 0 0 "hwloc-ps --pid failed"
  CHECK_RESULT $? 0 0 "hwloc-ps -c failed"
  CHECK_RESULT $? 0 0 "hwloc-ps -e failed"
  CHECK_RESULT $? 0 0 "hwloc-ps --name failed"
  CHECK_RESULT $? 0 0 "hwloc-ps -p failed"
  CHECK_RESULT $? 0 0 "hwloc-ps -l failed"
  CHECK_RESULT $? 0 0 "hwloc-ps -t failed"
  CHECK_RESULT $? 0 0 "hwloc-ps --pid-cmd failed"
  CHECK_RESULT $? 0 0 "hwloc-ps --whole-system failed"
```

- 涉及命令：hwloc-ps×7

#### oe_test_hwloc_base_hwloc-ps_02

- 描述：Test hwloc-ps
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-ps --cpuset failed"
  CHECK_RESULT $? 0 0 "hwloc-ps --get-last-cpu-location failed"
  CHECK_RESULT $? 0 0 "hwloc-ps --physical failed"
  CHECK_RESULT $? 0 0 "hwloc-ps --logical failed"
  CHECK_RESULT $? 0 0 "hwloc-ps --threads failed"
```

- 涉及命令：hwloc-ps×2

#### oe_test_hwloc_base_hwloc-compress-dir

- 描述：Test hwloc-compress-dir hwloc-gather-topology
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-compress-dir --verbose failed"
  CHECK_RESULT $? 0 0 "hwloc-compress-dir -v failed"
  CHECK_RESULT $? 0 0 "hwloc-compress-dir -v failed"
  CHECK_RESULT $? 0 0 "hwloc-compress-dir -R failed"
  CHECK_RESULT $? 0 0 "hwloc-compress-dir --reverse failed"
  CHECK_RESULT $? 0 0 "hwloc-compress-dir --reverse failed"
```

- 涉及命令：lstopo×3, hwloc-compress-dir×2

#### oe_test_hwloc_base_hwloc-distrib_01

- 描述：Test hwloc-distrib
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-distrib --ignore failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --from failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --to failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --at failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --reverse failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --restrict failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --whole-system failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --input <xml> failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --input <directory> failed "
  CHECK_RESULT $? 0 0 "hwloc-distrib --version failed"
```

#### oe_test_hwloc_base_hwloc-distrib_02

- 描述：Test hwloc-distrib
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-distrib --input 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib -i 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --input-format failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --if failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --single failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --taskset failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib -v failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib --verbose failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib -i <xml> failed"
  CHECK_RESULT $? 0 0 "hwloc-distrib -i <directory> failed "
```

- 涉及命令：hwloc-distrib×4

#### oe_test_hwloc_base_hwloc-bind_01

- 描述：Test hwloc-bind
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-bind --mempolicy failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --membind failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --version failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --cpubind failed"
  CHECK_RESULT $? 0 0 "hwloc-bind -l failed"
  CHECK_RESULT $? 0 0 "hwloc-bind  --logical failed"
  CHECK_RESULT $? 0 0 "hwloc-bind -p failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --single failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --strict failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --get failed"
```

- 涉及命令：hwloc-bind×2

#### oe_test_hwloc_base_hwloc-bind_02

- 描述：Test hwloc-bind
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-bind --nodeset failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --taskset failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --whole-system failed"
  CHECK_RESULT $? 0 0 "hwloc-bind -v failed"
  CHECK_RESULT $? 0 0 "hwloc-bind -q failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --pid failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --tid failed"
  CHECK_RESULT $? 0 0 "hwloc-bind ---restrict failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --hbm failed"
  CHECK_RESULT $? 0 0 "hwloc-bind -f failed"
```

- 涉及命令：hwloc-bind×3

#### oe_test_hwloc_base_hwloc-bind_03

- 描述：Test hwloc-bind
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-bind --physical failed"
  CHECK_RESULT $? 0 0 "hwloc-bind ---force failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --no-hbm failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --verbose failed"
  CHECK_RESULT $? 0 0 "hwloc-bind -e failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --get-last-cpu-location failed"
  CHECK_RESULT $? 0 0 "hwloc-bind --quiet failed"
```

- 涉及命令：hwloc-bind×1

#### oe_test_hwloc_base_lstopo-no-graphics_01

- 描述：Test lstopo-no-graphics
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -l failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -l failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -p failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --of failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -f failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -only <type> failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -v failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -s failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -c failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -C failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --taskset failed"
```

- 涉及命令：lstopo-no-graphics×11

#### oe_test_hwloc_base_lstopo-no-graphics_02

- 描述：Test lstopo-no-graphics
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --ignore <type> failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --no-caches failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --no-useless-caches failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --no-icaches failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --merge failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --no-collapse failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --restrict <cpuset> failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --restrict binding failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --restrict-flags <n> failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --no-io failed"
```

- 涉及命令：lstopo-no-graphics×10

#### oe_test_hwloc_base_lstopo-no-graphics_03

- 描述：Test lstopo-no-graphics
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --input 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --no-bridges failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --whole-io failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -i <XML file> failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -i <directory> failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -i 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --if <format> failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --thissystem failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --pid <pid> failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --whole-system failed"
```

- 涉及命令：lstopo-no-graphics×11

#### oe_test_hwloc_base_lstopo-no-graphics_04

- 描述：Test lstopo-no-graphics
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --logical failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --logical failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --physical failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --output-format failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --force failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --verbose failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --silent failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --cpuset failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --cpuset-only failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --input <type> failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -l --input <directory> failed"
```

- 涉及命令：lstopo-no-graphics×8

#### oe_test_hwloc_base_lstopo-no-graphics_05

- 描述：Test lstopo-no-graphics
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --input-format <type> failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics --export-synthetic-flags failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -l --ps failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -l --top failed"
  CHECK_RESULT $? 0 0 "lstopo-no-graphics -l --version failed"
```

- 涉及命令：lstopo-no-graphics×6

#### oe_test_hwloc_base_lstopo_01

- 描述：Test lstopo
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "lstopo -l failed"
  CHECK_RESULT $? 0 0 "lstopo -l failed"
  CHECK_RESULT $? 0 0 "lstopo -p failed"
  CHECK_RESULT $? 0 0 "lstopo --of failed"
  CHECK_RESULT $? 0 0 "lstopo -f failed"
  CHECK_RESULT $? 0 0 "lstopo -only <type> failed"
  CHECK_RESULT $? 0 0 "lstopo -v failed"
  CHECK_RESULT $? 0 0 "lstopo -s failed"
  CHECK_RESULT $? 0 0 "lstopo -c failed"
  CHECK_RESULT $? 0 0 "lstopo -C failed"
  CHECK_RESULT $? 0 0 "lstopo --taskset failed"
```

- 涉及命令：lstopo×11

#### oe_test_hwloc_base_lstopo_02

- 描述：Test lstopo
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "lstopo --ignore <type> failed"
  CHECK_RESULT $? 0 0 "lstopo --no-caches failed"
  CHECK_RESULT $? 0 0 "lstopo --no-useless-caches failed"
  CHECK_RESULT $? 0 0 "lstopo --no-icaches failed"
  CHECK_RESULT $? 0 0 "lstopo --merge failed"
  CHECK_RESULT $? 0 0 "lstopo --no-collapse failed"
  CHECK_RESULT $? 0 0 "lstopo --restrict <cpuset> failed"
  CHECK_RESULT $? 0 0 "lstopo --restrict binding failed"
  CHECK_RESULT $? 0 0 "lstopo --restrict-flags <n> failed"
  CHECK_RESULT $? 0 0 "lstopo --no-io failed"
```

- 涉及命令：lstopo×10

#### oe_test_hwloc_base_lstopo_03

- 描述：Test lstopo
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "lstopo --input 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "lstopo --no-bridges failed"
  CHECK_RESULT $? 0 0 "lstopo --whole-io failed"
  CHECK_RESULT $? 0 0 "lstopo -i <XML file> failed"
  CHECK_RESULT $? 0 0 "lstopo -i <directory> failed"
  CHECK_RESULT $? 0 0 "lstopo -i 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "lstopo --if <format> failed"
  CHECK_RESULT $? 0 0 "lstopo --thissystem failed"
  CHECK_RESULT $? 0 0 "lstopo --pid <pid> failed"
  CHECK_RESULT $? 0 0 "lstopo --whole-system failed"
```

- 涉及命令：lstopo×11

#### oe_test_hwloc_base_lstopo_04

- 描述：Test lstopo
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "lstopo --logical failed"
  CHECK_RESULT $? 0 0 "lstopo --logical failed"
  CHECK_RESULT $? 0 0 "lstopo --physical failed"
  CHECK_RESULT $? 0 0 "lstopo --output-format failed"
  CHECK_RESULT $? 0 0 "lstopo --force failed"
  CHECK_RESULT $? 0 0 "lstopo --verbose failed"
  CHECK_RESULT $? 0 0 "lstopo --silent failed"
  CHECK_RESULT $? 0 0 "lstopo --cpuset failed"
  CHECK_RESULT $? 0 0 "lstopo --cpuset-only failed"
  CHECK_RESULT $? 0 0 "lstopo --input <type> failed"
  CHECK_RESULT $? 0 0 "lstopo -l --input <directory> failed"
```

- 涉及命令：lstopo×8

#### oe_test_hwloc_base_lstopo_05

- 描述：Test lstopo
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "lstopo --input-format <type> failed"
  CHECK_RESULT $? 0 0 "lstopo --export-synthetic-flags failed"
  CHECK_RESULT $? 0 0 "lstopo -l --ps failed"
  CHECK_RESULT $? 0 0 "lstopo -l --top failed"
  CHECK_RESULT $? 0 0 "lstopo -l --version failed"
```

- 涉及命令：lstopo×6

#### oe_test_hwloc_base_hwloc-calc_01

- 描述：Test hwloc-calc_1
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-calc [default] failed"
  CHECK_RESULT $? 0 0 "hwloc-calc -N failed"
  CHECK_RESULT $? 0 0 "hwloc-calc -I failed"
  CHECK_RESULT $? 0 0 "hwloc-calc -H failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --largest failed"
  CHECK_RESULT $? 0 0 "hwloc-calc -l failed"
  CHECK_RESULT $? 0 0 "hwloc-calc -p failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --li failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --lo failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --pi failed"
```

- 涉及命令：hwloc-calc×8

#### oe_test_hwloc_base_hwloc-calc_02

- 描述：Test hwloc-calc_2
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-calc --po failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --sep <sep> failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --taskset failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --single failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --restrict <cpuset> failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --whole-system failed"
  CHECK_RESULT $? 0 0 "hwloc-calc  -i <XML file> failed"
  CHECK_RESULT $? 0 0 "hwloc-calc -i <directory> failed"
  CHECK_RESULT $? 0 0 "hwloc-calc -i 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --if <format> failed"
```

- 涉及命令：hwloc-calc×5

#### oe_test_hwloc_base_hwloc-calc_03

- 描述：Test hwloc-calc_1
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-calc --physical-output failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --input <XML file> failed"
  CHECK_RESULT $? 0 0 "hwloc-calc--number-of failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --intersect failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --hierarchical failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --logical failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --physical failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --logical-input failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --logical-output failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --physical-input failed"
```

- 涉及命令：hwloc-calc×5

#### oe_test_hwloc_base_hwloc-calc_04

- 描述：Test hwloc-calc_03,hwloc-diff
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 1 0 "hwloc-calc -q failed"
  CHECK_RESULT $? 1 0 "hwloc-calc --quiet failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --verbose failed"
  CHECK_RESULT $? 0 0 "hwloc-calc -v failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --version failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --input <directory>  failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --input 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --input-format <format> failed"
```

- 涉及命令：hwloc-calc×2

#### oe_test_hwloc_base_hwloc-annotate

- 描述：Test hwloc-annotate
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1 0 "hwloc-annotate --ri failed"
  CHECK_RESULT $? 1 0 "hwloc-annotate --ci failed"
  CHECK_RESULT $? 1 0 "hwloc-annotate --cu failed"
```

- 涉及命令：test×1

#### oe_test_hwloc_base_hwloc-ls_01

- 描述：Test hwloc-ls
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-ls -f failed"
  CHECK_RESULT $? 0 0 "hwloc-ls -l failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --physical or -p failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --output-format or --of failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --only failed"
  CHECK_RESULT $? 0 0 "hwloc-ls -v or --verbose"
  CHECK_RESULT $? 0 0 "hwloc-ls -c or  --cpuset"
  CHECK_RESULT $? 0 0 "hwloc-ls -C failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --export-synthetic-flag  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls -s  or --silent  failed"
```

- 涉及命令：hwloc-ls×7

#### oe_test_hwloc_base_hwloc-ls_02

- 描述：Test hwloc-ls
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-ls --taskset failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --ignore   failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --no-caches  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --no-useless-caches  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --no-collapse  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --no-icaches  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --merge  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --restrict  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --restrict binding  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --restrict-flags  failed"
```

#### oe_test_hwloc_base_hwloc-ls_03

- 描述：Test hwloc-ls
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-ls --whole-io failed"
  CHECK_RESULT $? 0 0 "hwloc-ls -i failed"
  CHECK_RESULT $? 0 0 "hwloc-ls -i 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "hwloc-ls -i failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --no-io  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --no-bridges  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --if  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --thissystem  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --ps failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --version failed"
```

- 涉及命令：hwloc-ls×3

#### oe_test_hwloc_base_hwloc-ls_04

- 描述：Test hwloc-ls
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-ls -f failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --logical failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --physical failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --output-format failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --verbose failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --cpuset failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --silent failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --cpuset-only failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --input failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --input failed"
```

#### oe_test_hwloc_base_hwloc-ls_05

- 描述：Test hwloc-ps
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-ls --pid failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --whole-system  failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --input 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --input-format failed"
  CHECK_RESULT $? 0 0 "hwloc-ls --top failed"
```

#### oe_test_hwloc_base_others

- 描述：Test hwloc-gather-topology,hwloc-diff
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-diff failed"
  CHECK_RESULT $? 0 0 "hwloc-diff --refname failed"
  CHECK_RESULT $? 0 0 "hwloc-diff --version failed"
  CHECK_RESULT $? 0 0 "hwloc-gather-topology --io failed"
  CHECK_RESULT $? 0 0 "hwloc-gather-topology --dmi failed"
```

- 涉及命令：lstopo×2

#### oe_test_hwloc_base_hwloc-patch

- 描述：Test hwloc-patch
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-patch --reverse failed"
  CHECK_RESULT $? 0 0 "hwloc-patch -R failed"
  CHECK_RESULT $? 0 0 "hwloc-calc --version failed"
```

- 涉及命令：hwloc-patch×1

#### oe_test_hwloc_1.11.9_hwloc-assembler

- 描述：Test hwloc-assembler
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-assembler --name  failed"
  CHECK_RESULT $? 0 0 "hwloc-assembler -n failed"
  CHECK_RESULT $? 0 0 "hwloc-assembler --force  failed"
  CHECK_RESULT $? 0 0 "hwloc-assembler -f failed"
  CHECK_RESULT $? 0 0 "hwloc-assembler --verbose  failed"
  CHECK_RESULT $? 0 0 "hwloc-assembler -v failed"
```

- 涉及命令：hwloc-assembler×2, test×1

#### oe_test_hwloc_1.11.9_hwloc-distances_01

- 描述：Test hwloc-distances
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-distances -l  failed"
  CHECK_RESULT $? 0 0 "hwloc-distances -p  failed"
  CHECK_RESULT $? 0 0 "hwloc-distances --restrict failed"
  CHECK_RESULT $? 0 0 "hwloc-distances --whole-system failed"
  CHECK_RESULT $? 0 0 "hwloc-distances -i <XML file> failed"
  CHECK_RESULT $? 0 0 "hwloc-distances -i <directory> failed"
  CHECK_RESULT $? 0 0 "hwloc-distances --input 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "hwloc-distances  --if <format> failed"
  CHECK_RESULT $? 0 0 "hwloc-distances -v failed"
  CHECK_RESULT $? 0 0 "hwloc-distances --version failed"
```

- 涉及命令：hwloc-distances×7

#### oe_test_hwloc_1.11.9_hwloc-distances_02

- 描述：Test hwloc-distances
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "hwloc-distances --logical failed"
  CHECK_RESULT $? 0 0 "hwloc-distances --physical failed"
  CHECK_RESULT $? 0 0 "hwloc-distances --input  <XML file> failed"
  CHECK_RESULT $? 0 0 "hwloc-distances --input  <directory> failed"
  CHECK_RESULT $? 0 0 "hwloc-distances --input 'node:2 2' failed"
  CHECK_RESULT $? 0 0 "hwloc-distances --input-format <format> failed"
  CHECK_RESULT $? 0 0 "hwloc-distances --verbose failed"
```

- 涉及命令：hwloc-distances×1
