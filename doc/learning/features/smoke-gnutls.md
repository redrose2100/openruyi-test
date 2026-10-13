# smoke-gnutls

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-gnutls` |
| 注册用例数 | 1 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gnutls_basic_test | gnutls tls connect test | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_gnutls_basic_test

- 描述：gnutls tls connect test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "connect failed first."
  CHECK_RESULT $? 0 0 "connect failed second."
  CHECK_RESULT $? 0 0 "connect failed third."
  CHECK_RESULT $? 0 0 "connect failed fourth."
```
