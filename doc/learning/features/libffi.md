# libffi

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libffi` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libffi | Test libffi C API calls | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libffi

- 描述：Test libffi C API calls
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "libffi packages are not installed"
  CHECK_RESULT $? 0 0 "failed to get libffi rpm version"
  CHECK_RESULT $? 0 0 "failed to get libffi pkg-config version"
  CHECK_RESULT $? 0 0 "version mismatch: rpm=${rpm_version}, pkg-config=${pkg_version}"
  CHECK_RESULT $? 0 0 "failed to compile the libffi API test program"
  CHECK_RESULT $? 0 0 "libffi ffi_call did not return the expected result"
```

- 涉及命令：mkdir×1, rpm×1, gcc×1, grep×1
