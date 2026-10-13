# dbus

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/dbus` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_dbus | Test dbus.service restart | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_socket_dbus | Test dbus.socket restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_dbus_dbus-daemon | exrmultipart exrheader exrenvmap | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dbus_dbus-run-session | exrmultipart exrheader exrenvmap | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dbus_dbus-tools_001 | exrmultipart exrheader exrenvmap | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dbus_dbus-tools_002 | exrmultipart exrheader exrenvmap | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_dbus_dbus-x11 | exrmultipart exrheader exrenvmap | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_busctl | test busctl | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_dbus-glib | test dbus-glib | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_dbus

- 描述：Test dbus.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload failed"
  CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_socket_dbus

- 描述：Test dbus.socket restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_dbus_dbus-daemon

- 描述：exrmultipart exrheader exrenvmap
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check dbus-daemon -h failed."
  CHECK_RESULT $? 0 0 "Check dbus-daemon --version failed."
  CHECK_RESULT $? 0 0 "Check bus-daemon --session failed."
  CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork failed."
  CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork --print-address failed."
  CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork --print-pid failed."
  CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork --introspect failed."
  CHECK_RESULT $? 0 0 "Check dbus-daemon --session --nofork failed."
  CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork --address=unix:abstract=/tmp/dbus-123456 --print-address failed."
  CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork --nopidfile failed."
```

- 涉及命令：pgrep×3, dbus-daemon×1

#### oe_test_dbus_dbus-run-session

- 描述：exrmultipart exrheader exrenvmap
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check dbus-run-session --help failed."
  CHECK_RESULT $? 0 0 "Check dbus-run-session --version failed."
  CHECK_RESULT $? 0 0 "Check dbus-cleanup-sockets --help failed."
  CHECK_RESULT $? 0 0 "Check dbus-cleanup-sockets --version failed."
  CHECK_RESULT $? 0 0 "Check dbus-cleanup-sockets /tmp failed."
  CHECK_RESULT $? 0 0 "Check dbus-test-tool black-hole --session failed."
  CHECK_RESULT $? 0 0 "Check dbus-test-tool black-hole --system failed."
  CHECK_RESULT $? 0 0 "Check dbus-test-tool black-hole --name=com.example.NoReply failed."
  CHECK_RESULT $? 0 0 "Check dbus-test-tool black-hole --no-read failed."
```

#### oe_test_dbus_dbus-tools_001

- 描述：exrmultipart exrheader exrenvmap
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check dbus-test-tool --name echo failed."
  CHECK_RESULT $? 0 0 "Check dbus-test-tool echo --sleep-ms failed."
  CHECK_RESULT $? 0 0 "Check dbus-test-tool echo --session failed."
  CHECK_RESULT $? 0 0 "Check dbus-test-tool echo --system failed."
  CHECK_RESULT $? 0 0 "Check dbus-monitor -h failed."
  CHECK_RESULT $? 0 0 "Check dbus-monitor --system failed."
  CHECK_RESULT $? 0 0 "Check dbus-monitor --profile failed."
  CHECK_RESULT $? 0 0 "Check dbus-monitor --monitor failed."
  CHECK_RESULT $? 0 0 "Check dbus-monitor --session failed."
```

- 涉及命令：dbus-monitor×1

#### oe_test_dbus_dbus-tools_002

- 描述：exrmultipart exrheader exrenvmap
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check dbus-send --help failed."
  CHECK_RESULT $? 0 0 "Check dbus-send --session --type failed."
  CHECK_RESULT $? 0 0 "Check dbus-send --session --type=method_call --print-reply=literal --dest failed."
  CHECK_RESULT $? 0 0 "Check dbus-send --session --type=method_call --dest failed."
  CHECK_RESULT $? 0 0 "Check dbus-send --system --type=method_call --print-reply=literal --dest=org.freedesktop.DBus failed."
  CHECK_RESULT $? 0 0 "Check dbus-send --system --type=method_call --print-reply=literal --reply-timeout=1 --dest=org.freedesktop.DBus failed."
  CHECK_RESULT $? 0 0 "Check dbus-update-activation-environment -h failed."
  CHECK_RESULT $? 0 0 "Check dbus-update-activation-environment --all failed."
  CHECK_RESULT $? 0 0 "Check dbus-update-activation-environment --systemd failed."
  CHECK_RESULT $? 0 0 "Check dbus-update-activation-environment --all --verbose failed."
```

- 涉及命令：dbus-update-activation-environment×1

#### oe_test_dbus_dbus-x11

- 描述：exrmultipart exrheader exrenvmap
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check  failed."
  CHECK_RESULT $? 0 0 "Check  failed."
  CHECK_RESULT $? 0 0 "Check  failed."
  CHECK_RESULT $? 0 0 "Check  failed."
  CHECK_RESULT $? 0 0 "Check  failed."
  CHECK_RESULT $? 0 0 "Check  failed."
  CHECK_RESULT $? 0 0 "Check  failed."
  CHECK_RESULT $? 0 0 "Check  failed."
  CHECK_RESULT $? 0 0 "Check  failed."
  CHECK_RESULT $? 0 0 "Check  failed."
  CHECK_RESULT $? 0 0 "Check  failed."
  CHECK_RESULT $? 0 0 "Check  failed."
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：dbus-launch×1

#### oe_test_busctl

- 描述：test busctl
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 'busctl failed.'
  CHECK_RESULT $? 0 0 'busctl status failed.'
  CHECK_RESULT $? 0 0 'busctl tree failed.'
  CHECK_RESULT $? 0 0 'busctl tree failed.'
```

#### oe_test_dbus-glib

- 描述：test dbus-glib
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Generate GLib server-side code error"
  CHECK_RESULT $? 0 0 "Generate GLib client code error"
  CHECK_RESULT $? 0 0 "Generate readable text output error"
```
