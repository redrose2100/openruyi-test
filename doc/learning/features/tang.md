# tang

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/tang` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_tangd-keygen | Test tangd-keygen.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_tangd-update | Test tangd-update.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_tangd | Test tangd.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_tangd-keygen

- 描述：Test tangd-keygen.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_tangd-update

- 描述：Test tangd-update.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_tangd

- 描述：Test tangd.socket restart
- 函数：`pre_test, run_test, post_test`