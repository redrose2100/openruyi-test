# efibootmgr

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/efibootmgr/` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_efibootmgr_01 | Verify efibootmgr package integrity and basic queries | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_efibootmgr_02 | Verify efibootmgr boot entry management | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_efibootmgr_03 | Verify efibootmgr advanced operations | pre_test/run_test/post_test | 14 | ✔ |  |  |

### 断言与命令明细

#### oe_test_efibootmgr_01

- 描述：Verify efibootmgr package integrity and basic queries
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to get efibootmgr version (-V)"
  CHECK_RESULT $? 0 0 "Failed to run efibootmgr --help (-h)"
  CHECK_RESULT $? 0 0 "Failed to get verbose boot information (-v)"
  CHECK_RESULT $? 0 0 "Failed to set boot timeout (-t)"
  CHECK_RESULT $? 0 0 "Failed to clear boot timeout (-T)"
  CHECK_RESULT $? 0 1 "Failed to verify timeout cleared (-T)"
  CHECK_RESULT $? 0 0 "Failed to operate on SysPrep variables (-y)"
  CHECK_RESULT $? 0 0 "Failed to use full device path (--full-dev-path)"
  CHECK_RESULT $? 0 0 "Failed to create boot entry (-c)"
  CHECK_RESULT $? 0 0 "Failed to set boot order (-o)"
  CHECK_RESULT $? 0 0 "Failed to delete boot order (-O)"
  CHECK_RESULT $? 0 0 "Failed to verify boot order deleted (-O)"
```

- 涉及命令：efibootmgr×7, mkdir×1

#### oe_test_efibootmgr_02

- 描述：Verify efibootmgr boot entry management
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create boot entry (-c)"
  CHECK_RESULT $? 0 0 "Failed to activate boot entry (-a, -b)"
  CHECK_RESULT $? 0 0 "Failed to deactivate boot entry (-A, -b)"
  CHECK_RESULT $? 0 0 "Failed to delete boot entry (-B, -b)"
  CHECK_RESULT $? 0 1 "Failed to verify boot entry deleted (-B)"
  CHECK_RESULT $? 0 0 "Failed to create-only boot entry (-C)"
  CHECK_RESULT $? 0 0 "Failed to verify create-only entry not in bootorder (-C)"
  CHECK_RESULT $? 0 0 "Failed to delete create-only boot entry"
  CHECK_RESULT $? 0 0 "Failed to remove duplicate boot entries (-D)"
  CHECK_RESULT $? 0 0 "Failed to use file device path (--file-dev-path)"
```

- 涉及命令：efibootmgr×7, mkdir×1

#### oe_test_efibootmgr_03

- 描述：Verify efibootmgr advanced operations
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create boot entry (-c)"
  CHECK_RESULT $? 0 0 "Failed to set bootnext (-n)"
  CHECK_RESULT $? 0 0 "Failed to clear bootnext (-N)"
  CHECK_RESULT $? 0 1 "Failed to verify bootnext cleared (-N)"
  CHECK_RESULT $? 0 0 "Failed to create driver entry (-r, -c)"
  CHECK_RESULT $? 0 0 "Failed to query UEFI driver variables (-r)"
  CHECK_RESULT $? 0 0 "Failed to create entry at index (-I)"
  CHECK_RESULT $? 0 0 "Failed to force GPT mode (-g)"
  CHECK_RESULT $? 0 0 "Failed to read arguments from file (-@)"
  CHECK_RESULT $? 0 1 "Failed to create netboot entry (-i)"
  CHECK_RESULT $? 0 0 "Failed to create entry with EDD 1.0 (-e)"
  CHECK_RESULT $? 0 0 "Failed to create entry with EDD 3.0 (-e, -E)"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：efibootmgr×15, mkdir×1
