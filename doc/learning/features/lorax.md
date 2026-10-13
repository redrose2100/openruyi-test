# lorax

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/lorax` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_lorax-composer | Test lorax-composer.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_lorax-composer | Test lorax-composer.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_lorax-composer

- 描述：Test lorax-composer.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_lorax-composer

- 描述：Test lorax-composer.socket restart
- 函数：`pre_test, run_test, post_test`