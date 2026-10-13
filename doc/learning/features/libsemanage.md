# libsemanage

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libsemanage` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libsemanage_install | libsemanage install verification and package check | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_libsemanage_cli | libsemanage semanage command line test | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_libsemanage_api | libsemanage API test (C program) | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_libsemanage_python | libsemanage Python bindings test | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libsemanage_install

- 描述：libsemanage install verification and package check
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "libsemanage package not installed"
  CHECK_RESULT $? 0 0 "libsemanage-devel package not installed"
  CHECK_RESULT $? 0 0 "libsemanage library not found"
  CHECK_RESULT $? 0 0 "semanage command not found"
  CHECK_RESULT $? 0 0 "semanage.conf not found"
  CHECK_RESULT $? 0 0 "libsemanage.pc not found"
```

- 涉及命令：rpm×2

#### oe_test_libsemanage_cli

- 描述：libsemanage semanage command line test
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "semanage --help failed"
  CHECK_RESULT $? 0 0 "semanage boolean -l failed"
  CHECK_RESULT $? 0 0 "semanage fcontext -l failed"
  CHECK_RESULT $? 0 0 "semanage user -l failed"
  CHECK_RESULT $? 0 0 "semanage port -l failed"
  CHECK_RESULT $? 0 0 "semanage login -l failed"
  CHECK_RESULT $? 0 0 "semanage interface -l failed"
  CHECK_RESULT $? 0 0 "semanage permissive -l failed"
```

#### oe_test_libsemanage_api

- 描述：libsemanage API test (C program)
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile test program"
  CHECK_RESULT $? 0 0 "libsemanage API test failed"
```

#### oe_test_libsemanage_python

- 描述：libsemanage Python bindings test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "python3-libsemanage package not installed"
  CHECK_RESULT $? 0 0 "Failed to import semanage module"
  CHECK_RESULT $? 0 0 "Failed to get semanage module info"
  CHECK_RESULT $? 0 0 "Failed to create semanage handle"
```

- 涉及命令：python3×3, rpm×1
