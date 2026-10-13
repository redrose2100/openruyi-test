# etcd

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/etcd` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_etcd | Test etcd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_etcd_01 | verification etcd‘s command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_etcd_02 | verification etcd‘s command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_etcd_03 | verification etcd‘s command | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_etcd_04 | verification etcd‘s command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_etcd_05 | verification etcd‘s command | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_etcd

- 描述：Test etcd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_etcd_01

- 描述：verification etcd‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check etcd.service start failed"
  CHECK_RESULT $? 0 0 "Check etcd --help failed."
  CHECK_RESULT $? 0 0 "Check etcd --version failed."
  CHECK_RESULT $? 0 0 "Check etcdctl version failed."
  CHECK_RESULT $? 0 0 "Check etcdctl help failed."
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints put command failed."
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints get command failed."
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints get -w=json command failed."
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints del command failed."
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints del command failed."
```

#### oe_test_etcd_02

- 描述：verification etcd‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check etcd.service start failed"
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints member command failed."
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints --write-out=table failed."
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints --write-out=table health failed."
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints health failed"
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints status failed."
  CHECK_RESULT $? 0 0 "Check etcdctl snapshot save command failed."
  CHECK_RESULT $? 0 0 "Check etcdctl snapshot status command failed."
  CHECK_RESULT $? 0 0 "Check etcdctl snapshot status -w table command failed."
  CHECK_RESULT $? 0 0 "Check etcdctl endpoint --cluster=true status command failed."
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints endpoint move-leader command failed."
```

#### oe_test_etcd_03

- 描述：verification etcd‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Check etcd.service start failed"
  CHECK_RESULT $? 0 0 "Check etcdctl user add failed."
  CHECK_RESULT $? 0 0 "Check etcdctl user add failed."
  CHECK_RESULT $? 0 0 "Check etcdctl auth enable failed."
  CHECK_RESULT $? 0 0 "Check etcdctl role add failed."
  CHECK_RESULT $? 0 0 "Check etcdctl user grant-role failed."
  CHECK_RESULT $? 0 0 "Check etcdctl role grant-permission failed."
  CHECK_RESULT $? 0 0 "Check etcdctl put failed."
  CHECK_RESULT $? 0 0 "Check etcdctl get --user failed."
  CHECK_RESULT $? 0 0 "Check etcdctl user list failed."
  CHECK_RESULT $? 0 0 "Check etcdctl user deletel failed."
  CHECK_RESULT $? 1 0 "Check etcdctl user deletel failed."
  ... 共 15 条（其余见源脚本）
```

#### oe_test_etcd_04

- 描述：verification etcd‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check etcd.service start failed"
  CHECK_RESULT $? 0 0 "Check etcdctl user passwd root failed."
  CHECK_RESULT $? 0 0 "Check etcdctl lease grant failed."
  CHECK_RESULT $? 0 0 "Check etcdctl lease keep-alive failed."
  CHECK_RESULT $? 0 0 "Check etcdctl lease timetolive failed."
  CHECK_RESULT $? 0 0 "Check etcdctl list failed."
  CHECK_RESULT $? 0 0 "Check etcdctl revoke failed."
  CHECK_RESULT $? 1 0 "Check etcdctl list failed."
  CHECK_RESULT $? 0 0 "Check etcdctl user del failed."
```

#### oe_test_etcd_05

- 描述：verification etcd‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check etcd.service start failed"
  CHECK_RESULT $? 0 0 "Check etcdctl defrag failed."
  CHECK_RESULT $? 0 0 "Check etcdctl --endpoints failed."
  CHECK_RESULT $? 0 0 "Check etcdctl alarm disarm failed."
  CHECK_RESULT $? 0 0 "Check etcdctl alarm listfailed."
  CHECK_RESULT $? 0 0 "Check etcdctl check datascale failed."
  CHECK_RESULT $? 0 0 "Check etcdctl check perf failed."
```
