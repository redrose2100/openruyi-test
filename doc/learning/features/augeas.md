# augeas

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/augeas` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_augeas_augprint | Test the basic functions of augeas | pre_test/ver/run_test/post_test | 5 | ✔ |  |  |
| oe_test_augeas_augmatch | Test the basic functions of augeas | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_augeas_augtool01 | Test the basic functions of augeas | pre_test/check/run_test/post_test | 3 | ✔ |  |  |
| oe_test_augeas_augparse | test augparse | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_augeas_augtool02 | Test the basic functions of augeas | pre_test/ver/run_test/post_test | 3 | ✔ |  |  |
| oe_test_augeas_augmatch_01 | test augprint | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_fadot | test fadot | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_augeas_augprint

- 描述：Test the basic functions of augeas
- 函数：`pre_test, ver, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "augprint failed."
  CHECK_RESULT $? 0 0 "Simplelines camera failed to parse/etc/hosts file"
  CHECK_RESULT $? 0 0 "Find and output the content or node error that matches regular expression 12 in the/etc/hosts file"
  CHECK_RESULT $? 0 0 "The generated output command script will have a more readable format for error reporting"
  CHECK_RESULT $? 0 0 "Using * instead of seq:: * in path expression yields an error message"
```

#### oe_test_augeas_augmatch

- 描述：Test the basic functions of augeas
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "augmatch $i $conf failed"
  CHECK_RESULT $? 0 1 "augmatch -m get unmatched node(s)"
  CHECK_RESULT $? 0 0 "augmatch transfer file with Hosts failed."
  CHECK_RESULT $? 0 0 "Wrong output by augmatch, -l option doesn't work properly"
```

- 涉及命令：augmatch×1

#### oe_test_augeas_augtool01

- 描述：Test the basic functions of augeas
- 函数：`pre_test, check, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? "$4" 0 "content not as expected $3"
  CHECK_RESULT $? "$4" 0 "content not as expected $3"
  CHECK_RESULT $? 0 0 "$AUGEAS_ROOT/etc/hosts not exists, pre_test failed." 1
```

- 涉及命令：augtool×2, mkdir×1, test×1

#### oe_test_augeas_augparse

- 描述：test augparse
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Augparse tracking output error"
  CHECK_RESULT $? 0 0 "Type check error for disabling lens"
  CHECK_RESULT $? 0 0 "Augparse execution failed"
  CHECK_RESULT $? 0 0 "Augparse failed to handle multiple input files"
  CHECK_RESULT $? 0 0 "Augparse should report error for invalid lens file"
```

- 涉及命令：augparse×1

#### oe_test_augeas_augtool02

- 描述：Test the basic functions of augeas
- 函数：`pre_test, ver, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "augtool failed to modify /etc/hosts."
  CHECK_RESULT $? 0 0 "augeas failed to save changes."
  CHECK_RESULT $? 0 0 "augeas failed to match nodes in /etc/hosts."
```

- 涉及命令：augtool×3

#### oe_test_augeas_augmatch_01

- 描述：test augprint
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Hosts file parsing failed"
  CHECK_RESULT $? 0 0 "Resolv file parsing with lens failed"
  CHECK_RESULT $? 0 0 "Match option test failed"
  CHECK_RESULT $? 0 0 "Combined options test failed"
  CHECK_RESULT $? 0 0 "Error handling failed"
```

- 涉及命令：augmatch×4, mkdir×1

#### oe_test_fadot

- 描述：test fadot
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Error reporting detailed information of regular expression"
  CHECK_RESULT $? 0 0 "Connecting two regular expressions yields an error"
  CHECK_RESULT $? 0 0 "Generate union error for two regular expressions"
  CHECK_RESULT $? 0 0 "Output regular expression information in JSON format with error message"
  CHECK_RESULT $? 0 0 "Example generation failed"
  CHECK_RESULT $? 0 0 "Non-minimized expansion failed"
  CHECK_RESULT $? 0 0 "DOT file generation failed"
```

- 涉及命令：fadot×7
