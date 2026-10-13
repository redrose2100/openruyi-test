# nfs-utils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nfs-utils` |
| 注册用例数 | 17 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_auth-rpcgss-module | Test auth-rpcgss-module.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nfs-blkmap | Test nfs-blkmap.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nfsdcld | Test nfsdcld.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nfs-idmapd | Test nfs-idmapd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nfs-idmap | Test nfs-idmap.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nfs-lock | Test nfs-lock.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nfs-mountd | Test nfs-mountd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nfs-secure | Test nfs-secure.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_nfs-server | Test nfs-server.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_nfs | Test nfs.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_nfs-utils | Test nfs-utils.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_rpc-gssd | Test rpc-gssd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_rpc-statd-notify | Test rpc-statd-notify.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_rpc-statd | Test rpc-statd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_nfs-client | Test nfs-client.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_target_rpc_pipefs | Test rpc_pipefs.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_fsidd | Test fsidd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_auth-rpcgss-module

- 描述：Test auth-rpcgss-module.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_nfs-blkmap

- 描述：Test nfs-blkmap.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：modprobe×1

#### oe_test_service_nfsdcld

- 描述：Test nfsdcld.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_nfs-idmapd

- 描述：Test nfs-idmapd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_nfs-idmap

- 描述：Test nfs-idmap.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_nfs-lock

- 描述：Test nfs-lock.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_nfs-mountd

- 描述：Test nfs-mountd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_nfs-secure

- 描述：Test nfs-secure.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_nfs-server

- 描述：Test nfs-server.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "nfs-server.service reload failed"
  CHECK_RESULT $? 0 0 "nfs-server.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_nfs

- 描述：Test nfs.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "nfs.service reload failed"
  CHECK_RESULT $? 0 0 "nfs.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_nfs-utils

- 描述：Test nfs-utils.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_rpc-gssd

- 描述：Test rpc-gssd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_rpc-statd-notify

- 描述：Test rpc-statd-notify.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_rpc-statd

- 描述：Test rpc-statd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_nfs-client

- 描述：Test nfs-client.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_rpc_pipefs

- 描述：Test rpc_pipefs.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_fsidd

- 描述：Test fsidd.service restart
- 函数：`pre_test, run_test, post_test`