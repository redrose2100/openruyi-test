# network_docker

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/network-test/network_docker` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_docker_network_create | Create bridge for docker | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_docker_network_format | Check docker network format | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_docker_set_ip | Set ip for docker | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_docker_network_create

- 描述：Create bridge for docker
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check docker0 brctl failed."
  CHECK_RESULT $? 0 0 "Create docker_bridge failed."
  CHECK_RESULT $? 0 0 "Check docker_bridge failed."
  CHECK_RESULT $? 1 0 "Check docker network list deleted failed."
  CHECK_RESULT $? 1 0 "Check docker_bridge deleted failed."
```

#### oe_test_docker_network_format

- 描述：Check docker network format
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check default network format failed."
  CHECK_RESULT $? 0 0 "Create docker with set net=host failed."
  CHECK_RESULT $? 0 0 "Create docker with set net=bridge failed."
  CHECK_RESULT $? 0 0 "Create docker with set net=none failed."
  CHECK_RESULT $? 0 0 "check test_docker1 with set net=host failed."
  CHECK_RESULT $? 0 0 "check test_docker2 with set net=bridge failed."
  CHECK_RESULT $? 0 0 "check test_docker3 with set net=none failed."
```

#### oe_test_docker_set_ip

- 描述：Set ip for docker
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check docker created failed."
  CHECK_RESULT $? 0 0 "Check test_docker created failed."
  CHECK_RESULT $? 0 0 "Check ip in docker failed."
```
