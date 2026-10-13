# smoke-docker

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-docker` |
| 注册用例数 | 15 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_docker_cp_001 | data copy between the container and the host | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_docker_rename_pause_resume_001 | Rename container/pause and resume container process | config_params/pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_docker_search_info_001 | Container information query | config_params/pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_docker_image_history_001 | Display the change history of an image | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_docker_commit_export_import_001 | Commit / export / import application of container | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_docker_create_002 | Creating an interactive container | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_docker_attach_001 | Access container | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_docker_start_stop_delete_001 | Start / stop / delete container | config_params/pre_test/run_test/post_test | 15 |  |  |  |
| oe_test_docker_tag_001 | Tag an image into a library | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_docker_exec_cmd_001 | Execute new commands in the container | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_docker_create_003 | Background run container (run in background after creation) | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_docker_create_001 | Create container to run simple application | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_docker_save_load_001 | Save an image to a tar package / tar package saved by docker reload an image | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_docker_custom-image | add case docker_custom-image | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_runc | runc-package test | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_docker_cp_001

- 描述：data copy between the container and the host
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×3

#### oe_test_docker_rename_pause_resume_001

- 描述：Rename container/pause and resume container process
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_docker_search_info_001

- 描述：Container information query
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_docker_image_history_001

- 描述：Display the change history of an image
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_docker_commit_export_import_001

- 描述：Commit / export / import application of container
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_docker_create_002

- 描述：Creating an interactive container
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×2, expect×1

#### oe_test_docker_attach_001

- 描述：Access container
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：expect×1, grep×1

#### oe_test_docker_start_stop_delete_001

- 描述：Start / stop / delete container
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（15 条）：

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
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 15 条（其余见源脚本）
```

#### oe_test_docker_tag_001

- 描述：Tag an image into a library
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_docker_exec_cmd_001

- 描述：Execute new commands in the container
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×2

#### oe_test_docker_create_003

- 描述：Background run container (run in background after creation)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_docker_create_001

- 描述：Create container to run simple application
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_docker_save_load_001

- 描述：Save an image to a tar package / tar package saved by docker reload an image
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1

#### oe_test_docker_custom-image

- 描述：add case docker_custom-image
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create a mirror from Dockerfile"
  CHECK_RESULT $? 0 0 "The image Custom failed"
  CHECK_RESULT $? 0 0 "The container failed to create a file"
```

#### oe_test_runc

- 描述：runc-package test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Unable to generate config.json file"
  CHECK_RESULT $? 0 0 "Container creation failure"
```

- 涉及命令：sed×2, mkdir×1
