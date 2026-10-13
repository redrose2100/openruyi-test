# embedded_application_develop_tests

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/application_develop_tests` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_hello_world_test | test build bin | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_kernel_hello_world_test | test build ko | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_cpp_hello_world_test | test build bin | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_hello_world_test

- 描述：test build bin
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "no hello world bin file build fail"
  CHECK_RESULT $? 0 0 "hello world chmod fail"
  CHECK_RESULT $? 0 0 "hello world out put fail"
```

- 涉及命令：test×1

#### oe_test_kernel_hello_world_test

- 描述：test build ko
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "no kernel hello world ko file build fail"
  CHECK_RESULT $? 0 0 "kernel hello world ko chmod fail"
  CHECK_RESULT $? 0 0 "insdmod kernel hello world fail"
  CHECK_RESULT $? 0 0 "find kernel hello world fail"
  CHECK_RESULT $? 0 0 "check kernel hello world install message fail"
  CHECK_RESULT $? 0 0 "rmmod kernel hello world fail"
  CHECK_RESULT $? 1 0 "find remod kernel hello world"
  CHECK_RESULT $? 0 0 "check kernel hello world remove message fail"
```

- 涉及命令：test×1

#### oe_test_cpp_hello_world_test

- 描述：test build bin
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "no hello world cpp bin file build fail"
  CHECK_RESULT $? 0 0 "hello world cpp chmod fail"
  CHECK_RESULT $? 0 0 "hello world cpp out put fail"
```

- 涉及命令：test×1
