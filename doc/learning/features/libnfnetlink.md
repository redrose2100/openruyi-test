# libnfnetlink

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libnfnetlink` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libnfnetlink_install | test libnfnetlink package installation | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_libnfnetlink_basic | test libnfnetlink API compilation and library loading | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libnfnetlink_install

- 描述：test libnfnetlink package installation
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "libnfnetlink runtime library not found"
  CHECK_RESULT $? 0 0 "libnfnetlink development library not found"
  CHECK_RESULT $? 0 0 "libnfnetlink.h header file not found"
  CHECK_RESULT $? 0 0 "linux_nfnetlink.h header file not found"
  CHECK_RESULT $? 0 0 "libnfnetlink.pc pkg-config file not found"
  CHECK_RESULT $? 0 0 "pkg-config libnfnetlink not found"
  CHECK_RESULT $? 0 0 "pkg-config --libs libnfnetlink failed"
  CHECK_RESULT $? 0 0 "pkg-config --cflags libnfnetlink failed"
```

- 涉及命令：test×3

#### oe_test_libnfnetlink_basic

- 描述：test libnfnetlink API compilation and library loading
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "libnfnetlink not found in ldconfig cache"
  CHECK_RESULT $? 0 0 "Failed to compile test program"
  CHECK_RESULT $? 0 0 "Test program execution failed"
```

- 涉及命令：mkdir×1, ldconfig×1, gcc×1
