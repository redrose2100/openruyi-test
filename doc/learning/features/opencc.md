# opencc

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/opencc` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_opencc_01 | verification opencc‘s command | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_opencc_change_ocd | Adding simplified Chinese characters to complex Chinese characters in the dictionary HKVariantsRev | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_opencc_s2t_duan | Translation from simple to complex | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_opencc_s2twp | In s2twp, the translation of "芯片面积" uses s2twp to translate "正則表達式"“ | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_opencc_s2tw | conversion '衍生发行版' from simplified to Taiwan | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_opencc_s2t_zhi | About "只" simple to complex | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_opencc_t2s | About "累" simple to complex, about "妳", “甞”, “鹼”, complex to simple | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_opencc_tsp | Check in TSPrases.txt The corresponding transformation of "藉" and "覆" in dictionaries | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_opencc_two | Hong Kong, Taiwan, complex to many transition | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_opencc_01

- 描述：verification opencc‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT "$(ls /usr/share/opencc | grep -cE 'hk2s|s2hk|s2t|s2tw|s2twp|t2hk|t2s|t2tw|tw2s|tw2sp')" 10
  CHECK_RESULT "$(grep -cE '測試工程師' ./sim_chinese_zh.txt)" 1
  CHECK_RESULT "$(grep -cE '测试工程师' ./sim_chinese1.txt)" 1
  CHECK_RESULT "$(grep -cE '畢竟' ./sim_chinese_zhw.txt)" 1
  CHECK_RESULT "$(grep -cE '畢竟' ./sim_chinese_zhhk.txt)" 1
  CHECK_RESULT $?
  CHECK_RESULT "$(ls | grep -cE "sim_chinese55.txt")" 0
  CHECK_RESULT "$(opencc -i sim_chinese55.txt -o sim_chinese_zhｗ.txt -c s2tw.json)" $result
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：opencc×8

#### oe_test_opencc_change_ocd

- 描述：Adding simplified Chinese characters to complex Chinese characters in the dictionary HKVariantsRev
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：opencc_dict×4, sed×4, test×2

#### oe_test_opencc_s2t_duan

- 描述：Translation from simple to complex
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_opencc_s2twp

- 描述：In s2twp, the translation of "芯片面积" uses s2twp to translate "正則表達式"“
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_opencc_s2tw

- 描述：conversion '衍生发行版' from simplified to Taiwan
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：opencc×1

#### oe_test_opencc_s2t_zhi

- 描述：About "只" simple to complex
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_opencc_t2s

- 描述：About "累" simple to complex, about "妳", “甞”, “鹼”, complex to simple
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_opencc_tsp

- 描述：Check in TSPrases.txt The corresponding transformation of "藉" and "覆" in dictionaries
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：opencc_dict×3, grep×1

#### oe_test_opencc_two

- 描述：Hong Kong, Taiwan, complex to many transition
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```
