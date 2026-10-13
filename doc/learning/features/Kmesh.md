# Kmesh

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/Kmesh` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_base_function | kmesh cli test | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_lb_policy_function | kmesh l7 filter test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_dark_launch_function | kmesh dark launch test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_route_function | kmesh route test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_service_function | kmesh.service start test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_tcp_proxy_weight_cluster_function | kmesh l4 filter test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_kmesh_mda_001 | oncn-mda test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_base_function

- 描述：kmesh cli test
- 函数：`pre_test, run_test, post_test`
- 涉及命令：start_fortio_server×1

#### oe_test_lb_policy_function

- 描述：kmesh l7 filter test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "bad balancing"
```

- 涉及命令：start_fortio_server×2, curl×2

#### oe_test_dark_launch_function

- 描述：kmesh dark launch test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $result 0 0 "bad dark launch"
```

- 涉及命令：start_fortio_server×2, curl×1

#### oe_test_route_function

- 描述：kmesh route test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$_" OK 0 "bad route"
```

- 涉及命令：start_fortio_server×2, curl×1

#### oe_test_service_function

- 描述：kmesh.service start test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "start kmesh service error"
  CHECK_RESULT $? 0 0 "start kmesh service error"
  CHECK_RESULT $? 0 1 "disable fail"
```

- 涉及命令：sed×1

#### oe_test_tcp_proxy_weight_cluster_function

- 描述：kmesh l4 filter test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $result 0 0 "bad tcp weighted cluster select"
```

- 涉及命令：start_fortio_server×2, curl×1

#### oe_test_kmesh_mda_001

- 描述：oncn-mda test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "enable mda error"
  CHECK_RESULT $? 0 0 "accelerate error"
  CHECK_RESULT $? 0 1 "accelerate error"
```

- 涉及命令：wget×1, sed×1, start_fortio_server×1
