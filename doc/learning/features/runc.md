# runc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/runc` |
| 注册用例数 | 2 |
| 环境约束 | machine num = 1；machine type = kvm；add network interface = 1；add disk =  |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_runc_lifecycle | runc container lifecycle test with command arguments | pre_test/run_test/post_test | 35 | ✔ |  |  |
| oe_test_runc_management | runc container management test with command arguments | pre_test/run_test/post_test | 23 | ✔ |  |  |

### 断言与命令明细

#### oe_test_runc_lifecycle

- 描述：runc container lifecycle test with command arguments
- 函数：`pre_test, run_test, post_test`
- 断言（35 条）：

```
  CHECK_RESULT $? 0 0 "runc --version failed"
  CHECK_RESULT $? 0 0 "runc -v failed"
  CHECK_RESULT $? 0 0 "runc --help failed"
  CHECK_RESULT $? 0 0 "runc -h failed"
  CHECK_RESULT $? 0 0 "runc spec failed"
  CHECK_RESULT $? 0 0 "config.json doesn't contain ociVersion"
  CHECK_RESULT $? 0 0 "runc spec --rootless failed"
  CHECK_RESULT $? 0 0 "rootless config.json doesn't contain user namespace"
  CHECK_RESULT $? 0 0 "runc spec -b failed"
  CHECK_RESULT $? 0 0 "config.json not created with -b"
  CHECK_RESULT $? 0 0 "runc create failed"
  CHECK_RESULT $? 0 0 "Container is not in created state"
  ... 共 35 条（其余见源脚本）
```

- 涉及命令：grep×5, python3×5, runc×2

#### oe_test_runc_management

- 描述：runc container management test with command arguments
- 函数：`pre_test, run_test, post_test`
- 断言（23 条）：

```
  CHECK_RESULT $? 0 0 "runc run -d failed"
  CHECK_RESULT $? 0 0 "Container is not running after run -d"
  CHECK_RESULT $? 0 0 "runc list failed"
  CHECK_RESULT $? 0 0 "runc list -f json failed"
  CHECK_RESULT $? 0 0 "runc list -q failed"
  CHECK_RESULT $? 0 0 "runc state failed"
  CHECK_RESULT $? 0 0 "runc ps failed"
  CHECK_RESULT $? 0 0 "runc ps -f json failed"
  CHECK_RESULT $? 0 0 "runc exec failed"
  CHECK_RESULT $? 0 0 "runc pause failed"
  CHECK_RESULT $? 0 0 "Container is not paused"
  CHECK_RESULT $? 0 0 "runc resume failed"
  ... 共 23 条（其余见源脚本）
```

- 涉及命令：python3×1, mkdir×1
