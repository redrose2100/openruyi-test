# ceph

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ceph` |
| 注册用例数 | 12 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_rbdmap | Test rbdmap.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_target_ceph-fuse | Test ceph-fuse.target restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_target_ceph-mds | Test ceph-mds.target restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_target_ceph-mgr | Test ceph-mgr.target restart | pre_test/run_test/post_test | 2 | ✔ |  | 50m |
| oe_test_target_ceph-mon | Test ceph-mon.target restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_target_ceph-osd | Test ceph-osd.target restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_target_ceph-radosgw | Test ceph-radosgw.target restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_target_ceph-rbd-mirror | Test ceph-rbd-mirror.target restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_target_ceph | Test ceph.target restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_ceph-crash | Test ceph-crash.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_target_cephfs-mirror | Test cephfs-mirror.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_ceph-immutable-object-cache | Test ceph-immutable-object-cache.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_rbdmap

- 描述：Test rbdmap.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "rbdmap.service reload failed"
  CHECK_RESULT $? 0 0 "rbdmap.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_target_ceph-fuse

- 描述：Test ceph-fuse.target restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_target_ceph-mds

- 描述：Test ceph-mds.target restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_target_ceph-mgr

- 描述：Test ceph-mgr.target restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_target_ceph-mon

- 描述：Test ceph-mon.target restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_target_ceph-osd

- 描述：Test ceph-osd.target restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_target_ceph-radosgw

- 描述：Test ceph-radosgw.target restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_target_ceph-rbd-mirror

- 描述：Test ceph-rbd-mirror.target restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_target_ceph

- 描述：Test ceph.target restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_service_ceph-crash

- 描述：Test ceph-crash.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_target_cephfs-mirror

- 描述：Test cephfs-mirror.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_ceph-immutable-object-cache

- 描述：Test ceph-immutable-object-cache.target restart
- 函数：`pre_test, run_test, post_test`