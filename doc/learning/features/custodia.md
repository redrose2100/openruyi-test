# custodia

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/custodia` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_custodia | Test "custodia" command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_custodia-cli_01 | Test "custodia" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_custodia-cli_02 | Test "custodia" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_custodia-cli_03 | Test "custodia" command | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_custodia

- 描述：Test "custodia" command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check custodia -h failed"
  CHECK_RESULT $? 0 0 "Check custodia --help failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check custodia --debug failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check custodia --instance INSTANCE failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check custodia configfile failed"
```

- 涉及命令：kill×3, custodia×1

#### oe_test_custodia-cli_01

- 描述：Test "custodia" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check custodia-cli -h failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli --help failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli mkdir failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli ls failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli set failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli get failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli del failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli rmdir failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli plugins failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli mkdir -h failed"
```

- 涉及命令：custodia-cli×1, kill×1

#### oe_test_custodia-cli_02

- 描述：Test "custodia" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check custodia-cli mkdir --help failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli rmdir -h failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli rmdir --help failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli ls -h failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli ls --help failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli get -h failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli get --help failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli set -h failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli set --help failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli del -h failed"
```

#### oe_test_custodia-cli_03

- 描述：Test "custodia" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check custodia-cli del --help failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli plugins -h failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli plugins --help failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli --server failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli --instance failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli --uds-urlpath failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli --verbose failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli --debug failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli --timeout failed"
  CHECK_RESULT $? 0 0 "Check custodia-cli --cafile failed"
```

- 涉及命令：kill×2
