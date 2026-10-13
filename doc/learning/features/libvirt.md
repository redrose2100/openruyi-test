# libvirt

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libvirt` |
| 注册用例数 | 48 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_libvirtd | Test libvirtd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_libvirt-guests | Test libvirt-guests.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_virtinterfaced | Test virtinterfaced.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_virtlockd | Test virtlockd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_virtlogd | Test virtlogd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_virtnetworkd | Test virtnetworkd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_virtnodedevd | Test virtnodedevd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_virtnwfilterd | Test virtnwfilterd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_virtproxyd | Test virtproxyd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_virtqemud | Test virtqemud.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_virtsecretd | Test virtsecretd.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_virtstoraged | Test virtstoraged.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_socket_libvirtd-admin | Test libvirtd-admin.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_libvirtd-ro | Test libvirtd-ro.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_libvirtd | Test libvirtd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_libvirtd-tcp | Test libvirtd-tcp.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_libvirtd-tls | Test libvirtd-tls.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtinterfaced-admin | Test virtinterfaced-admin.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtinterfaced-ro | Test virtinterfaced-rd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtinterfaced | Test virtinterfaced.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtlockd-admin | Test virtlockd-admin.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtlockd | Test virtlockd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtlogd-admin | Test virtlogd-admin.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtlogd | Test virtlogd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtnetworkd-admin | Test virtnetworkd-admin.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtnetworkd-ro | Test virtnetworkd-ro.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtnetworkd | Test virtnetworkd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtnodedevd-admin | Test virtnodedevd-admin.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtnodedevd-ro | Test virtnodedevd-ro.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtnodedevd | Test virtnodedevd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtnwfilterd-admin | Test virtnwfilterd-admin.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtnwfilterd-ro | Test virtnwfilterd-ro.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtnwfilterd | Test virtnwfilterd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtproxyd-admin | Test virtproxyd-admin.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtproxyd-ro | Test virtproxyd-ro.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtproxyd | Test virtproxyd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtproxyd-tcp | Test virtproxyd-tcp.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtproxyd-tls | Test virtproxyd-tls.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtqemud-admin | Test virtqemud-admin.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtqemud-ro | Test virtqemud-ro.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtqemud | Test virtqemud.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtsecretd-admin | Test virtsecretd-admin.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtsecretd-ro | Test virtsecretd-ro.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtsecretd | Test virtsecretd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtstoraged-admin | Test virtstoraged-admin.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtstoraged-ro | Test virtstoraged-ro.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_virtstoraged | Test virtstoraged.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_virt-guest-shutdown | Test virt-guest-shutdown.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_libvirtd

- 描述：Test libvirtd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "libvirtd.service reload failed"
  CHECK_RESULT $? 0 0 "libvirtd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_libvirt-guests

- 描述：Test libvirt-guests.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_virtinterfaced

- 描述：Test virtinterfaced.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "virtinterfaced.service reload failed"
  CHECK_RESULT $? 0 0 "virtinterfaced.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_virtlockd

- 描述：Test virtlockd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "virtlockd.service reload failed"
  CHECK_RESULT $? 0 0 "virtlockd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_virtlogd

- 描述：Test virtlogd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "virtlogd.service reload failed"
  CHECK_RESULT $? 0 0 "virtlogd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_virtnetworkd

- 描述：Test virtnetworkd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "virtnetworkd.service reload failed"
  CHECK_RESULT $? 0 0 "virtnetworkd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_virtnodedevd

- 描述：Test virtnodedevd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "virtnodedevd.service reload failed"
  CHECK_RESULT $? 0 0 "virtnodedevd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_virtnwfilterd

- 描述：Test virtnwfilterd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "virtnwfilterd.service reload failed"
  CHECK_RESULT $? 0 0 "virtnwfilterd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_virtproxyd

- 描述：Test virtproxyd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "virtproxyd.service reload failed"
  CHECK_RESULT $? 0 0 "virtproxyd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_virtqemud

- 描述：Test virtqemud.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "virtqemud.service reload failed"
  CHECK_RESULT $? 0 0 "virtqemud.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_virtsecretd

- 描述：Test virtsecretd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "virtsecretd.service reload failed"
  CHECK_RESULT $? 0 0 "virtsecretd.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_virtstoraged

- 描述：Test virtstoraged.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "virtstoraged.service reload failed"
  CHECK_RESULT $? 0 0 "virtstoraged.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_socket_libvirtd-admin

- 描述：Test libvirtd-admin.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_libvirtd-ro

- 描述：Test libvirtd-ro.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_libvirtd

- 描述：Test libvirtd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_libvirtd-tcp

- 描述：Test libvirtd-tcp.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_libvirtd-tls

- 描述：Test libvirtd-tls.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtinterfaced-admin

- 描述：Test virtinterfaced-admin.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtinterfaced-ro

- 描述：Test virtinterfaced-rd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtinterfaced

- 描述：Test virtinterfaced.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtlockd-admin

- 描述：Test virtlockd-admin.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtlockd

- 描述：Test virtlockd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtlogd-admin

- 描述：Test virtlogd-admin.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtlogd

- 描述：Test virtlogd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtnetworkd-admin

- 描述：Test virtnetworkd-admin.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtnetworkd-ro

- 描述：Test virtnetworkd-ro.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtnetworkd

- 描述：Test virtnetworkd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtnodedevd-admin

- 描述：Test virtnodedevd-admin.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtnodedevd-ro

- 描述：Test virtnodedevd-ro.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtnodedevd

- 描述：Test virtnodedevd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtnwfilterd-admin

- 描述：Test virtnwfilterd-admin.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtnwfilterd-ro

- 描述：Test virtnwfilterd-ro.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtnwfilterd

- 描述：Test virtnwfilterd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtproxyd-admin

- 描述：Test virtproxyd-admin.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtproxyd-ro

- 描述：Test virtproxyd-ro.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtproxyd

- 描述：Test virtproxyd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtproxyd-tcp

- 描述：Test virtproxyd-tcp.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtproxyd-tls

- 描述：Test virtproxyd-tls.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtqemud-admin

- 描述：Test virtqemud-admin.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtqemud-ro

- 描述：Test virtqemud-ro.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtqemud

- 描述：Test virtqemud.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtsecretd-admin

- 描述：Test virtsecretd-admin.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtsecretd-ro

- 描述：Test virtsecretd-ro.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtsecretd

- 描述：Test virtsecretd.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtstoraged-admin

- 描述：Test virtstoraged-admin.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtstoraged-ro

- 描述：Test virtstoraged-ro.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_virtstoraged

- 描述：Test virtstoraged.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_virt-guest-shutdown

- 描述：Test virt-guest-shutdown.target restart
- 函数：`pre_test, run_test, post_test`