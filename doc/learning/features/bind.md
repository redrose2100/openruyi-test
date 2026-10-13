# bind

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/bind` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_named-chroot-setup | Test named-chroot-setup.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_named-chroot | Test named-chroot.service restart | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_service_named-setup-rndc | Test named-setup-rndc.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_named | Test named.service restart | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_named-chroot-setup

- 描述：Test named-chroot-setup.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_named-chroot

- 描述：Test named-chroot.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
  CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_named-setup-rndc

- 描述：Test named-setup-rndc.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_named

- 描述：Test named.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
  CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
```

- 涉及命令：sed×2
