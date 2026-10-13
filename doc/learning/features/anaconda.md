# anaconda

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/anaconda` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_anaconda-direct | Test anaconda-direct.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_anaconda-nm-config | Test anaconda-nm-config.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_anaconda-noshell | Test anaconda-noshell.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_anaconda-pre | Test anaconda-pre.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_anaconda | Test anaconda.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_anaconda-sshd | Test anaconda-sshd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_instperf | Test instperf.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_anaconda | 测试服务状态 | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_anaconda-fips | Test anaconda-fips.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_anaconda-direct

- 描述：Test anaconda-direct.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_anaconda-nm-config

- 描述：Test anaconda-nm-config.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_anaconda-noshell

- 描述：Test anaconda-noshell.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_anaconda-pre

- 描述：Test anaconda-pre.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_anaconda

- 描述：Test anaconda.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_anaconda-sshd

- 描述：Test anaconda-sshd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_instperf

- 描述：Test instperf.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_anaconda

- 描述：测试服务状态
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_anaconda-fips

- 描述：Test anaconda-fips.service restart
- 函数：`pre_test, run_test, post_test`