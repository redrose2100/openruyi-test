# open-iscsi

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/open-iscsi` |
| 注册用例数 | 5 |
| 环境约束 | machine num = 2；add disk = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_open-iscsi_iscsiadm | command test-iscsiadm | pre_test/run_test/post_test | 26 | ✔ | ✔ |  |
| oe_test_open-iscsi_iscsistart_iscsiuio | command test-iscsid | pre_test/run_test/post_test | 9 | ✔ | ✔ |  |
| oe_test_service_iscsid | Test iscsid.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_iscsi | Test iscsi.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_iscsid | Test iscsid.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_open-iscsi_iscsiadm

- 描述：command test-iscsiadm
- 函数：`pre_test, run_test, post_test`
- 断言（26 条）：

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
  ... 共 26 条（其余见源脚本）
```

- 涉及命令：iscsiadm×22

#### oe_test_open-iscsi_iscsistart_iscsiuio

- 描述：command test-iscsid
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

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
```

- 涉及命令：iscsiadm×7, iscsistart×7, pkill×1

#### oe_test_service_iscsid

- 描述：Test iscsid.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_iscsi

- 描述：Test iscsi.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_iscsid

- 描述：Test iscsid.socket restart
- 函数：`pre_test, run_test, post_test`