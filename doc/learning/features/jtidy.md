# jtidy

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/jtidy` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_jtidy_01 | Test jtidy | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_jtidy_02 | Test jtidy | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_jtidy_03 | Test jtidy | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_jtidy_04 | Test jtidy | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_jtidy_01

- 描述：Test jtidy
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: jtidy -v"
  CHECK_RESULT $? 0 0 "Failed option: jtidy -h "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -i "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -o "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -wrap "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -config "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -show-config "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -u "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -c "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -b "
```

- 涉及命令：jtidy×7, tar×1

#### oe_test_jtidy_02

- 描述：Test jtidy
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: jtidy -help-config "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -n "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -e "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -q "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -asxml "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -asxhtml "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -xml "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -ashtml "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -slides "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -slides "
```

- 涉及命令：jtidy×8, tar×1

#### oe_test_jtidy_03

- 描述：Test jtidy
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: jtidy -f "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -raw "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -ascii "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -latin1 "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -iso2022 "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -utf8 "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -mac "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -utf16le "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -utf16be "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -utf16 "
```

- 涉及命令：jtidy×8, tar×1

#### oe_test_jtidy_04

- 描述：Test jtidy
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: jtidy -win1252 "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -big5 "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -shiftjis "
  CHECK_RESULT $? 0 0 "Failed option: jtidy -language "
```

- 涉及命令：tar×1, jtidy×1
