# vdo

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/vdo` |
| 注册用例数 | 22 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_vdo | Test vdo.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_vdo_01 | Test vdo | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_vdo_02 | Test vdo | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_vdo_03 | Test vdo | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_vdo_04 | Test vdo | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_vdo_05 | Test vdo | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_vdo_06 | Test vdo | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_vdo_07 | Test vdo | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_vdo_08 | Test vdo | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_vdo_09 | Test vdo | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_vdo_10 | Test vdo | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_vdo_11 | Test vdo | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_vdo_12 | Test vdo | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_vdo_13 | Test vdo | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_vdo_14 | Test vdo | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_vdo_15 | Test vdo | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_vdo_16 | Test vdo | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_vdo_create_01 | Test vdo | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_vdo_create_02 | Test vdo | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_vdo_create_03 | Test vdo | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_vdo_modify_01 | Test vdo | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_vdo_modify_02 | Test vdo | pre_test/run_test/post_test | 6 |  |  |  |

### 断言与命令明细

#### oe_test_service_vdo

- 描述：Test vdo.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_vdo_01

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo -h failed"
  CHECK_RESULT $? 0 0 "Check vdo activate -h failed"
  CHECK_RESULT $? 0 0 "Check vdo activate -a failed"
  CHECK_RESULT $? 0 0 "Check vdo activate -n failed"
  CHECK_RESULT $? 0 0 "Check vdo activate --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo activate -f failed"
  CHECK_RESULT $? 0 0 "Check vdo activate --logfile failed"
```

- 涉及命令：vdo×1

#### oe_test_vdo_02

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy -h failed"
  CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy -a failed"
  CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy -n failed"
  CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy -f failed"
  CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy --logfile failed"
  CHECK_RESULT $? 0 0 "Check vdo changeWritePolicy --writePolicy failed"
```

#### oe_test_vdo_03

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo deactivate --help failed"
  CHECK_RESULT $? 0 0 "Check vdo deactivate -a failed"
  CHECK_RESULT $? 0 0 "Check vdo deactivate -n failed"
  CHECK_RESULT $? 0 0 "Check vdo deactivate -f failed"
  CHECK_RESULT $? 0 0 "Check vdo deactivate --logfile failed"
  CHECK_RESULT $? 0 0 "Check vdo deactivate --verbose failed"
```

#### oe_test_vdo_04

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo disableCompression --help failed"
  CHECK_RESULT $? 0 0 "Check vdo disableCompression -a failed"
  CHECK_RESULT $? 0 0 "Check vdo disableCompression -n failed"
  CHECK_RESULT $? 0 0 "Check vdo disableCompression --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo disableCompression -f failed"
  CHECK_RESULT $? 0 0 "Check vdo disableCompression --logfile failed"
```

#### oe_test_vdo_05

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo disableDeduplication --help failed"
  CHECK_RESULT $? 0 0 "Check vdo disableDeduplication -a failed"
  CHECK_RESULT $? 0 0 "Check vdo disableDeduplication -n failed"
  CHECK_RESULT $? 0 0 "Check vdo disableDeduplication --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo disableDeduplication -f failed"
  CHECK_RESULT $? 0 0 "Check vdo disableDeduplication --logfile failed"
```

#### oe_test_vdo_06

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo enableCompression --help failed"
  CHECK_RESULT $? 0 0 "Check vdo enableCompression -a failed"
  CHECK_RESULT $? 0 0 "Check vdo enableCompression -n failed"
  CHECK_RESULT $? 0 0 "Check vdo enableCompression --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo enableCompression -f failed"
  CHECK_RESULT $? 0 0 "Check vdo enableCompression --logfile failed"
```

#### oe_test_vdo_07

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo enableDeduplication --help failed"
  CHECK_RESULT $? 0 0 "Check vdo enableDeduplication -a failed"
  CHECK_RESULT $? 0 0 "Check vdo enableDeduplication -n failed"
  CHECK_RESULT $? 0 0 "Check vdo enableDeduplication --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo enableDeduplication -f failed"
  CHECK_RESULT $? 0 0 "Check vdo enableDeduplication --logfile failed"
```

