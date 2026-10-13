# discount

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/discount` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_discount_markdown_01 | the test of discount package | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_discount_markdown_02 | the test of discount package | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_discount-makepage_01 | the test of discount package | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_discount-mkd2html_01 | the test of discount package | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_discount-theme_01 | the test of discount package | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_discount_markdown_01

- 描述：the test of discount package
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: markdown --version"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -V"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -VV"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -b"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -base"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -d"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -debug"
  CHECK_RESULT $? 1 0 "Failed to run command: markdown -f"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -n"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -S"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -style"
```

- 涉及命令：markdown×10

#### oe_test_discount_markdown_02

- 描述：the test of discount package
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -o"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -E"
  CHECK_RESULT $? 1 0 "Failed to run command: markdown -5"
  CHECK_RESULT $? 1 0 "Failed to run command: markdown -html5"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -T"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -toc"
  CHECK_RESULT $? 1 0 "Failed to run command: markdown -F"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -G"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -s"
  CHECK_RESULT $? 0 0 "Failed to run command: markdown -t"
```

- 涉及命令：markdown×10, test×2

#### oe_test_discount-makepage_01

- 描述：the test of discount package
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: discount-makepage --version"
  CHECK_RESULT $? 0 0 "Failed to run command: discount-makepage -V"
  CHECK_RESULT $? 0 0 "Failed to run command: discount-makepage -VV"
  CHECK_RESULT $? 1 0 "Failed to run command: discount-makepage -f"
  CHECK_RESULT $? 1 0 "Failed to run command: discount-makepage -flags"
  CHECK_RESULT $? 1 0 "Failed to run command: discount-makepage -F"
```

- 涉及命令：discount-makepage×5

#### oe_test_discount-mkd2html_01

- 描述：the test of discount package
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: discount-makepage -header"
  CHECK_RESULT $? 0 0 "Failed to run command: discount-makepage -footer"
  CHECK_RESULT $? 0 0 "Failed to run command: discount-makepage -css"
```

- 涉及命令：discount-mkd2html×3, test×1

#### oe_test_discount-theme_01

- 描述：the test of discount package
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: discount-theme -V"
  CHECK_RESULT $? 0 0 "Failed to run command: discount-theme -o"
  CHECK_RESULT $? 0 0 "Failed to run command: discount-theme -f"
  CHECK_RESULT $? 0 0 "Failed to run command: discount-theme -C"
  CHECK_RESULT $? 1 0 "Failed to run command: discount-theme -c"
  CHECK_RESULT $? 0 0 "Failed to run command: discount-theme -E"
  CHECK_RESULT $? 0 0 "Failed to run command: discount-theme -d"
  CHECK_RESULT $? 0 0 "Failed to run command: discount-theme -p"
  CHECK_RESULT $? 0 0 "Failed to run command: discount-theme -t"
```

- 涉及命令：discount-theme×9, test×7
