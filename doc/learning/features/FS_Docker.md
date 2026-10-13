# FS_Docker

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 系统域（system-test） |
| 套件路径 | `${OET_PATH}/testcases/system-test/fs-test/FS_Docker` |
| 注册用例数 | 10 |
| 环境约束 | add disk = 20 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_docker_check_overlay2fs | check docker overlay2fs | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_docker_commit_save | Commit and save docker | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_docker_compress | Compress and run docker | config_params/pre_test/run_test/post_test | 1 | ✔ |  | 60m |
| oe_test_docker_cp | cp file between localhost and docker | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_docker_info | check docker info | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_docker_mergedir | write file on docker MergedDir | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_docker_mount | check docker mount | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_docker_mount_fs | mount share dir on different fs type(ext3/ext4/xfs) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_docker_write_in_docker | write file on docker | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_docker_write_upperdir | write file on docker UpperDir | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_docker_check_overlay2fs

- 描述：check docker overlay2fs
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "The docker doesn't have /home/docker_dir."
  CHECK_RESULT $? 0 0 "The docker doesn't have LowerDir."
  CHECK_RESULT $? 0 0 "The docker doesn't have UpperDir."
  CHECK_RESULT $? 0 0 "The docker doesn't have WorkDir."
```

- 涉及命令：grep×4, mkdir×1

#### oe_test_docker_commit_save

- 描述：Commit and save docker
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Commit docker snapshot failed."
  CHECK_RESULT $? 0 0 "Save docker snapshot failed."
```

- 涉及命令：mkdir×1

#### oe_test_docker_compress

- 描述：Compress and run docker
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Start docker failed."
```

- 涉及命令：mkdir×1

#### oe_test_docker_cp

- 描述：cp file between localhost and docker
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "CP file from docker to localhost failed."
  CHECK_RESULT $? 0 0 "CP file from localhost to docker failed."
```

- 涉及命令：mkdir×1

#### oe_test_docker_info

- 描述：check docker info
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check images failed."
  CHECK_RESULT $? 0 0 "Check docker info failed."
  CHECK_RESULT "$status" 0 0 "The docker directory lack some things."
```

#### oe_test_docker_mergedir

- 描述：write file on docker MergedDir
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 2 0 "MergedDir exists unexpectly when docker doesn't start."
  CHECK_RESULT $? 0 0 "MergedDir exists unexpectly when docker start."
  CHECK_RESULT $? 0 0 "Write file to merge_dir failed."
  CHECK_RESULT $? 0 0 "Check file in docker failed."
```

- 涉及命令：mkdir×1

#### oe_test_docker_mount

- 描述：check docker mount
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check mount fs failed."
  CHECK_RESULT $? 0 0 "Check mount fs in docker failed."
```

- 涉及命令：mkdir×1

#### oe_test_docker_mount_fs

- 描述：mount share dir on different fs type(ext3/ext4/xfs)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Mount on $i failed."
  CHECK_RESULT $? 0 0 "Write file in docker failed."
```

#### oe_test_docker_write_in_docker

- 描述：write file on docker
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Write file in docker failed."
  CHECK_RESULT $? 0 0 "Check file in upper_dir failed."
```

- 涉及命令：mkdir×1

#### oe_test_docker_write_upperdir

- 描述：write file on docker UpperDir
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Write file to upper_dir failed."
  CHECK_RESULT $? 0 0 "Check file in docker failed."
```

- 涉及命令：mkdir×1
