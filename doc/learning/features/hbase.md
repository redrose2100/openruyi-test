# hbase

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/hbase` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_hbase-master | Test hbase-master.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_hbase-regionserver | Test hbase-regionserver.service restart | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_service_hbase-rest | Test hbase-rest.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_hbase-thrift | Test hbase-thrift.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_hbase-thrift02 | Test hbase-thrift02 test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_service_hbase-zookeeper | Test hbase-zookeeper.service restart | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_hbase-master_1 | Test hbase-master.service restart | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_hbase-master

- 描述：Test hbase-master.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3, sudo×1

#### oe_test_service_hbase-regionserver

- 描述：Test hbase-regionserver.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "HBase version check failed"
  CHECK_RESULT $? 0 0 "HBase help command check failed"
  CHECK_RESULT $? 0 0 "HBase shell startup check failed"
```

- 涉及命令：sed×3, sudo×1

#### oe_test_service_hbase-rest

- 描述：Test hbase-rest.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×4, sudo×1

#### oe_test_service_hbase-thrift

- 描述：Test hbase-thrift.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：sed×3, sudo×1

#### oe_test_hbase-thrift02

- 描述：Test hbase-thrift02 test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "HBase shell startup check failed"
  CHECK_RESULT $? 0 0 "HBase basic operations check failed"
  CHECK_RESULT $? 0 0 "HBase Thrift port is not listening"
```

- 涉及命令：sed×3, sudo×1, netstat×1

#### oe_test_service_hbase-zookeeper

- 描述：Test hbase-zookeeper.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 " hbase-zookeeper.service restart failed"
  CHECK_RESULT $? 0 0 " hbase-zookeeper.service restart failed"
  CHECK_RESULT $? 0 0 " hbase-zookeeper.service stop failed"
  CHECK_RESULT $? 0 0 " hbase-zookeeper.service stop failed"
  CHECK_RESULT $? 0 0 "hbase-zookeeper.service start failed"
  CHECK_RESULT $? 0 0 "hbase-zookeeper.service start failed"
```

- 涉及命令：sed×3, sudo×1

#### oe_test_hbase-master_1

- 描述：Test hbase-master.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "HBase shell startup test failed"
  CHECK_RESULT $? 0 0 "HBase table creation test failed"
  CHECK_RESULT $? 0 0 "HBase data insertion and query test failed"
```

- 涉及命令：sed×3, sudo×1
