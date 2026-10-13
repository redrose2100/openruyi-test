# gperf

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gperf` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gperf_base_01 | verify the uasge of mpich command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_gperf_base_02 | verify the uasge of mpich command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_gperf_base_03 | verify the uasge of mpich command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_gperf_base_04 | verify the uasge of mpich command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_gperf_base_05 | verify the uasge of mpich command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_gperf_base_06 | verify the uasge of mpich command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_gperf_base_07 | verify the uasge of mpich command | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gperf_base_01

- 描述：verify the uasge of mpich command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check '--help  failed"
  CHECK_RESULT $? 0 0 "Check gperf -h failed."
  CHECK_RESULT $? 0 0 "Check gperf --version failed."
  CHECK_RESULT $? 0 0 "Check gperf -v failed."
  CHECK_RESULT $? 0 0 "Check gperf -d failed."
  CHECK_RESULT $? 0 0 "Check gperf -d -e failed."
  CHECK_RESULT $? 0 0 "Check gperf --delimiters failed."
  CHECK_RESULT $? 0 0 "Check gperf -t failed."
  CHECK_RESULT $? 0 0 "Check gperf --struct-type failed."
```

- 涉及命令：gperf×4

#### oe_test_gperf_base_02

- 描述：verify the uasge of mpich command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check gperf --ignore-case failed."
  CHECK_RESULT $? 0 0 "Check gperf -L failed."
  CHECK_RESULT $? 0 0 "Check gperf --language failed."
  CHECK_RESULT $? 0 0 "Check gperf -t -K  failed."
  CHECK_RESULT $? 0 0 "Check gperf -t --initializer-suffix failed."
  CHECK_RESULT $? 0 0 "Check gperf -F failed."
  CHECK_RESULT $? 0 0 "Check gperf -H failed."
  CHECK_RESULT $? 0 0 "Check gperf --hash-function-name failed."
  CHECK_RESULT $? 0 0 "Check gperf -N failed."
  CHECK_RESULT $? 0 0 "Check gperf -Z failed."
  CHECK_RESULT $? 0 0 "Check gperf --class-name failed."
```

- 涉及命令：gperf×7

#### oe_test_gperf_base_03

- 描述：verify the uasge of mpich command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check gperf -7 failed."
  CHECK_RESULT $? 0 0 "Check gperf --seven-bit failed."
  CHECK_RESULT $? 0 0 "Check gperf -l failed."
  CHECK_RESULT $? 0 0 "Check gperf --compare-lengths failed."
  CHECK_RESULT $? 0 0 "Check gperf -c failed."
  CHECK_RESULT $? 0 0 "Check gperf --compare-strncmp failed."
  CHECK_RESULT $? 0 0 "Check gperf -C failed."
  CHECK_RESULT $? 0 0 "Check gperf --readonly-tables failed."
  CHECK_RESULT $? 0 0 "Check gperf -E failed."
  CHECK_RESULT $? 0 0 "Check gperf --enum failed."
```

- 涉及命令：gperf×5

#### oe_test_gperf_base_04

- 描述：verify the uasge of mpich command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check gperf -I failed."
  CHECK_RESULT $? 0 0 "Check gperf --includes failed."
  CHECK_RESULT $? 0 0 "Check gperf -G failed."
  CHECK_RESULT $? 0 0 "Check gperf --global-table failed."
  CHECK_RESULT $? 0 0 "Check gperf -P failed."
  CHECK_RESULT $? 0 0 "Check gperf --pic failed."
  CHECK_RESULT $? 0 0 "Check gperf -Q failed."
  CHECK_RESULT $? 0 0 "Check gperf --string-pool-name failed."
  CHECK_RESULT $? 0 0 "Check gperf --constants-prefix failed."
```

- 涉及命令：gperf×4

#### oe_test_gperf_base_05

- 描述：verify the uasge of mpich command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check gperf --null-strings failed."
  CHECK_RESULT $? 0 0 "Check gperf -W failed."
  CHECK_RESULT $? 0 0 "Check gperf --word-array-name failed."
  CHECK_RESULT $? 0 0 "Check gperf --length-table-name failed."
  CHECK_RESULT $? 0 0 "Check gperf -S failed."
  CHECK_RESULT $? 0 0 "Check gperf --switch failed."
  CHECK_RESULT $? 0 0 "Check gperf -T failed."
  CHECK_RESULT $? 0 0 "Check gperf --omit-struct-type failed."
  CHECK_RESULT $? 0 0 "Check gperf -k failed."
  CHECK_RESULT $? 0 0 "Check gperf --key-positions failed."
```

- 涉及命令：gperf×4

#### oe_test_gperf_base_06

- 描述：verify the uasge of mpich command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check gperf -D failed."
  CHECK_RESULT $? 0 0 "Check gperf --duplicates failed."
  CHECK_RESULT $? 0 0 "Check gperf -m failed."
  CHECK_RESULT $? 0 0 "Check gperf --multiple-iterations failed."
  CHECK_RESULT $? 0 0 "Check gperf -i failed."
  CHECK_RESULT $? 0 0 "Check gperf --initial-asso failed."
  CHECK_RESULT $? 0 0 "Check gperf -j failed."
  CHECK_RESULT $? 0 0 "Check gperf --jump failed."
  CHECK_RESULT $? 0 0 "Check gperf -n failed."
  CHECK_RESULT $? 0 0 "Check gperf --no-strlen failed."
```

- 涉及命令：gperf×5

#### oe_test_gperf_base_07

- 描述：verify the uasge of mpich command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check gperf -r failed."
  CHECK_RESULT $? 0 0 "Check gperf --random failed."
  CHECK_RESULT $? 0 0 "Check gperf -s failed."
  CHECK_RESULT $? 0 0 "Check gperf --size-multiple failed."
```

- 涉及命令：gperf×2
