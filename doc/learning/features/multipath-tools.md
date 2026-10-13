# multipath-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/multipath-tools` |
| 注册用例数 | 7 |
| 环境约束 | machine num = 2；add disk = 4 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_multipath-tools_kpartx | The usage of commands in kpartx binary package | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_multipath-tools_mpathconf | The usage of commands in multipath-tools package | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_multipath-tools_mpathpersist | The usage of commands in multipath-tools package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_multipath-tools_multipath_01 | The usage of commands in multipath-tools package | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_multipath-tools_multipath_02 | The usage of commands in multipath-tools package | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_service_multipathd | Test multipathd.service restart | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_socket_multipathd | Test multipathd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_multipath-tools_kpartx

- 描述：The usage of commands in kpartx binary package
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

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
  CHECK_RESULT $? 1
```

- 涉及命令：kpartx×9

#### oe_test_multipath-tools_mpathconf

- 描述：The usage of commands in multipath-tools package
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

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
  ... 共 13 条（其余见源脚本）
```

#### oe_test_multipath-tools_mpathpersist

- 描述：The usage of commands in multipath-tools package
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
  CHECK_RESULT $? 0 1
```

- 涉及命令：mpathpersist×5

#### oe_test_multipath-tools_multipath_01

- 描述：The usage of commands in multipath-tools package
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：multipath×9, test×2

#### oe_test_multipath-tools_multipath_02

- 描述：The usage of commands in multipath-tools package
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

- 涉及命令：multipath×9

#### oe_test_service_multipathd

- 描述：Test multipathd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "multipathd.service reload failed"
  CHECK_RESULT $? 0 0 "multipathd.service reload causes the service status to change"
```

- 涉及命令：sed×2, modprobe×1

#### oe_test_socket_multipathd

- 描述：Test multipathd.socket restart
- 函数：`pre_test, run_test, post_test`