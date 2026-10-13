# amanda

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/amanda` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_amanda_amcheck | Test amcheck | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_amanda_ambackup | Test amcheck | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_amanda_amssl | Test amcheck | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_service_amanda-udp | Test amanda-udp.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_amanda | Test amanda.socket restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_amanda_aespipe | Test amaespipe | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_socket_amanda-udp | Test amanda-udp.socket restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_amanda_dump | Test amcheck | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_socket_kamanda | Test kamanda.socket restart | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_amanda_amcheck

- 描述：Test amcheck
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check amcheck failed"
  CHECK_RESULT $? 0 0 "Check amlabel failed"
  CHECK_RESULT $? 0 0 "Check amdump failed"
  CHECK_RESULT $? 0 0 "Check amreport failed"
  CHECK_RESULT $? 0 0 "Check amadmin failed"
  CHECK_RESULT $? 0 0 "Check amcheckdump failed"
  CHECK_RESULT $? 0 0 "Check amarchiver failed"
  CHECK_RESULT $? 0 0 "Check amcheckdb failed"
  CHECK_RESULT $? 0 0 "Check amstatus failed"
  CHECK_RESULT $? 0 0 "Check amoverview failed"
  CHECK_RESULT $? 0 0 "Check amdevcheck failed"
```

- 涉及命令：mkdir×1, chown×1

#### oe_test_amanda_ambackup

- 描述：Test amcheck
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check ambackup failed"
  CHECK_RESULT $? 0 0 "Check amcleanup failed"
  CHECK_RESULT $? 0 0 "Check amcleanupdisk failed"
  CHECK_RESULT $? 0 0 "Check amgetconf failed"
  CHECK_RESULT $? 0 0 "Check amgpgcrypt failed"
  CHECK_RESULT $? 0 0 "Check amtoc failed"
  CHECK_RESULT $? 0 0 "Check amtape failed"
  CHECK_RESULT $? 0 0 "Check amcrypt-ossl failed"
  CHECK_RESULT $? 0 0 "Check amcrypt-ossl-asym failed"
```

- 涉及命令：mkdir×1, chown×1, grep×1

#### oe_test_amanda_amssl

- 描述：Test amcheck
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check amssl failed"
  CHECK_RESULT $? 0 0 "Check amaddclient failed"
  CHECK_RESULT $? 0 0 "Check amcryptsimple failed"
  CHECK_RESULT $? 0 0 "Check amreindex failed"
  CHECK_RESULT $? 0 0 "Check amserverconfig failed"
  CHECK_RESULT $? 0 0 "Check amrmtape failed"
  CHECK_RESULT $? 0 0 "Check amanda-rest-server failed"
  CHECK_RESULT $? 0 0 "Check amandad failed"
```

- 涉及命令：mkdir×2, chown×2

#### oe_test_service_amanda-udp

- 描述：Test amanda-udp.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_amanda

- 描述：Test amanda.socket restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_amanda_aespipe

- 描述：Test amaespipe
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check amaespipe failed"
  CHECK_RESULT $? 0 0 "Check amcrypt failed"
```

- 涉及命令：mkdir×2, tar×1, pgrep×1, kill×1

#### oe_test_socket_amanda-udp

- 描述：Test amanda-udp.socket restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_amanda_dump

- 描述：Test amcheck
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check amdump_client failed"
  CHECK_RESULT $? 0 0 "Check amrecover failed"
  CHECK_RESULT $? 0 0 "Check amservice failed"
  CHECK_RESULT $? 0 0 "Check amrestore failed"
  CHECK_RESULT $? 0 0 "Check amfetchdump failed"
  CHECK_RESULT $? 0 0 "Check amflush failed"
  CHECK_RESULT $? 0 0 "Check amoldrecover failed"
```

- 涉及命令：mkdir×1, chown×1

#### oe_test_socket_kamanda

- 描述：Test kamanda.socket restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```
