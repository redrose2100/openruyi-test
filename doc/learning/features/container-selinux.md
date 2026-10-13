# container-selinux

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/container-selinux` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_container-selinux_install | container-selinux install verification and package check | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_container-selinux_policy | container-selinux policy verification test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_container-selinux_runtime | container-selinux runtime policy test in container environment | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_container-selinux_install

- 描述：container-selinux install verification and package check
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "container-selinux package not installed"
  CHECK_RESULT $? 0 0 "Failed to get container-selinux package info"
  CHECK_RESULT $? 0 0 "SELinux packages directory not found"
  CHECK_RESULT $? 0 0 "container-selinux policy module not found"
```

- 涉及命令：rpm×2

#### oe_test_container-selinux_policy

- 描述：container-selinux policy verification test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to get SELinux mode"
  CHECK_RESULT $? 0 0 "container-selinux policy not loaded"
  CHECK_RESULT $? 0 0 "Failed to get container SELinux types"
  CHECK_RESULT $? 0 0 "Failed to get container SELinux booleans"
  CHECK_RESULT $? 0 0 "container_t type not found"
```

- 涉及命令：seinfo×2, semodule×1, getsebool×1

#### oe_test_container-selinux_runtime

- 描述：container-selinux runtime policy test in container environment
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run container with SELinux"
  CHECK_RESULT $? 0 0 "Failed to access mounted volume with container_file_t context"
```

- 涉及命令：mkdir×1, chcon×1