#### oe_test_vdo_08

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo growLogical --help failed"
  CHECK_RESULT $? 0 0 "Check vdo growLogical -n failed"
  CHECK_RESULT $? 0 0 "Check vdo growLogical --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo growLogical -f failed"
  CHECK_RESULT $? 0 0 "Check vdo growLogical --logfile failed"
```

#### oe_test_vdo_09

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo list --help failed"
  CHECK_RESULT $? 0 0 "Check vdo list -a failed"
  CHECK_RESULT $? 0 0 "Check vdo list --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo list -f failed"
  CHECK_RESULT $? 0 0 "Check vdo list --logfile failed"
  CHECK_RESULT $? 0 0 "Check vdo printConfigFile --help failed"
  CHECK_RESULT $? 0 0 "Check vdo printConfigFile --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo printConfigFile -f failed"
  CHECK_RESULT $? 0 0 "Check vdo printConfigFile --logfile failed"
```

#### oe_test_vdo_10

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo status --help failed"
  CHECK_RESULT $? 0 0 "Check vdo status -a failed"
  CHECK_RESULT $? 0 0 "Check vdo status -n failed"
  CHECK_RESULT $? 0 0 "Check vdo status --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo status -f failed"
  CHECK_RESULT $? 0 0 "Check vdo status --logfile failed"
```

#### oe_test_vdo_11

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo start --help failed"
  CHECK_RESULT $? 0 0 "Check vdo start -a failed"
  CHECK_RESULT $? 0 0 "Check vdo start -n failed"
  CHECK_RESULT $? 0 0 "Check vdo start --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo start -f failed"
  CHECK_RESULT $? 0 0 "Check vdo start --logfile failed"
```

#### oe_test_vdo_12

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo stop --help failed"
  CHECK_RESULT $? 0 0 "Check vdo stop -a failed"
  CHECK_RESULT $? 0 0 "Check vdo stop -n failed"
  CHECK_RESULT $? 0 0 "Check vdo stop --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo stop -f failed"
  CHECK_RESULT $? 0 0 "Check vdo stop --logfile failed"
```

#### oe_test_vdo_13

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo remove --help failed"
  CHECK_RESULT $? 0 0 "Check vdo remove -a failed"
  CHECK_RESULT $? 0 0 "Check vdo remove -n failed"
  CHECK_RESULT $? 0 0 "Check vdo remove --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo remove -f failed"
  CHECK_RESULT $? 0 0 "Check vdo remove --logfile failed"
  CHECK_RESULT $? 0 0 "Check vdo remove --force failed"
```

#### oe_test_vdo_14

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check vdodmeventd --help failed"
  CHECK_RESULT $? 0 0 "Check vdodmeventd --unregister failed"
  CHECK_RESULT $? 0 0 "Check vdodmeventd --register failed"
  CHECK_RESULT $? 0 0 "Check vdodmeventd --version failed"
  CHECK_RESULT $? 0 0 "Check vdodumpconfig failed"
  CHECK_RESULT $? 0 0 "Check vdoreadonly failed"
  CHECK_RESULT $? 0 0 "Check vdodumpconfig failed"
  CHECK_RESULT $? 0 0 "Check vdoprepareupgrade failed"
```

#### oe_test_vdo_15

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check vdoformat --help failed"
  CHECK_RESULT $? 0 0 "Check vdoformat --force failed"
  CHECK_RESULT $? 0 0 "Check vdoformat --logical-size failed"
  CHECK_RESULT $? 0 0 "Check vdoformat --slab-bits failed"
  CHECK_RESULT $? 0 0 "Check vdoformat --uds-checkpoint-frequency failed"
  CHECK_RESULT $? 0 0 "Check vdoformat --uds-memory-size failed"
  CHECK_RESULT $? 0 0 "Check vdoformat --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdoformat --version -a failed"
```

- 涉及命令：losetup×1

