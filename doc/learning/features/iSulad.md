# iSulad

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/iSulad` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_isulad | Test isulad.service restart | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_iSulad_resource_mapping | resource mapping | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_iSulad_resource_restriction_cgroup | Resource Restriction - Configure the Cgroup path | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_iSulad_container | Create a startup container | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_iSulad_container01 | Restart and close container | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_iSulad_container02 | Copying files between containers and hosts | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_iSulad_container03 | Pause container | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_iSulad_container04 | Log and Process Query | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_iSulad_container05 | Execute Container Command | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_isulad

- 描述：Test isulad.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of isulad.service"
  CHECK_RESULT $? 0 0 "isulad.service reload failed"
  CHECK_RESULT $? 0 0 "isulad.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_iSulad_resource_mapping

- 描述：resource mapping
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "create container failed"
  CHECK_RESULT $? 0 0 "resource mapping failed"
  CHECK_RESULT $? 0 0 "create container failed"
  CHECK_RESULT $? 0 0 "resource mapping failed"
  CHECK_RESULT $? 0 0 "create container failed"
  CHECK_RESULT $? 0 0 "resource mapping failed"
  CHECK_RESULT $? 0 0 "resource mapping failed"
  CHECK_RESULT $? 0 0 "resource mapping failed"
```

#### oe_test_iSulad_resource_restriction_cgroup

- 描述：Resource Restriction - Configure the Cgroup path
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "configure the Cgroup path failed"
  CHECK_RESULT $? 0 0 "configure the Cgroup path failed"
```

- 涉及命令：sed×1

#### oe_test_iSulad_container

- 描述：Create a startup container
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Mirror pull failed"
  CHECK_RESULT $? 0 0 "Container creation failed"
  CHECK_RESULT $? 0 0 "Container startup failed"
```

- 涉及命令：sed×1

#### oe_test_iSulad_container01

- 描述：Restart and close container
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Mirror pull failed"
  CHECK_RESULT $? 0 0 "Container creation failed"
  CHECK_RESULT $? 0 0 "Container startup failed"
  CHECK_RESULT $? 0 0 "Container startup failed"
  CHECK_RESULT $? 0 0 "Container closing failed"
  CHECK_RESULT $? 0 0 "Container closing failed"
```

- 涉及命令：sed×1

#### oe_test_iSulad_container02

- 描述：Copying files between containers and hosts
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "File copy failed"
  CHECK_RESULT $? 0 0 "There is no such file or directory"
  CHECK_RESULT $? 0 0 "File copy failed"
  CHECK_RESULT $? 0 0 "There is no such file"
```

- 涉及命令：test×2, sed×1

#### oe_test_iSulad_container03

- 描述：Pause container
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Container startup failed"
  CHECK_RESULT $? 0 0 "Container paused failed"
  CHECK_RESULT $? 0 0 "Container startup failed"
  CHECK_RESULT $? 0 0 "Query failed "
```

- 涉及命令：sed×1

#### oe_test_iSulad_container04

- 描述：Log and Process Query
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Container startup failed"
  CHECK_RESULT $? 0 0 "Failed to query logs"
  CHECK_RESULT $? 0 0 "Process does not exist"
```

- 涉及命令：sed×1

#### oe_test_iSulad_container05

- 描述：Execute Container Command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "There is no such file or directory"
  CHECK_RESULT $? 0 0 "There is no such file or directory"
  CHECK_RESULT $? 0 0 "Failed to exit container"
```

- 涉及命令：sed×1
