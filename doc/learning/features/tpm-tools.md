# tpm-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/tpm-tools` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_tpm-tools_01 | verify the uasge of tpm_version,tpm_takeownership,tpm_getpubek,tpm_sealdata and tpm_unsealdata command | pre_test/run_test/post_test | 20 |  |  |  |
| oe_test_tpm-tools_02 | verify the uasge of tpm_changeownerauth,tpm_clear,tpm_nvinfo,tpm_resetdalock and tpm_restrictpubek command | pre_test/run_test/post_test | 21 |  |  |  |
| oe_test_tpm-tools_03 | verify the uasge of tpm_restrictsrk,tpm_revokeek,tpm_selftest,tpm_setpresence and tpm_setoperatorauth command | pre_test/run_test/post_test | 24 |  |  |  |
| oe_test_tpm-tools_04 | verify the uasge of tpm_setownable,tpm_setenable,tpm_setactive and tpm_setclearable command | pre_test/run_test/post_test | 31 |  |  |  |

### 断言与命令明细

#### oe_test_tpm-tools_01

- 描述：verify the uasge of tpm_version,tpm_takeownership,tpm_getpubek,tpm_sealdata and tpm_unsealdata command
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：grep×8, tpm_version×2

#### oe_test_tpm-tools_02

- 描述：verify the uasge of tpm_changeownerauth,tpm_clear,tpm_nvinfo,tpm_resetdalock and tpm_restrictpubek command
- 函数：`pre_test, run_test, post_test`
- 断言（21 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：grep×5, tpm_nvinfo×1

#### oe_test_tpm-tools_03

- 描述：verify the uasge of tpm_restrictsrk,tpm_revokeek,tpm_selftest,tpm_setpresence and tpm_setoperatorauth command
- 函数：`pre_test, run_test, post_test`
- 断言（24 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 24 条（其余见源脚本）
```

- 涉及命令：grep×8, tpm_selftest×2, tpm_setoperatorauth×2

#### oe_test_tpm-tools_04

- 描述：verify the uasge of tpm_setownable,tpm_setenable,tpm_setactive and tpm_setclearable command
- 函数：`pre_test, run_test, post_test`
- 断言（31 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 31 条（其余见源脚本）
```

- 涉及命令：grep×9, tpm_setactive×3, tpm_setownable×2, tpm_setclearable×1
