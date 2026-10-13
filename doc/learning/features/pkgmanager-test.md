# pkgmanager-test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/pkgmanager-test` |
| 注册用例数 | 2 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pkg_manager01 | Install software packages directly | pre_test/check_arch_pkg_white_list/run_test/post_test | 14 |  | ✔ | 720m |
| oe_test_pkg_manager02 | Direct upgrade | pre_test/run_test/post_test | 10 |  | ✔ | 720m |

### 断言与命令明细

#### oe_test_pkg_manager01

- 描述：Install software packages directly
- 函数：`pre_test, check_arch_pkg_white_list, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Failed to configure the repo source !"
  CHECK_RESULT $? 0 0 "Failed to get lists !"
  CHECK_RESULT $? 1 0 "Check suffix fail"
  CHECK_RESULT $? 1 0 "Check repo number fail"
  CHECK_RESULT $? 1 0 "Check EPOL repo number fail"
  CHECK_RESULT $? 1 0 "The two architectures are not equal in number,see /home/pkg_manager_folder/arch_diff_everything_pkg.log"
  CHECK_RESULT $? 1 0 "The epol two architectures are not equal in number,see /home/pkg_manager_folder/arch_diff_epol_pkg.log"
  CHECK_RESULT $? 1 0 "install package error !"
  CHECK_RESULT $? 1 0 "EPOL packages install error !"
  CHECK_RESULT $? 1 0 "Check ko insmod fail !"
  CHECK_RESULT $? 0 0 "NODE2 reboot timeout, failed to establish SSH connection"
  CHECK_RESULT $? 1 0 "Remove packages error !"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：test×7, mkdir×1, sed×1, grep×1

#### oe_test_pkg_manager02

- 描述：Direct upgrade
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to configure the repo source !"
  CHECK_RESULT $? 0 0 "Failed to get lists !"
  CHECK_RESULT $? 1 0 "Packages upgrade error !"
  CHECK_RESULT $? 1 0 "EPOL packages upgrade error !"
  CHECK_RESULT $? 0 0 "NODE2 reboot timeout, failed to establish SSH connection"
  CHECK_RESULT $? 1 0 "Downgrade packages error !"
  CHECK_RESULT $? 1 0 "Downgrade epol packages error !"
  CHECK_RESULT $? 1 0 "Remove packages error !"
  CHECK_RESULT $? 1 0 "Remove epol packages error !"
  CHECK_RESULT $? 0 0 "NODE2 reboot timeout, failed to establish SSH connection"
```

- 涉及命令：test×7, mkdir×1, sed×1
