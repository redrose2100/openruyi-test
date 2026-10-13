# boost

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/boost/` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_boost_01 | Verify boost package and filesystem sublibrary functions | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_boost_02 | Verify boost regex, thread and smart_ptr sublibrary functions | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_boost_03 | Verify boost asio, date_time, string_algo, optional and variant functions | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_boost_01

- 描述：Verify boost package and filesystem sublibrary functions
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "boost package not installed"
  CHECK_RESULT $? 0 0 "boost package verification failed"
  CHECK_RESULT $? 0 0 "Failed to get boost version"
  CHECK_RESULT $? 0 0 "Failed to copy boost test source file"
  CHECK_RESULT $? 0 0 "Failed to compile boost test program"
  CHECK_RESULT $? 0 0 "Boost filesystem exists test failed"
  CHECK_RESULT $? 0 0 "Boost filesystem is_directory test failed"
  CHECK_RESULT $? 0 0 "Boost filesystem temp_directory_path test failed"
  CHECK_RESULT $? 0 0 "Boost filesystem absolute test failed"
  CHECK_RESULT $? 0 0 "Boost filesystem filename test failed"
  CHECK_RESULT $? 0 0 "Boost system error_code test failed"
```

- 涉及命令：rpm×3

#### oe_test_boost_02

- 描述：Verify boost regex, thread and smart_ptr sublibrary functions
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Failed to copy boost test source file"
  CHECK_RESULT $? 0 0 "Failed to compile boost regex test"
  CHECK_RESULT $? 0 0 "Boost regex search test failed"
  CHECK_RESULT $? 0 0 "Boost regex replace test failed"
  CHECK_RESULT $? 0 0 "Boost regex match test failed"
  CHECK_RESULT $? 0 0 "Failed to compile boost thread test"
  CHECK_RESULT $? 0 0 "Boost thread sync test failed"
  CHECK_RESULT $? 0 0 "Boost thread id test failed"
  CHECK_RESULT $? 0 0 "Boost thread sleep test failed"
  CHECK_RESULT $? 0 0 "Failed to compile boost smart_ptr test"
  CHECK_RESULT $? 0 0 "Boost shared_ptr test failed"
  CHECK_RESULT $? 0 0 "Boost unique_ptr test failed"
```

#### oe_test_boost_03

- 描述：Verify boost asio, date_time, string_algo, optional and variant functions
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Failed to copy boost test source file"
  CHECK_RESULT $? 0 0 "Failed to compile boost asio test"
  CHECK_RESULT $? 0 0 "Boost asio timer test failed"
  CHECK_RESULT $? 0 0 "Boost asio socket test failed"
  CHECK_RESULT $? 0 0 "Failed to compile boost date_time test"
  CHECK_RESULT $? 0 0 "Boost date_time date test failed"
  CHECK_RESULT $? 0 0 "Boost date_time time test failed"
  CHECK_RESULT $? 0 0 "Failed to compile boost string_algo test"
  CHECK_RESULT $? 0 0 "Boost string_algo trim test failed"
  CHECK_RESULT $? 0 0 "Boost string_algo split test failed"
  CHECK_RESULT $? 0 0 "Failed to compile boost optional/variant test"
  CHECK_RESULT $? 0 0 "Boost optional test failed"
  ... 共 13 条（其余见源脚本）
```
