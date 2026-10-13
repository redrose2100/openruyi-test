# ostree

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ostree` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_ostree-finalize-staged | Test ostree-finalize-staged.service ostree-prepare-root.service ostree-remount.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_ostree-prepare-root | Test ostree-prepare-root.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_ostree-remount | Test ostree-remount.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_ostree-boot-complete | Test ostree-boot-complete.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_ostree-finalize-staged-hold | Test ostree-finalize-staged-hold.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_ostree-finalize-staged

- 描述：Test ostree-finalize-staged.service ostree-prepare-root.service ostree-remount.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_ostree-prepare-root

- 描述：Test ostree-prepare-root.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_ostree-remount

- 描述：Test ostree-remount.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_ostree-boot-complete

- 描述：Test ostree-boot-complete.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_ostree-finalize-staged-hold

- 描述：Test ostree-finalize-staged-hold.service restart
- 函数：`pre_test, run_test, post_test`