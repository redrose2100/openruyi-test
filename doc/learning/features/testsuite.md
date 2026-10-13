# testsuite

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 模板域（testsuite） |
| 套件路径 | `$OET_PATH/testcases/testsuite` |
| 注册用例数 | 2 |
| 环境约束 | machine num = 2；machine type = kvm；add network interface = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_casename_01 | Take the test ls command as an example | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_casename_02 | Take the test ls command as an example | — | 0 |  | ✔ |  |

### 断言与命令明细

#### oe_test_casename_01

- 描述：Take the test ls command as an example
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT 0
  CHECK_RESULT "$(ls / | grep -cE 'proc|usr|roor|var|sys|etc|boot|dev')" 7 0 "The system is missing a base directory."
```

#### oe_test_casename_02

- 描述：Take the test ls command as an example