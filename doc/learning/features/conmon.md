# conmon

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/conmon` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_conmon_01 | Test conmon command | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_conmon_02 | Test conmon command | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_conmon_03 | Test conmon command | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_conmon_04 | Test conmon command | pre_test/run_test/post_test | 8 |  |  |  |

### 断言与命令明细

#### oe_test_conmon_01

- 描述：Test conmon command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check the --version"
  CHECK_RESULT $? 0 0 "Failed to check the -c"
  CHECK_RESULT $? 0 0 "Failed to check the -n"
  CHECK_RESULT $? 0 0 "Failed to check the -i"
  CHECK_RESULT $? 0 0 "Failed to check the -u"
  CHECK_RESULT $? 0 0 "Failed to check the --runtime"
  CHECK_RESULT $? 0 0 "Failed to check the -l"
  CHECK_RESULT $? 0 0 "Failed to check the -p"
```

- 涉及命令：conmon×7

#### oe_test_conmon_02

- 描述：Test conmon command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check the --runtime-opt"
  CHECK_RESULT $? 0 0 "Failed to check the --runtime-arg"
  CHECK_RESULT $? 0 0 "Failed to check the --restore-arg"
  CHECK_RESULT $? 0 0 "Failed to check the --restore"
  CHECK_RESULT $? 0 0 "Failed to check the --attach"
  CHECK_RESULT $? 0 0 "Failed to check the --leave-stdin-open"
  CHECK_RESULT $? 0 0 "Failed to check the --no-new-keyring"
  CHECK_RESULT $? 0 0 "Failed to check the --no-pivot"
  CHECK_RESULT $? 0 0 "Failed to check the --replace-listen-pid"
  CHECK_RESULT $? 0 0 "Failed to check the -b"
```

- 涉及命令：conmon×10, test×1

#### oe_test_conmon_03

- 描述：Test conmon command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check the -P"
  CHECK_RESULT $? 0 0 "Failed to check the -b"
  CHECK_RESULT $? 0 0 "Failed to check the --systemd-cgroup"
  CHECK_RESULT $? 0 0 "Failed to check the -e"
  CHECK_RESULT $? 0 0 "Failed to check the --api-version"
  CHECK_RESULT $? 0 0 "Failed to check the --exec-process-spec"
```

- 涉及命令：conmon×6, test×1

#### oe_test_conmon_04

- 描述：Test conmon command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check the --exit-dir"
  CHECK_RESULT $? 0 0 "Failed to check the --exit-command"
  CHECK_RESULT $? 0 0 "Failed to check the --exit-command-arg"
  CHECK_RESULT $? 0 0 "Failed to check the -T"
  CHECK_RESULT $? 0 0 "Failed to check the --log-size-max"
  CHECK_RESULT $? 0 0 "Failed to check the --socket-dir-path"
  CHECK_RESULT $? 0 0 "Failed to check the --syslog"
  CHECK_RESULT $? 0 0 "Failed to check the --log-level"
```

- 涉及命令：conmon×8
