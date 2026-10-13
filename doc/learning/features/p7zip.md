# p7zip

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/p7zip` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_p7zip_7za_001 | Test p7zip | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_p7zip_7za_002 | Test p7zip | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_p7zip_7za_003 | Test p7zip | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_p7zip_7za_004 | Test p7zip | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_p7zip_7za_005 | Test p7zip | pre_test/run_test/post_test | 14 | ✔ |  |  |

### 断言与命令明细

#### oe_test_p7zip_7za_001

- 描述：Test p7zip
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "test failed with --help"
  CHECK_RESULT $? 1 0 "test failed with a"
  CHECK_RESULT $? 0 0 "test failed with b"
  CHECK_RESULT $? 0 0 "test failed with l"
  CHECK_RESULT $? 1 0 "test failed with d"
  CHECK_RESULT $? 0 0 "test failed with e"
  CHECK_RESULT $? 0 0 "test failed with h"
  CHECK_RESULT $? 0 0 "test failed with i"
  CHECK_RESULT $? 0 0 "test failed with rn"
  CHECK_RESULT $? 0 0 "test failed with t"
  CHECK_RESULT $? 1 0 "test failed with u"
  CHECK_RESULT $? 0 0 "test failed with x"
```

#### oe_test_p7zip_7za_002

- 描述：Test p7zip
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test failed with -ssw"
  CHECK_RESULT $? 0 0 "test failed with -stl"
  CHECK_RESULT $? 0 0 "test failed with -stm"
  CHECK_RESULT $? 0 0 "test failed with -stx"
  CHECK_RESULT $? 1 0 "test failed with -t"
  CHECK_RESULT $? 0 0 "test failed with -u"
  CHECK_RESULT $? 0 0 "test failed with -v"
  CHECK_RESULT $? 1 0 "test failed with -w"
  CHECK_RESULT $? 1 0 "test failed with -x"
  CHECK_RESULT $? 0 0 "test failed with -y"
```

- 涉及命令：tar×1

#### oe_test_p7zip_7za_003

- 描述：Test p7zip
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "test failed with -slt"
  CHECK_RESULT $? 1 0 "test failed with -snh"
  CHECK_RESULT $? 1 0 "test failed with -snl"
  CHECK_RESULT $? 0 0 "test failed with -so"
  CHECK_RESULT $? 1 0 "test failed with -spd"
  CHECK_RESULT $? 0 0 "test failed with -spe"
  CHECK_RESULT $? 0 0 "test failed with -spf"
  CHECK_RESULT $? 0 0 "test failed with -ssc"
```

- 涉及命令：tar×1

#### oe_test_p7zip_7za_004

- 描述：Test p7zip
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "test failed with -r"
  CHECK_RESULT $? 0 0 "test failed with -sa"
  CHECK_RESULT $? 0 0 "test failed with -scc"
  CHECK_RESULT $? 0 0 "test failed with -scs"
  CHECK_RESULT $? 0 0 "test failed with -scrc"
  CHECK_RESULT $? 1 0 "test failed with -sdel"
  CHECK_RESULT $? 0 0 "test failed with -seml"
  CHECK_RESULT $? 0 0 "test failed with -si"
  CHECK_RESULT $? 0 0 "test failed with -slp"
```

#### oe_test_p7zip_7za_005

- 描述：Test p7zip
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "test failed with --"
  CHECK_RESULT $? 0 0 "test failed with -ai"
  CHECK_RESULT $? 0 0 "test failed with -ax"
  CHECK_RESULT $? 0 0 "test failed with -ao"
  CHECK_RESULT $? 0 0 "test failed with -an"
  CHECK_RESULT $? 0 0 "test failed with -bb"
  CHECK_RESULT $? 0 0 "test failed with -bd"
  CHECK_RESULT $? 0 0 "test failed with -bs"
  CHECK_RESULT $? 0 0 "test failed with -bt"
  CHECK_RESULT $? 0 0 "test failed with -i"
  CHECK_RESULT $? 0 0 "test failed with -m"
  CHECK_RESULT $? 0 0 "test failed with -mmt" | grep 'Everything is Ok'
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：set×1
