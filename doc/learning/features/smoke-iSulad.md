# smoke-iSulad

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-iSulad` |
| 注册用例数 | 12 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_iSula_query_state_001 | Querying resources used by containers | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_iSula_attach_rename_001 | attach and rename containers | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_iSula_export_001 | Export container | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_iSula_cp_001 | Copy between container and host | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_iSula_create_start_001 | create and start container | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_iSula_restart_stop_001 | restart and stop container | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_iSula_search_info_001 | search container information | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_iSula_exec_cmd_001 | Execute command in container | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_iSula_install_deploy_001 | install and deploy iSula container | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_iSula_mkdir100_001 | Copy between container and host | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_iSula_pause_resume_001 | Pause and resume container / query isula information | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_isula-build_build_image | isula-build test common | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_iSula_query_state_001

- 描述：Querying resources used by containers
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_iSula_attach_rename_001

- 描述：attach and rename containers
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT "$(grep -c "exit" testlog)" 1
  CHECK_RESULT "$(grep -c "exit" testlog)" 2
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：expect×1, grep×1

#### oe_test_iSula_export_001

- 描述：Export container
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_iSula_cp_001

- 描述：Copy between container and host
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2

#### oe_test_iSula_create_start_001

- 描述：create and start container
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_iSula_restart_stop_001

- 描述：restart and stop container
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_iSula_search_info_001

- 描述：search container information
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_iSula_exec_cmd_001

- 描述：Execute command in container
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×1

#### oe_test_iSula_install_deploy_001

- 描述：install and deploy iSula container
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×2

#### oe_test_iSula_mkdir100_001

- 描述：Copy between container and host
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_iSula_pause_resume_001

- 描述：Pause and resume container / query isula information
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_isula-build_build_image

- 描述：isula-build test common
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "isula-build build failed"
  CHECK_RESULT $? 0 0 "isula run failed"
  CHECK_RESULT $? 0 0 "isula-build rm images failed"
```

- 涉及命令：wget×1
