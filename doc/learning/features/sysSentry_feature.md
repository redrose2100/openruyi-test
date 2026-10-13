# sysSentry_feature

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/sysSentry` |
| 注册用例数 | 12 |
| 环境约束 | machine type = physical；add disk = 8 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sysSentry_001 | numafast test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sysSentry_002 | numafast test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sysSentry_003 | numafast test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sysSentry_004 | numafast test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sysSentry_005 | numafast test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sysSentry_006 | numafast test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sysSentry_007 | numafast test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sysSentry_009 | numafast test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_sysSentry_010 | numafast test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sysSentry_011 | numafast test | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_sysSentry_012 | numafast test | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_sysSentry_013 | numafast test | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_sysSentry_001

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check iops failed"
```

- 涉及命令：sed×2, mkfs.ext4×1

#### oe_test_sysSentry_002

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check iops failed"
```

- 涉及命令：sed×2, mkfs.ext4×1

#### oe_test_sysSentry_003

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check latency failed"
```

- 涉及命令：sed×2, mkfs.ext4×1, grep×1

#### oe_test_sysSentry_004

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check latency failed"
```

- 涉及命令：sed×2, mkfs.ext4×1, grep×1

#### oe_test_sysSentry_005

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check iodump failed"
```

- 涉及命令：sed×2, mkfs.ext4×1, grep×1

#### oe_test_sysSentry_006

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check iodump failed"
```

- 涉及命令：sed×2, mkfs.ext4×1, grep×1

#### oe_test_sysSentry_007

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check iops failed"
```

- 涉及命令：sed×2, mkfs.ext4×1

#### oe_test_sysSentry_009

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check exception value failed"
  CHECK_RESULT $? 0 0 "Error: Check exception value failed"
  CHECK_RESULT $? 0 0 "Error: Check exception value failed"
  CHECK_RESULT $? 0 0 "Error: Check exception value failed"
  CHECK_RESULT $? 0 0 "Error: Check exception value failed"
```

- 涉及命令：sed×5

#### oe_test_sysSentry_010

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check config failed"
```

- 涉及命令：sed×2

#### oe_test_sysSentry_011

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check config win_threshold_latency exception value failed"
  CHECK_RESULT $? 0 0 "Error: Check config win_threshold_latency exception value failed"
  CHECK_RESULT $? 0 0 "Error: Check config win_threshold_iodump exception value failed"
  CHECK_RESULT $? 0 0 "Error: Check config win_threshold_iodump exception value failed"
```

- 涉及命令：sed×4

#### oe_test_sysSentry_012

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check config failed"
```

- 涉及命令：sed×2

#### oe_test_sysSentry_013

- 描述：numafast test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Error: Check sentryCollector restart avg_block_io.log failed"
  CHECK_RESULT $? 0 0 "Error: Check xalarmd restart avg_block_io.log failed"
```
