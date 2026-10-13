# git-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/git-tools` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_git_tools_1 | Test "git-tools" command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_git_tools_2 | Test "git-tools" command | pre_test/run_test/post_test | 2 | ✔ |  | 160m |
| oe_test_git_tools_3 | Test "git-tools" command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_git_tools_4 | Test "git-tools" command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_git_tools_5 | Test "git-tools" command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_git_tools_6 | Test "git-tools" command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_git_tools_1

- 描述：Test "git-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: git-branches-rename -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-branches-rename -v No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-branches-rename -n No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-branches-rename No Pass"
```

- 涉及命令：git-branches-rename×3

#### oe_test_git_tools_2

- 描述：Test "git-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: git-clone-subset -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-clone-subset No Pass"
```

- 涉及命令：git-clone-subset×1

#### oe_test_git_tools_3

- 描述：Test "git-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: git-find-uncommitted-repos -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-find-uncommitted-repos No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-find-uncommitted-repos -u No Pass"
```

- 涉及命令：git-find-uncommitted-repos×2

#### oe_test_git_tools_4

- 描述：Test "git-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: git-rebase-theirs -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-rebase-theirs No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-rebase-theirs -v No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-rebase-theirs --in-place No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-rebase-theirs --no-backup No Pass"
```

- 涉及命令：git-rebase-theirs×2

#### oe_test_git_tools_5

- 描述：Test "git-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -q No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -v No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -f No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime --first-parent No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -s No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -D No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -t No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime -c No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-restore-mtime --work-tree No Pass"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：git-restore-mtime×9

#### oe_test_git_tools_6

- 描述：Test "git-tools" command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: git-strip-merge -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-strip-merge master No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-strip-merge master -v No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-strip-merge -M No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: git-strip-merge -m No Pass"
```

- 涉及命令：git-strip-merge×4
