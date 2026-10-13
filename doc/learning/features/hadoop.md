# hadoop

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/hadoop` |
| 注册用例数 | 10 |
| 环境约束 | machine num = 3 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_hadoop-datanode | Test hadoop-datanode.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_hadoop-journalnode | Test hadoop-journalnode.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_hadoop-namenode | Test hadoop-namenode.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_hadoop-nodemanager | Test hadoop-nodemanager.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_hadoop-proxyserver | Test hadoop-proxyserver.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_hadoop-resourcemanager | Test hadoop-resourcemanager.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_hadoop-secondarynamenode | Test hadoop-secondarynamenode.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_hadoop-timelineserver | Test hadoop-timelineserver.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_hadoop-historyserver | Test hadoop-historyserver.service restart | pre_test/run_test/post_test | 0 | ✔ | ✔ |  |
| oe_test_service_hadoop-zkfc | Test hadoop-zkfc.service restart | pre_test/run_test/post_test | 0 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_service_hadoop-datanode

- 描述：Test hadoop-datanode.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3

#### oe_test_service_hadoop-journalnode

- 描述：Test hadoop-journalnode.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3

#### oe_test_service_hadoop-namenode

- 描述：Test hadoop-namenode.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3

#### oe_test_service_hadoop-nodemanager

- 描述：Test hadoop-nodemanager.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3

#### oe_test_service_hadoop-proxyserver

- 描述：Test hadoop-proxyserver.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×4

#### oe_test_service_hadoop-resourcemanager

- 描述：Test hadoop-resourcemanager.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3

#### oe_test_service_hadoop-secondarynamenode

- 描述：Test hadoop-secondarynamenode.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3

#### oe_test_service_hadoop-timelineserver

- 描述：Test hadoop-timelineserver.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3

#### oe_test_service_hadoop-historyserver

- 描述：Test hadoop-historyserver.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×12, grep×6, dnf×4, kill×3

#### oe_test_service_hadoop-zkfc

- 描述：Test hadoop-zkfc.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×12, grep×6, dnf×4, kill×3
