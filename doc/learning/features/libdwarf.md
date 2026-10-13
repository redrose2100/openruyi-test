# libdwarf

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libdwarf` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libdwarf | libdwarf Command Test | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_dwz | Test drawf tool dwz basic functionality | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libdwarf

- 描述：libdwarf Command Test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Debug information viewing failed"
  CHECK_RESULT $? 0 0 " abbrev information viewing failed"
  CHECK_RESULT $? 0 0 "Debug information viewing failed"
  CHECK_RESULT $? 0 0 "debug_aranges information viewing failed"
  CHECK_RESULT $? 0 0 "debug_info information viewing failed"
  CHECK_RESULT $? 0 0 "gnu_debuglink information viewing failed"
  CHECK_RESULT $? 0 0 "debug_ranges information viewing failed"
```

- 涉及命令：dwarfdump×7

#### oe_test_dwz

- 描述：Test drawf tool dwz basic functionality
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "gcc may failed to create output file" 1
  CHECK_RESULT $? 0 0 "gcc may failed to create output file" 1
  CHECK_RESULT $? 0 0 "dwz compress ELF failed" 1
  CHECK_RESULT $? 0 0 "ELF file size not compressed by dwz"
```

- 涉及命令：gcc×1, test×1
