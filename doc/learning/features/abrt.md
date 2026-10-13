# abrt

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/abrt` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_abrtd | Test abrtd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_abrt-journal-core | Test abrt-journal-core.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_abrt-oops | Test abrt-oops.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_abrt-pstoreoops | Test abrt-pstoreoops.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_abrt-upload-watch | Test abrt-upload-watch.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_abrt-vmcore | Test abrt-vmcore.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_abrt-xorg | Test abrt-xorg.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_abrtd

- 描述：Test abrtd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_abrt-journal-core

- 描述：Test abrt-journal-core.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_abrt-oops

- 描述：Test abrt-oops.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_abrt-pstoreoops

- 描述：Test abrt-pstoreoops.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_abrt-upload-watch

- 描述：Test abrt-upload-watch.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×1

#### oe_test_service_abrt-vmcore

- 描述：Test abrt-vmcore.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_abrt-xorg

- 描述：Test abrt-xorg.service restart
- 函数：`pre_test, run_test, post_test`