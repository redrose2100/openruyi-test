# libseccomp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libseccomp` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libseccomp | libseccomp package installation and filtering functionality test | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libseccomp

- 描述：libseccomp package installation and filtering functionality test
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "libseccomp package not installed"
  CHECK_RESULT $? 0 0 "libseccomp-devel package not installed"
  CHECK_RESULT $? 0 0 "libseccomp.so not found in ${LIBDIR}"
  CHECK_RESULT $? 0 0 "libseccomp.so.2 not found in ${LIBDIR}"
  CHECK_RESULT $? 0 0 "libseccomp.so is not a symlink"
  CHECK_RESULT $? 0 0 "seccomp.h not found"
  CHECK_RESULT $? 0 0 "libseccomp pkg-config not found"
  CHECK_RESULT $? 0 0 "libseccomp version format invalid"
  CHECK_RESULT $? 0 0 "libseccomp RPM description incorrect"
  CHECK_RESULT $? 0 0 "Compile test file failed"
  CHECK_RESULT $? 0 0 "Seccomp filter tests failed"
```

- 涉及命令：rpm×3, gcc×1
