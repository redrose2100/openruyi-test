# units

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/units` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_units_01 | Test "units" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_units_02 | Test "units" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_units_03 | Test "units" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_units_04 | Test "units" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_units_05 | Test "units" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_units_cur | Test "units_cur" command | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_units_01

- 描述：Test "units" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check units -h failed"
  CHECK_RESULT $? 0 0 "Check units --help failed"
  CHECK_RESULT $? 0 0 "Check units -c failed"
  CHECK_RESULT $? 0 0 "Check units --check failed"
  CHECK_RESULT $? 0 0 "Check units --check-verbose failed"
  CHECK_RESULT $? 0 0 "Check units --verbose-check failed"
  CHECK_RESULT $? 0 0 "Check units -d failed"
  CHECK_RESULT $? 0 0 "Check units --digits failed"
  CHECK_RESULT $? 0 0 "Check units -e failed"
  CHECK_RESULT $? 0 0 "Check units --exponential failed"
```

- 涉及命令：expect×4, units×2

#### oe_test_units_02

- 描述：Test "units" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check units -f failed"
  CHECK_RESULT $? 0 0 "Check units --file failed"
  CHECK_RESULT $? 0 0 "Check units -H failed"
  CHECK_RESULT $? 0 0 "Check units --history failed"
  CHECK_RESULT $? 0 0 "Check units -L failed"
  CHECK_RESULT $? 0 0 "Check units --log failed"
  CHECK_RESULT $? 0 0 "Check units -l failed"
  CHECK_RESULT $? 0 0 "Check units --locale failed"
  CHECK_RESULT $? 0 0 "Check units -m failed"
  CHECK_RESULT $? 0 0 "Check units --minus failed"
```

- 涉及命令：expect×10

#### oe_test_units_03

- 描述：Test "units" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check units --oldstar failed"
  CHECK_RESULT $? 0 0 "Check units --newstar failed"
  CHECK_RESULT $? 0 0 "Check units -n failed"
  CHECK_RESULT $? 0 0 "Check units --nolists failed"
  CHECK_RESULT $? 0 0 "Check units -S failed"
  CHECK_RESULT $? 0 0 "Check units --show-factor failed"
  CHECK_RESULT $? 0 0 "Check units -o failed"
  CHECK_RESULT $? 0 0 "Check units --output-format failed"
  CHECK_RESULT $? 0 0 "Check units -p failed"
  CHECK_RESULT $? 0 0 "Check units --product failed"
```

- 涉及命令：expect×10

#### oe_test_units_04

- 描述：Test "units" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check units -q failed"
  CHECK_RESULT $? 0 0 "Check units --quiet failed"
  CHECK_RESULT $? 0 0 "Check units --silent failed"
  CHECK_RESULT $? 0 0 "Check units -s failed"
  CHECK_RESULT $? 0 0 "Check units --strict failed"
  CHECK_RESULT $? 0 0 "Check units -v failed"
  CHECK_RESULT $? 0 0 "Check units --verbose failed"
  CHECK_RESULT $? 0 0 "Check units --compact failed"
  CHECK_RESULT $? 0 0 "Check units -1 failed"
  CHECK_RESULT $? 0 0 "Check units --one-line failed"
```

- 涉及命令：expect×10

#### oe_test_units_05

- 描述：Test "units" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check units -t failed"
  CHECK_RESULT $? 0 0 "Check units --terse failed"
  CHECK_RESULT $? 0 0 "Check units -r failed"
  CHECK_RESULT $? 0 0 "Check units --round failed"
  CHECK_RESULT $? 0 0 "Check units -U failed"
  CHECK_RESULT $? 0 0 "Check units --unitsfile failed"
  CHECK_RESULT $? 0 0 "Check units -V failed"
  CHECK_RESULT $? 0 0 "Check units --version failed"
  CHECK_RESULT $? 0 0 "Check units -I failed"
  CHECK_RESULT $? 0 0 "Check units --info failed"
```

- 涉及命令：units×3, expect×2

#### oe_test_units_cur

- 描述：Test "units_cur" command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check units_cur -h failed"
  CHECK_RESULT $? 0 0 "Check units_cur --help failed"
  CHECK_RESULT $? 0 0 "Check units_cur -V failed"
  CHECK_RESULT $? 0 0 "Check units_cur --version failed"
  CHECK_RESULT "$check_v" 0 0 "Check units_cur -v failed"
  CHECK_RESULT "$check_verbose" 0 0 "Check units_cur --verbose failed"
  CHECK_RESULT "$check_iso" 0 0 "Check units_cur filename failed"
  CHECK_RESULT "$check_s" 0 0 "Check units_cur -s failed"
  CHECK_RESULT "$check_source" 0 0 "Check units_cur --source failed"
  CHECK_RESULT "$check_b" 0 0 "Check units_cur -b failed"
  CHECK_RESULT "$check_base" 0 0 "Check units_cur --base failed"
  CHECK_RESULT "$check_k" 0 0 "Check units_cur -k failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：units_cur×2
