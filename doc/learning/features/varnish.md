# varnish

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/varnish` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_varnishncsa | Test varnishncsa.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_varnish | Test varnish.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_varnish_01 | varnish common prepare | pre_test/run_test/post_test | 14 |  |  |  |
| oe_test_varnish_02 | varnish common prepare | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_varnish_03 | varnish common prepare | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_varnish_04 | varnish common prepare | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_varnish_05 | varnish common prepare | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_varnish_06 | varnish common prepare | pre_test/run_test/post_test | 10 |  |  |  |

### 断言与命令明细

#### oe_test_service_varnishncsa

- 描述：Test varnishncsa.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "varnishncsa.service reload failed"
  CHECK_RESULT $? 0 0 "varnishncsa.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_varnish

- 描述：Test varnish.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "varnish.service reload failed"
  CHECK_RESULT $? 0 0 "varnish.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_varnish_01

- 描述：varnish common prepare
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "varnish -h failed"
  CHECK_RESULT $? 0 0 "varnishadm quit failed"
  CHECK_RESULT $? 0 0 "varnishadm quit failed"
  CHECK_RESULT $? 0 0 "varnishadm help failed"
  CHECK_RESULT $? 0 0 "varnishadm help failed"
  CHECK_RESULT $? 0 0 "varnishadm help failed"
  CHECK_RESULT $? 0 0 "varnishadm help failed"
  CHECK_RESULT $? 0 0 "varnishadm status failed"
  CHECK_RESULT $? 0 0 "varnishadm stop failed"
  CHECK_RESULT $? 0 0 "varnishadm start failed"
  CHECK_RESULT $? 0 0 "varnishadm ban.list failed"
  CHECK_RESULT $? 0 0 "varnishadm ban.list failed"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：grep×13, varnishadm×1

#### oe_test_varnish_02

- 描述：varnish common prepare
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "varnishadm backend.list failed"
  CHECK_RESULT $? 0 0 "varnishadm backend.list -g failed"
  CHECK_RESULT $? 0 0 "varnishadm backend.list -p failed"
  CHECK_RESULT $? 0 0 "varnishadm backend.list -a prompt info error"
  CHECK_RESULT $? 0 0 "varnishadm backend.set_health default sick failed"
  CHECK_RESULT $? 0 0 "varnishadm backend.set_health default healthy failed"
  CHECK_RESULT $? 0 0 "varnishadm backend.set_health default auto failed"
  CHECK_RESULT $? 0 0 "varnishadm backend.set_health auto prompt info error"
  CHECK_RESULT $? 0 0 "varnishadm backend.set_health server1 sick prompt info error"
  CHECK_RESULT $? 0 0 "varnishadm backend.set_health default a prompt info error"
```

- 涉及命令：grep×10

#### oe_test_varnish_03

- 描述：varnish common prepare
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "varnishadm panic.clear -z failed"
  CHECK_RESULT $? 0 0 "varnishadm param.show failed"
  CHECK_RESULT $? 0 0 "varnishadm param.show -j failed"
  CHECK_RESULT $? 0 0 "varnishadm param.reset failed"
```

- 涉及命令：grep×3, shuf×1

#### oe_test_varnish_04

- 描述：varnish common prepare
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "varnishadm param.set -j ban_dups off failed"
  CHECK_RESULT $? 0 0 "varnishadm param.set -j ban_dups on failed"
  CHECK_RESULT $? 0 0 "varnishadm param.set -j ban_dups on prompt info error"
  CHECK_RESULT $? 0 0 "varnishadm param.set -j workspace_thread 2k failed"
  CHECK_RESULT $? 0 0 "varnishadm param.set -j workspace_thread 0 promot info error"
  CHECK_RESULT $? 0 0 "varnishadm param.set -j workspace_thread 10m promot info error"
  CHECK_RESULT $? 0 0 "varnishadm param.set -j workspace_thread a promot info error"
  CHECK_RESULT $? 0 0 "varnishadm param.set -j pool_req 10,100,10 failed"
  CHECK_RESULT $? 0 0 "varnishadm param.set -j pool_req 10 100 promot info error"
  CHECK_RESULT $? 0 0 "varnishadm param.set -j pool_req 10 promot info error"
  CHECK_RESULT $? 0 0 "varnishadm param.set -j pool_req promot info error"
```

- 涉及命令：grep×11

#### oe_test_varnish_05

- 描述：varnish common prepare
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "varnishadm param.show failed"
  CHECK_RESULT $? 0 0 "varnishadm param.show -l failed"
  CHECK_RESULT $? 0 0 "varnishadm param.show -j failed"
  CHECK_RESULT $? 0 0 "varnishadm param.show -j changed failed"
  CHECK_RESULT $? 0 0 "varnishadm param.show -l changed failed"
  CHECK_RESULT $? 0 0 "varnishadm param.show changed failed"
  CHECK_RESULT $? 0 0 "varnishadm param.show -l workspace_thread failed"
  CHECK_RESULT $? 0 0 "varnishadm param.show -l vsl_space changed prompt info error"
  CHECK_RESULT $? 0 0 "varnishadm param.show -l aaa prompt info error"
```

- 涉及命令：grep×9

#### oe_test_varnish_06

- 描述：varnish common prepare
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "varnishadm pid ailed"
  CHECK_RESULT $? 0 0 "varnishadm pid -j failed"
  CHECK_RESULT $? 0 0 "pid -a prompt info error"
  CHECK_RESULT $? 0 0 "varnishadm status -j failed"
  CHECK_RESULT $? 0 0 "varnishadm storage.list failed"
  CHECK_RESULT $? 0 0 "varnishadm storage.list -j failed"
  CHECK_RESULT $? 0 0 "storage.list -a prompt info error"
  CHECK_RESULT $? 0 0 "vcl.deps failed"
  CHECK_RESULT $? 0 0 "varnishadm vcl.deps -j failed"
  CHECK_RESULT $? 0 0 "vcl.deps -a prompt info error"
```

- 涉及命令：grep×10
