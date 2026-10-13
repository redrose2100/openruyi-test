# gpgme

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gpgme` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gpgme_install | gpgme install verification and package check | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_gpgme_cli | gpgme command line tool test | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_gpgme_api | gpgme C API test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_gpgme_python | gpgme Python bindings test | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gpgme_install

- 描述：gpgme install verification and package check
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "gpgme package not installed"
  CHECK_RESULT $? 0 0 "gpgme-devel package not installed"
  CHECK_RESULT $? 0 0 "gpgme library not found"
  CHECK_RESULT $? 0 0 "gpgme-tool command not found"
  CHECK_RESULT $? 0 0 "gpgme.pc or gmp.pc not found"
```

- 涉及命令：rpm×2, test×1

#### oe_test_gpgme_cli

- 描述：gpgme command line tool test
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "gpgme-json --help failed"
  CHECK_RESULT $? 0 0 "gpgme-json --lib-version failed"
  CHECK_RESULT $? 0 0 "gpgme-tool --help failed"
  CHECK_RESULT $? 0 0 "gpgme-tool --lib-version failed"
  CHECK_RESULT $? 0 0 "gpgme-config --version failed"
  CHECK_RESULT $? 0 0 "gpgme-config --version failed"
  CHECK_RESULT $? 0 0 "gpgme-config --host failed"
  CHECK_RESULT $? 0 0 "gpgme-config --prefix failed"
  CHECK_RESULT $? 0 0 "gpgme-config --exec-prefix failed"
  CHECK_RESULT $? 0 0 "gpgme-config --libs failed"
  CHECK_RESULT $? 0 0 "gpgme-config --cflags failed"
  CHECK_RESULT $? 0 0 "gpgme-config --print-lang failed"
  ... 共 13 条（其余见源脚本）
```

#### oe_test_gpgme_api

- 描述：gpgme C API test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile test program"
  CHECK_RESULT $? 0 0 "gpgme C API test failed"
```

#### oe_test_gpgme_python

- 描述：gpgme Python bindings test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "python3-gpgme package not installed"
  CHECK_RESULT $? 0 0 "Failed to import gpg module"
  CHECK_RESULT $? 0 0 "Failed to get gpgme version"
  CHECK_RESULT $? 0 0 "Failed to create gpgme context"
  CHECK_RESULT $? 0 0 "Failed to get gpgme version components"
```

- 涉及命令：python3×4, rpm×1
