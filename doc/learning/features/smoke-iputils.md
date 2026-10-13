# smoke-iputils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-iputils` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_iputils_FUN.003 | iputils从R11升级到R12后差异点检查： | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_ping6_SCEN.005 | 指定ping退出之前的超时（以秒为单位），无论已发送或接收了多少数据包 -w参数 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_ping_SCEN.005 | 指定ping退出之前的超时（以秒为单位），无论已发送或接收了多少数据包 -w参数 | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_iputils_FUN.003

- 描述：iputils从R11升级到R12后差异点检查：
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Error: $cmd still exists in system."
  CHECK_RESULT $? 0 0 "Error: $cmd still exists in system."
```

#### oe_test_ping6_SCEN.005

- 描述：指定ping退出之前的超时（以秒为单位），无论已发送或接收了多少数据包 -w参数
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0
```

#### oe_test_ping_SCEN.005

- 描述：指定ping退出之前的超时（以秒为单位），无论已发送或接收了多少数据包 -w参数
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0
```
