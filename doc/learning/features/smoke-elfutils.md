# smoke-elfutils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-elfutils` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_eu-addr2line_input_options_001 | eu-addr2line 输入选择选项 -e -k -M -p | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_eu-elfcompress_default | eu-elfcompress 默认执行 | pre_test/run_test/post_test | 28 |  |  |  |
| oe_test_eu-elfcompress_f | eu-elfcompress 选项 -f, --force | pre_test/run_test/post_test | 17 |  |  |  |
| oe_test_eu-elfcompress_n | eu-elfcompress 选项 -n, --name=SECTION | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_eu-elfcompress_q | eu-elfclassify 输入选项 | pre_test/run_test/post_test | 16 |  |  |  |
| oe_test_eu-elfcompress_v | eu-elfcompress 选项 -v, --verbose | pre_test/run_test/post_test | 20 |  |  |  |
| oe_test_eu-size_output_format | eu-size 输出格式 | pre_test/run_test/post_test | 30 |  |  |  |
| oe_test_eu-strings_output_selection | eu-strings 输出选择选项 | pre_test/run_test/post_test | 35 |  |  |  |
| oe_test_eu-strip_output_option_001 | eu-strip 默认执行及--remove-comment选项 | pre_test/run_test/post_test | 16 |  |  |  |

### 断言与命令明细

#### oe_test_eu-addr2line_input_options_001

- 描述：eu-addr2line 输入选择选项 -e -k -M -p
- 函数：`pre_test, run_test, post_test`
- 涉及命令：yum×2, kill×1

#### oe_test_eu-elfcompress_default

- 描述：eu-elfcompress 默认执行
- 函数：`pre_test, run_test, post_test`
- 断言（28 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 1 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 1 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  ... 共 28 条（其余见源脚本）
```

- 涉及命令：eu-elfcompress×4, grep×2, yum×1

#### oe_test_eu-elfcompress_f

- 描述：eu-elfcompress 选项 -f, --force
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：eu-elfcompress×1, yum×1

#### oe_test_eu-elfcompress_n

- 描述：eu-elfcompress 选项 -n, --name=SECTION
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
```

- 涉及命令：eu-elfcompress×1, yum×1

#### oe_test_eu-elfcompress_q

- 描述：eu-elfclassify 输入选项
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：eu-elfcompress×3, test×1, yum×1

#### oe_test_eu-elfcompress_v

- 描述：eu-elfcompress 选项 -v, --verbose
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：eu-elfcompress×5, yum×1

#### oe_test_eu-size_output_format

- 描述：eu-size 输出格式
- 函数：`pre_test, run_test, post_test`
- 断言（30 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  ... 共 30 条（其余见源脚本）
```

- 涉及命令：eu-size×6, yum×1

#### oe_test_eu-strings_output_selection

- 描述：eu-strings 输出选择选项
- 函数：`pre_test, run_test, post_test`
- 断言（35 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 1 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  ... 共 35 条（其余见源脚本）
```

- 涉及命令：eu-strings×9, yum×1

#### oe_test_eu-strip_output_option_001

- 描述：eu-strip 默认执行及--remove-comment选项
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：readelf×4, yum×2
