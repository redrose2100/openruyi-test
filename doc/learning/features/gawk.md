# gawk

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gawk` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gawk | test gawk | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_gawk01 | test gawk | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_gawk02 | test gawk | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_gawk03 | test gawk | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_gawk04 | test gawk structured command | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gawk

- 描述：test gawk
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "display help information failed"
  CHECK_RESULT "$(gawk '{print $1}' data.txt |xargs)" "hello goodbye nothing" 0 "display first column failed"
  CHECK_RESULT "$(gawk '{gsub(/world/, "orange")} {print}' data.txt)" "$(cat data1.txt)" 0 "chage world for data.txt failed"
```

- 涉及命令：sed×1, gawk×1

#### oe_test_gawk01

- 描述：test gawk
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(echo "My name is Rich" | gawk '{$4="Christine"; print $0}' )" "My name is Christine" 0 "change specific word failed"
  CHECK_RESULT $? 0 0 "test begin-end failed"
```

#### oe_test_gawk02

- 描述：test gawk
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "test FIELDWIDTHS failed"
  CHECK_RESULT "$(gawk 'BEGIN{x = 4; x = x * 2 + 3; print x;}')" "11" 0 "test variable failed"
  CHECK_RESULT "$(gawk 'BEGIN{var[1] = 34;var[2] = 3;total = var[1] + var[2];print total;}')" "37" 0 "test data collection failed"
  CHECK_RESULT "$(gawk 'BEGIN{x="testing"; print toupper(x),length(x)}')" "TESTING 7" 0 "test toupper length failed"
  CHECK_RESULT $? 0 0 "test asort failed"
  CHECK_RESULT $? 0 0 "test asorti failed"
```

#### oe_test_gawk03

- 描述：test gawk
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "test FS failed"
  CHECK_RESULT $? 0 0 "test FS OFS failed"
  CHECK_RESULT $? 0 0 "test FS RS failed"
  CHECK_RESULT $? 0 0 "test split failed"
```

#### oe_test_gawk04

- 描述：test gawk structured command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "test while failed"
  CHECK_RESULT $? 0 0 "test while and if failed"
  CHECK_RESULT $? 0 0 "test do-while loop failed"
  CHECK_RESULT $? 0 0 "test for loop failed"
```