#### oe_test_vdo_16

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check vdostats --help failed"
  CHECK_RESULT $? 0 0 "Check vdostats --all failed"
  CHECK_RESULT $? 0 0 "Check vdostats --human-readable failed"
  CHECK_RESULT $? 0 0 "Check vdostats --si failed"
  CHECK_RESULT $? 0 0 "Check vdostats --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdostats --version failed"
```

#### oe_test_vdo_create_01

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo create --help failed"
  CHECK_RESULT $? 0 0 "Check vdo create -n failed"
  CHECK_RESULT $? 0 0 "Check vdo create --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo create -f failed"
  CHECK_RESULT $? 0 0 "Check vdo create --logfile failed"
  CHECK_RESULT $? 0 0 "Check vdo create --writePolicy failed"
  CHECK_RESULT $? 0 0 "Check vdo create --device failed"
  CHECK_RESULT $? 0 0 "Check vdo create --activate failed"
  CHECK_RESULT $? 0 0 "Check vdo create --blockMapCacheSize failed"
  CHECK_RESULT $? 0 0 "Check vdo create --compression failed"
```

#### oe_test_vdo_create_02

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo create --deduplication failed"
  CHECK_RESULT $? 0 0 "Check vdo create --emulate512 failed"
  CHECK_RESULT $? 0 0 "Check vdo create --force failed"
  CHECK_RESULT $? 0 0 "Check vdo create --indexMem failed"
  CHECK_RESULT $? 0 0 "Check vdo create --maxDiscardSize failed"
  CHECK_RESULT $? 0 0 "Check vdo create --sparseIndex failed"
  CHECK_RESULT $? 0 0 "Check vdo create --vdoAckThreads failed"
  CHECK_RESULT $? 0 0 "Check vdo create --vdoBioRotationInterval failed"
  CHECK_RESULT $? 0 0 "Check vdo create --vdoBioThreads failed"
  CHECK_RESULT $? 0 0 "Check vdo create --vdoCpuThreads failed"
```

#### oe_test_vdo_create_03

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo create --vdoHashZoneThreads failed"
  CHECK_RESULT $? 0 0 "Check vdo create --vdoLogicalSize failed"
  CHECK_RESULT $? 0 0 "Check vdo create --vdoLogicalThreads failed"
  CHECK_RESULT $? 0 0 "Check vdo create --vdoLogLevel failed"
  CHECK_RESULT $? 0 0 "Check vdo create --vdoPhysicalThreads failed"
  CHECK_RESULT $? 0 0 "Check vdo create --vdoSlabSize failed"
```

#### oe_test_vdo_modify_01

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo modify --help failed"
  CHECK_RESULT $? 0 0 "Check vdo modify -a failed"
  CHECK_RESULT $? 0 0 "Check vdo modify -n failed"
  CHECK_RESULT $? 0 0 "Check vdo modify -f failed"
  CHECK_RESULT $? 0 0 "Check vdo modify --logfile <pathname> failed"
  CHECK_RESULT $? 0 0 "Check vdo modify --verbose failed"
  CHECK_RESULT $? 0 0 "Check vdo modify --blockMapCacheSize failed"
  CHECK_RESULT $? 0 0 "Check vdo modify --blockMapPeriod failed"
  CHECK_RESULT $? 0 0 "Check vdo modify --maxDiscardSize failed"
  CHECK_RESULT $? 0 0 "Check vdo modify --vdoAckThreads failed"
```

#### oe_test_vdo_modify_02

- 描述：Test vdo
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check vdo modify --vdoBioRotationInterval failed"
  CHECK_RESULT $? 0 0 "Check vdo modify --vdoBioThreads failed"
  CHECK_RESULT $? 0 0 "Check vdo modify --vdoCpuThreads failed"
  CHECK_RESULT $? 0 0 "Check vdo modify --vdoHashZoneThreads failed"
  CHECK_RESULT $? 0 0 "Check vdo modify --vdoLogicalThreads failed"
  CHECK_RESULT $? 0 0 "Check vdo modify --vdoPhysicalThreads failed"
```
