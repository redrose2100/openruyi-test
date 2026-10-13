# cvs

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/cvs` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_socket_cvs | Test cvs.socket restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_target_cvs | Test cvs.target restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_cvs_cvs_01 | Test cvs | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_cvs_cvs_02 | Test cvs | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_cvs_cvs_03 | Test cvs | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_cvs_cvs_04 | Test cvs | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_cvs_cvs_05 | Test cvs | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_cvs_cvs_06 | Test cvs | pre_test/run_test/post_test | 6 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_socket_cvs

- 描述：Test cvs.socket restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_target_cvs

- 描述：Test cvs.target restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_cvs_cvs_01

- 描述：Test cvs
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "test cvs -v failed"
  CHECK_RESULT $? 0 0 "test cvs --version failed"
  CHECK_RESULT $? 0 0 "test cvs --help"
  CHECK_RESULT $? 0 0 "test cvs --help-options failed"
  CHECK_RESULT $? 0 0 "test cvs --help-commands failed"
```

- 涉及命令：cvs×1

#### oe_test_cvs_cvs_02

- 描述：Test cvs
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test cvs -d failed"
  CHECK_RESULT $? 0 0 "test cvs init failed"
  CHECK_RESULT $? 0 0 "test cvs import failed"
  CHECK_RESULT $? 0 0 "test cvs checkout failed"
  CHECK_RESULT $? 0 0 "test cvs add failed"
  CHECK_RESULT $? 0 0 "test cvs -4 failed"
  CHECK_RESULT $? 0 0 "test cvs commit failed"
  CHECK_RESULT $? 0 0 "test cvs annotate failed"
  CHECK_RESULT $? 0 0 "test cvs log failed"
  CHECK_RESULT $? 0 0 "test cvs diff failed"
```

- 涉及命令：cvs×3, chown×2, tar×1, userdel×1

#### oe_test_cvs_cvs_03

- 描述：Test cvs
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "test cvs tag failed"
  CHECK_RESULT $? 0 0 "test cvs export failed"
  CHECK_RESULT $? 0 0 "test cvs watch failed"
  CHECK_RESULT $? 0 0 "test cvs edit failed"
  CHECK_RESULT $? 0 0 "test cvs watchers failed"
  CHECK_RESULT $? 0 0 "test cvs editors failed"
  CHECK_RESULT $? 0 0 "test cvs unedit failed"
  CHECK_RESULT $? 0 0 "test cvs history failed"
```

- 涉及命令：tar×1, userdel×1

#### oe_test_cvs_cvs_04

- 描述：Test cvs
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test cvs rannotate failed"
  CHECK_RESULT $? 0 0 "test cvs -6 failed"
  CHECK_RESULT $? 0 0 "test cvs -q failed"
  CHECK_RESULT $? 0 0 "test cvs -r failed"
  CHECK_RESULT $? 0 0 "test cvs -w failed"
  CHECK_RESULT $? 0 0 "test cvs -n failed"
  CHECK_RESULT $? 0 0 "test cvs  failed-T"
  CHECK_RESULT $? 0 0 "test cvs -t failed"
  CHECK_RESULT $? 0 0 "test cvs rdiff failed"
  CHECK_RESULT $? 0 0 "test cvs rlog failed"
```

- 涉及命令：tar×1, userdel×1

#### oe_test_cvs_cvs_05

- 描述：Test cvs
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "test cvs rtag failed"
  CHECK_RESULT $? 0 0 "test cvs -f failed"
  CHECK_RESULT $? 0 0 "test cvs -x failed"
  CHECK_RESULT $? 0 0 "test cvs -a failed"
  CHECK_RESULT $? 0 0 "test cvs remove failed"
  CHECK_RESULT $? 0 0 "test cvs update failed"
  CHECK_RESULT $? 0 0 "test cvs status failed"
```

- 涉及命令：tar×1, userdel×1

#### oe_test_cvs_cvs_06

- 描述：Test cvs
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "test cvs release failed"
  CHECK_RESULT $? 0 0 "test cvs login failed"
  CHECK_RESULT $? 0 0 "test cvs -z failed"
  CHECK_RESULT $? 0 0 "test cvs logout failed"
  CHECK_RESULT $? 0 0 "test cvs pserver failed"
  CHECK_RESULT $? 0 0 "test cvs server failed"
```

- 涉及命令：tar×1, userdel×1
