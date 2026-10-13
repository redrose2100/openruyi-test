# libverto

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libverto/` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libverto | libverto asynchronous event loop library | pre_test/run_test/post_test | 17 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libverto

- 描述：libverto asynchronous event loop library
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "libverto package not installed"
  CHECK_RESULT $? 0 0 "libverto package verification failed"
  CHECK_RESULT $? 0 0 "libverto header file verto.h missing"
  CHECK_RESULT $? 0 0 "libverto shared library missing"
  CHECK_RESULT $? 0 0 "Failed to copy libverto test source file"
  CHECK_RESULT $? 0 0 "Failed to compile libverto test program"
  CHECK_RESULT $? 0 0 "Failed to run libverto default backend test"
  CHECK_RESULT $? 0 0 "libverto default backend selection failed"
  CHECK_RESULT $? 0 0 "libverto timer event test failed"
  CHECK_RESULT $? 0 0 "libverto FD event test failed"
  CHECK_RESULT $? 0 0 "libverto default backend all tests failed"
  CHECK_RESULT $? 0 0 "Failed to run libverto libev backend test"
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：rpm×3, test×1, gcc×1
