# obs-server

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/obs-server` |
| 注册用例数 | 30 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_obs-server | service related | config_params/pre_test/run_test/post_test | 38 | ✔ |  | 90m |
| oe_test_service_obsstoragesetup | Test obsstoragesetup.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_target_obs-api-support | Test obs-api-support.target restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_obsdeltastore | Test obsdeltastore.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_obsservice | Test obsservice.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_obsapisetup | Test obsapisetup.service restart | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_service_obssigner | Test obssigner.service restart | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_service_obs-clockwork | Test obs-clockwork.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_obsdodup | Test obsdodup.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_obs-sphinx | Test obs-sphinx.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_obs-delayedjob-queue-consistency_check | Test obs-delayedjob-queue-consistency_check.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_obsgetbinariesproxy | Test obsgetbinariesproxy.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_obs-delayedjob-queue-issuetracking | Test obs-delayedjob-queue-issuetracking.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_obs-delayedjob-queue-mailers | Test obs-delayedjob-queue-mailers.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_obs-delayedjob-queue-project_log_rotate | Test obs-delayedjob-queue-project_log_rotate.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_obs-delayedjob-queue-releasetracking | Test obs-delayedjob-queue-releasetracking.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_obs-delayedjob-queue-staging | Test obs-delayedjob-queue-staging.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_obsservicedispatch | Test obsservicedispatch.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_obsscheduler | Test obsscheduler.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_obsrepserver | Test obsrepserver.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_obsworker | Test obsworker.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_obswarden | Test obswarden.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_obsnotifyforward | Test obsnotifyforward.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_obspublisher | Test obspublisher.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_obssrcserver | Test obssrcserver.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_obsdispatcher | Test obsdispatcher.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_obs-delayedjob-queue-default | Test obs-delayedjob-queue-default.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_obs-delayedjob-queue-scm | Test obs-delayedjob-queue-scm.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_obssourcepublish | Test obssourcepublish.service restart | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_service_obsredis | Test obsredis.service restart | pre_test/run_test/post_test | 0 |  |  |  |

### 断言与命令明细

#### oe_test_obs-server

- 描述：service related
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（38 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 38 条（其余见源脚本）
```

- 涉及命令：sed×6, kill×1

#### oe_test_service_obsstoragesetup

- 描述：Test obsstoragesetup.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_target_obs-api-support

- 描述：Test obs-api-support.target restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obsdeltastore

- 描述：Test obsdeltastore.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obsdeltastore.service  reload failed"
  CHECK_RESULT $? 0 0 "obsdeltastore.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obsservice

- 描述：Test obsservice.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obsservice.service  reload failed"
  CHECK_RESULT $? 0 0 "obsservice.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obsapisetup

- 描述：Test obsapisetup.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of obsapisetup.service"
```

#### oe_test_service_obssigner

- 描述：Test obssigner.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obssigner.service  reload failed"
  CHECK_RESULT $? 0 0 "obssigner.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obs-clockwork

- 描述：Test obs-clockwork.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obsdodup

- 描述：Test obsdodup.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obsdodup.service  reload failed"
  CHECK_RESULT $? 0 0 "obsdodup.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obs-sphinx

- 描述：Test obs-sphinx.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obs-delayedjob-queue-consistency_check

- 描述：Test obs-delayedjob-queue-consistency_check.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obsgetbinariesproxy

- 描述：Test obsgetbinariesproxy.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obsgetbinariesproxy.service  reload failed"
  CHECK_RESULT $? 0 0 "obsgetbinariesproxy.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obs-delayedjob-queue-issuetracking

- 描述：Test obs-delayedjob-queue-issuetracking.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obs-delayedjob-queue-mailers

- 描述：Test obs-delayedjob-queue-mailers.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obs-delayedjob-queue-project_log_rotate

- 描述：Test obs-delayedjob-queue-project_log_rotate.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obs-delayedjob-queue-releasetracking

- 描述：Test obs-delayedjob-queue-releasetracking.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obs-delayedjob-queue-staging

- 描述：Test obs-delayedjob-queue-staging.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obsservicedispatch

- 描述：Test obsservicedispatch.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obsservicedispatch.service  reload failed"
  CHECK_RESULT $? 0 0 "obsservicedispatch.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obsscheduler

- 描述：Test obsscheduler.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obsrepserver

- 描述：Test obsrepserver.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obsrepserver.service  reload failed"
  CHECK_RESULT $? 0 0 "obsrepserver.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obsworker

- 描述：Test obsworker.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obswarden

- 描述：Test obswarden.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obswarden.service  reload failed"
  CHECK_RESULT $? 0 0 "obswarden.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obsnotifyforward

- 描述：Test obsnotifyforward.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obsnotifyforward.service  reload failed"
  CHECK_RESULT $? 0 0 "obsnotifyforward.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obspublisher

- 描述：Test obspublisher.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obspublisher.service  reload failed"
  CHECK_RESULT $? 0 0 "obspublisher.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obssrcserver

- 描述：Test obssrcserver.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obssrcserver.service  reload failed"
  CHECK_RESULT $? 0 0 "obssrcserver.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obsdispatcher

- 描述：Test obsdispatcher.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obsdispatcher.service  reload failed"
  CHECK_RESULT $? 0 0 "obsdispatcher.service  reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obs-delayedjob-queue-default

- 描述：Test obs-delayedjob-queue-default.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obs-delayedjob-queue-scm

- 描述：Test obs-delayedjob-queue-scm.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_obssourcepublish

- 描述：Test obssourcepublish.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "obssourcepublish.service reload failed"
  CHECK_RESULT $? 0 0 "obssourcepublish.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_service_obsredis

- 描述：Test obsredis.service restart
- 函数：`pre_test, run_test, post_test`