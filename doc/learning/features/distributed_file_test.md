# distributed_file_test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/distributed_file_test` |
| 注册用例数 | 24 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_mkdir_ls_001 | check mkdir and ls directory in device_view/local | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_mkdir_ls_002 | check mkdir and ls directory in device_view/remote | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_mkdir_ls_003 | check mkdir and ls directory in local merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_mkdir_ls_004 | check mkdir and ls directory in remote merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_touch_ls_001 | check touch and ls file in device_view/local | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_touch_ls_002 | check touch and ls file in device_view/remote | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_touch_ls_003 | check touch and ls file in local merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_touch_ls_004 | check touch and ls file in remote merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rm_dir_001 | check rm directory in device_view/local | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rm_dir_002 | check rm directory in device_view/remote | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rm_dir_003 | check rm directory in local merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rm_dir_004 | check rm directory in remote merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rm_file_001 | check rm file in device_view/local | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rm_file_002 | check rm file in device_view/remote | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rm_file_003 | check rm file in local merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rm_file_004 | check rm file in remote merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_modify_file_001 | check modify file in device_view/local | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_modify_file_002 | check modify file in device_view/remote | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_modify_file_003 | check modify file in local merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_modify_file_004 | check modify file in remote merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rename_file_001 | check rename directory in device_view/local | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rename_file_002 | check rename directory in device_view/remote | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rename_file_003 | check rename directory in local merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |
| oe_test_rename_file_004 | check rename directory in remote merge_view | pre_test/run_test/post_test | 4 |  | ✔ |  |

### 断言与命令明细

#### oe_test_mkdir_ls_001

- 描述：check mkdir and ls directory in device_view/local
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_1 && ls -l | grep -c "^d")" 10000 0 "mkdir_ls_001_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local/testfile_1w_1 && ls -l | grep -c "^d")" 10000 0 "mkdir_ls_001_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 10000 0 "mkdir_ls_001_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 10000 0 "mkdir_ls_001_004 fail"
```

#### oe_test_mkdir_ls_002

- 描述：check mkdir and ls directory in device_view/remote
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cat /test_01.txt)" 10000 0 "mkdir_ls_002_001 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 10000 0 "mkdir_ls_002_002 fail"
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_2 && ls -l | grep -c "^d")" 10000 0 "mkdir_ls_002_003 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_2 && ls -l | grep -c "^d")" 10000 0 "mkdir_ls_002_004 fail"
```

#### oe_test_mkdir_ls_003

- 描述：check mkdir and ls directory in local merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_3 && ls -l | grep -c "^d")" 10000 0 "mkdir_ls_003_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local/testfile_1w_3 && ls -l | grep -c "^d")" 10000 0 "mkdir_ls_003_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 10000 0 "mkdir_ls_003_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 10000 0 "mkdir_ls_003_004 fail"
```

#### oe_test_mkdir_ls_004

- 描述：check mkdir and ls directory in remote merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_4 && ls -l | grep -c "^d")" 10000 0 "mkdir_ls_004_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_4 && ls -l | grep -c "^d")" 10000 0 "mkdir_ls_004_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 10000 0 "mkdir_ls_004_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 10000 0 "mkdir_ls_004_004 fail"
```

#### oe_test_touch_ls_001

- 描述：check touch and ls file in device_view/local
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_1 && ls -l | grep -c "^-")" 10000 0 "touch_ls_001_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local/testfile_1w_1 && ls -l | grep -c "^-")" 10000 0 "touch_ls_001_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 10000 0 "touch_ls_001_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 10000 0 "touch_ls_001_004 fail"
```

#### oe_test_touch_ls_002

- 描述：check touch and ls file in device_view/remote
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cat /test_01.txt)" 10000 0 "touch_ls_002_001 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 10000 0 "touch_ls_002_002 fail"
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_2 && ls -l | grep -c "^-")" 10000 0 "touch_ls_002_003 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_2 && ls -l | grep -c "^-")" 10000 0 "touch_ls_002_004 fail"
```

#### oe_test_touch_ls_003

- 描述：check touch and ls file in local merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_3 && ls -l | grep -c "^-")" 10000 0 "touch_ls_003_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local/testfile_1w_3 && ls -l | grep -c "^-")" 10000 0 "touch_ls_003_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 10000 0 "touch_ls_003_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 10000 0 "touch_ls_003_004 fail"
```

#### oe_test_touch_ls_004

- 描述：check touch and ls file in remote merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_4 && ls -l | grep -c "^-")" 10000 0 "touch_ls_004_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_4 && ls -l | grep -c "^-")" 10000 0 "touch_ls_004_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 10000 0 "touch_ls_004_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 10000 0 "touch_ls_004_004 fail"
```

#### oe_test_rm_dir_001

- 描述：check rm directory in device_view/local
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_1 && ls -l | grep -c "^d")" 0 0 "rm_dir_001_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local/testfile_1w_1 && ls -l | grep -c "^d")" 0 0 "rm_dir_001_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 0 0 "rm_dir_001_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 0 0 "rm_dir_001_004 fail"
```

#### oe_test_rm_dir_002

- 描述：check rm directory in device_view/remote
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cat /test_01.txt)" 0 0 "rm_dir_002_001 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 0 0 "rm_dir_002_002 fail"
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_2 && ls -l | grep -c "^d")" 0 0 "rm_dir_002_003 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_2 && ls -l | grep -c "^d")" 0 0 "rm_dir_002_004 fail"
```

