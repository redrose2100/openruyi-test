# adcli

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/adcli` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_adcli | Test adcli package installation and command functionality | pre_test/run_test/post_test | 25 | ✔ |  |  |

### 断言与命令明细

#### oe_test_adcli

- 描述：Test adcli package installation and command functionality
- 函数：`pre_test, run_test, post_test`
- 断言（25 条）：

```
  CHECK_RESULT $? 0 0 "adcli package not installed"
  CHECK_RESULT $? 0 0 "adcli version invalid"
  CHECK_RESULT $? 0 0 "adcli release invalid"
  CHECK_RESULT $? 0 0 "adcli architecture invalid"
  CHECK_RESULT $? 0 0 "adcli license should contain LGPL"
  CHECK_RESULT $? 0 0 "adcli summary should contain Active Directory"
  CHECK_RESULT $? 0 0 "adcli URL should contain realmd or adcli"
  CHECK_RESULT $? 0 0 "adcli package files missing"
  CHECK_RESULT $? 0 0 "adcli binary not found or not executable"
  CHECK_RESULT $? 0 0 "adcli ChangeLog not found"
  CHECK_RESULT $? 0 0 "adcli COPYING file not found"
  CHECK_RESULT $? 0 0 "adcli AUTHORS file not found"
  ... 共 25 条（其余见源脚本）
```

- 涉及命令：rpm×1
