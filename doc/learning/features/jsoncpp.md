# jsoncpp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/jsoncpp` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_jsoncpp_01 | Test yasm function | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_jsoncpp_02 | Test jsoncpp serialize and deserialize function | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_jsoncpp_03 | Test jsoncpp array operation function | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_jsoncpp_01

- 描述：Test yasm function
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Create jsoncpp_test.cpp file fail"
  CHECK_RESULT $? 0 0 "Execution fail"
  CHECK_RESULT $? 0 0 "Execution fail"
```

- 涉及命令：test×2

#### oe_test_jsoncpp_02

- 描述：Test jsoncpp serialize and deserialize function
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Create jsoncpp_test.cpp file fail"
  CHECK_RESULT $? 0 0 "Compile jsoncpp_test fail"
  CHECK_RESULT $? 0 0 "Execution jsoncpp_test fail"
```

- 涉及命令：grep×1

#### oe_test_jsoncpp_03

- 描述：Test jsoncpp array operation function
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Create jsoncpp_test.cpp failed"
  CHECK_RESULT $? 0 0 "Compile jsoncpp_test failed"
  CHECK_RESULT $? 0 0 "Run jsoncpp_test failed"
```