#### oe_test_rm_dir_003

- 描述：check rm directory in local merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_3 && ls -l | grep -c "^d")" 0 0 "rm_dir_003_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local/testfile_1w_3 && ls -l | grep -c "^d")" 0 0 "rm_dir_003_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 0 0 "rm_dir_003_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 0 0 "rm_dir_003_004 fail"
```

#### oe_test_rm_dir_004

- 描述：check rm directory in remote merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_4 && ls -l | grep -c "^d")" 0 0 "rm_dir_004_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_4 && ls -l | grep -c "^d")" 0 0 "rm_dir_004_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 0 0 "rm_dir_004_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 0 0 "rm_dir_004_004 fail"
```

#### oe_test_rm_file_001

- 描述：check rm file in device_view/local
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_1 && ls -l | grep -c "^-")" 0 0 "rm_file_001_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local/testfile_1w_1 && ls -l | grep -c "^-")" 0 0 "rm_file_001_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 0 0 "rm_file_001_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 0 0 "rm_file_001_004 fail"
```

#### oe_test_rm_file_002

- 描述：check rm file in device_view/remote
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cat /test_01.txt)" 0 0 "rm_file_002_001 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 0 0 "rm_file_002_002 fail"
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_2 && ls -l | grep -c "^-")" 0 0 "rm_file_002_003 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_2 && ls -l | grep -c "^-")" 0 0 "rm_file_002_004 fail"
```

#### oe_test_rm_file_003

- 描述：check rm file in local merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_3 && ls -l | grep -c "^-")" 0 0 "rm_file_003_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local/testfile_1w_3 && ls -l | grep -c "^-")" 0 0 "rm_file_003_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 0 0 "rm_file_003_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 0 0 "rm_file_003_004 fail"
```

#### oe_test_rm_file_004

- 描述：check rm file in remote merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_4 && ls -l | grep -c "^-")" 0 0 "rm_file_004_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_4 && ls -l | grep -c "^-")" 0 0 "rm_file_004_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 0 0 "rm_file_004_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 0 0 "rm_file_004_004 fail"
```

#### oe_test_modify_file_001

- 描述：check modify file in device_view/local
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_1 && cat ./* | wc -c)" 60000 0 "modify_file_001_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local/testfile_1w_1 && cat ./* | wc -c)" 60000 0 "modify_file_001_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 60000 0 "modify_file_001_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 60000 0 "modify_file_001_004 fail"
```

#### oe_test_modify_file_002

- 描述：check modify file in device_view/remote
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cat /test_01.txt)" 60000 0 "modify_file_002_001 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 60000 0 "modify_file_002_002 fail"
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_2 && cat ./* | wc -c)" 60000 0 "modify_file_002_003 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_2 && cat ./* | wc -c)" 60000 0 "modify_file_002_004 fail"
```

#### oe_test_modify_file_003

- 描述：check modify file in local merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_3 && cat ./* | wc -c)" 60000 0 "modify_file_003_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local/testfile_1w_3 && cat ./* | wc -c)" 60000 0 "modify_file_003_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 60000 0 "modify_file_003_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 60000 0 "modify_file_003_004 fail"
```

#### oe_test_modify_file_004

- 描述：check modify file in remote merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view/testfile_1w_4 && cat ./* | wc -c)" 60000 0 "modify_file_004_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}"/testfile_1w_4 && cat ./* | wc -c)" 60000 0 "modify_file_004_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 60000 0 "modify_004_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 60000 0 "modify_file_004_004 fail"
```

#### oe_test_rename_file_001

- 描述：check rename directory in device_view/local
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view && ls | grep -c testfile_1w_001)" 1 0 "rename_file_001_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local && ls | grep -c testfile_1w_001)" 1 0 "rename_file_001_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 1 0 "rename_file_001_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 1 0 "rename_file_001_004 fail"
```

#### oe_test_rename_file_002

- 描述：check rename directory in device_view/remote
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cat /test_01.txt)" 1 0 "rename_file_002_001 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 1 0 "rename_file_002_002 fail"
  CHECK_RESULT "$(cd "${com_path}"/merge_view && ls | grep -c testfile_1w_002)" 1 0 "rename_file_002_003 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}" && ls | grep -c testfile_1w_002)" 1 0 "rename_file_002_004 fail"
```

#### oe_test_rename_file_003

- 描述：check rename directory in local merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view && ls | grep -c testfile_1w_003)" 1 0 "rename_file_003_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/local && ls | grep -c testfile_1w_003)" 1 0 "rename_file_003_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 1 0 "rename_file_003_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 1 0 "rename_file_003_004 fail"
```

#### oe_test_rename_file_004

- 描述：check rename directory in remote merge_view
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT "$(cd "${com_path}"/merge_view && ls | grep -c testfile_1w_004)" 1 0 "rename_file_004_001 fail"
  CHECK_RESULT "$(cd "${com_path}"/device_view/"${remoteIDa}" && ls | grep -c testfile_1w_004)" 1 0 "rename_file_004_002 fail"
  CHECK_RESULT "$(cat /test_01.txt)" 1 0 "rename_file_004_003 fail"
  CHECK_RESULT "$(cat /test_02.txt)" 1 0 "rename_file_004_004 fail"
```
