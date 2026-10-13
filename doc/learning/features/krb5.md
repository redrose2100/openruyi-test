# krb5

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/krb5` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_kadmin | Test kadmin.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_kprop | Test kprop.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_krb5kdc | Test krb5kdc.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_kadmin

- 描述：Test kadmin.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "kadmin.service reload failed"
  CHECK_RESULT $? 0 0 "kadmin.service reload causes the service status to change"
```

- 涉及命令：sed×6

#### oe_test_service_kprop

- 描述：Test kprop.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×4

#### oe_test_service_krb5kdc

- 描述：Test krb5kdc.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "krb5kdc.service reload failed"
  CHECK_RESULT $? 0 0 "krb5kdc.service reload causes the service status to change"
```

- 涉及命令：sed×6
