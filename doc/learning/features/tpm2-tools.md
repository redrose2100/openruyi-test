# tpm2-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/tpm2-tools` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_tpm2_tools_save_data_01 | verify tpm2_clear,tpm2_nvreadpublic,tpm2_changeauth,tpm2_nvdefine,tpm2_nvwrite command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_tpm2_tools_save_data_01

- 描述：verify tpm2_clear,tpm2_nvreadpublic,tpm2_changeauth,tpm2_nvdefine,tpm2_nvwrite command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Clean tpm's all data failed"
  CHECK_RESULT $? 0 0 "Set password failed"
  CHECK_RESULT $? 0 0 "Define nvram failed"
  CHECK_RESULT $? 0 0 "Write data failed"
  CHECK_RESULT $? 0 0 "Read data failed"
```

- 涉及命令：tpm2_changeauth×1, tpm2_nvdefine×1, tpm2_nvwrite×1, tpm2_nvread×1
