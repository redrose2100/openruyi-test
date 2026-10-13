# libvirt-python

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libvirt-python` |
| 注册用例数 | 3 |
| 环境约束 | machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libvirt-python_basic | Test python3-libvirt basic functionality | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_libvirt-python_lifecycle | Test python3-libvirt VM lifecycle management | config_params/pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_libvirt-python_monitor | Test python3-libvirt VM status monitoring | config_params/pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libvirt-python_basic

- 描述：Test python3-libvirt basic functionality
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "python3-libvirt module import failed"
  CHECK_RESULT $? 0 0 "libvirt version did not match package version"
  CHECK_RESULT $? 0 0 "libvirt constant VIR_DOMAIN_RUNNING get failed"
  CHECK_RESULT $? 0 0 "libvirt connection to qemu:///system failed"
  CHECK_RESULT $? 0 0 "libvirt connection to qemu:///session failed"
```

- 涉及命令：python3×5

#### oe_test_libvirt-python_lifecycle

- 描述：Test python3-libvirt VM lifecycle management
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "VM define failed"
  CHECK_RESULT $? 0 0 "VM start failed"
  CHECK_RESULT $? 0 0 "VM suspend failed"
  CHECK_RESULT $? 0 0 "VM resume failed"
  CHECK_RESULT $? 0 0 "VM shutdown failed"
  CHECK_RESULT $? 0 0 "VM destroy failed"
  CHECK_RESULT $? 0 0 "VM undefine failed"
  CHECK_RESULT $? 0 0 "VM undefine failed"
```

- 涉及命令：python3×8

#### oe_test_libvirt-python_monitor

- 描述：Test python3-libvirt VM status monitoring
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "VM define failed"
  CHECK_RESULT $? 0 0 "VM state get failed"
  CHECK_RESULT $? 0 0 "VM UUID get failed"
  CHECK_RESULT $? 0 0 "VM ID get failed"
  CHECK_RESULT $? 0 0 "VM maxMemory get failed"
  CHECK_RESULT $? 0 0 "VM maxVcpus get failed"
  CHECK_RESULT $? 0 0 "VM XMLDesc get failed"
  CHECK_RESULT $? 0 0 "listAllDomains failed"
```

- 涉及命令：python3×11
