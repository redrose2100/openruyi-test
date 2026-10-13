# gpm

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gpm` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_gpm | Test gpm.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_gpm_01 | Test gpm | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_gpm

- 描述：Test gpm.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_gpm_01

- 描述：Test gpm
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check gpm.service basic status"
  CHECK_RESULT $? 0 0 "Check gpm.service dependencies"
  CHECK_RESULT $? 0 0 "Enable gpm.service auto-start"
  CHECK_RESULT $? 0 0 "Verify gpm.service auto-start enabled"
  CHECK_RESULT $? 0 0 "Check gpm.service journal output"
  CHECK_RESULT $? 0 0 "Check if gpm process is running"
  CHECK_RESULT $? 0 0 "Check gpm package configuration files"
  CHECK_RESULT $? 0 0 "Check gpm.service unit file existence"
```

- 涉及命令：journalctl×1, pgrep×1, rpm×1, test×1
