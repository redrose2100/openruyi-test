# efivar

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `$OET_PATH/testcases/system-test/system-integration/os-basic/oe_test_efivar` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_efivar | Basic functional verification of efivar | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_efivar

- 描述：Basic functional verification of efivar
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to read UEFI variable list"
  CHECK_RESULT $? 0 0 "Failed to read UEFI variable"
  CHECK_RESULT $? 0 0 "UEFI variable content is empty"
  CHECK_RESULT $? 0 0 "UEFI variable -d failed"
  CHECK_RESULT $? 0 0 "efivar -d output is empty"
  CHECK_RESULT $? 1 0 "efivar -d output is NOT valid decimal format"
  CHECK_RESULT $? 0 0 "File generation failed"
  CHECK_RESULT $? 0 0 "Exported file is empty"
  CHECK_RESULT $? 0 1 "Reading invalid variable should fail"
```

- 涉及命令：efivar×3, test×1
