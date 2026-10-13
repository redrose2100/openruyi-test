# po4a

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/po4a` |
| 注册用例数 | 14 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_po4a_01 | test command po4a | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_po4a_02 | test command po4a | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_po4a_03 | test command po4a | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_po4a-gettextize_01 | test command po4a-gettextize | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_po4a-gettextize_02 | test command po4a-gettextize | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_po4a-translate_01 | test command po4a-translate | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_po4a-translate_02 | test command po4a-translate | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_po4a-updatepo_01 | test command po4a | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_po4a-updatepo_02 | test command po4a | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_po4a-updatepo_03 | test command po4a | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_po4a-normalize_01 | test command po4a-normalize | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_po4a-normalize_02 | test command po4a-normalize | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_po4aman-display-po | test command po4aman-display-po | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_po4apod-display-po | test command po4a-display-pod and msguntypot | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_po4a_01

- 描述：test command po4a
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a -h"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a --help"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a --version"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a -V"
  CHECK_RESULT $? 0 0 "Failed to get content of tmp/po/translation.esp"
  CHECK_RESULT $? 0 0 "Failed to get content of tmp/po/translation.esp"
  CHECK_RESULT $? 0 0 "Failed to find file: tmp/po/translation.esp"
  CHECK_RESULT $? 0 0 "Failed to find file: tmp/po/translation.esp"
  CHECK_RESULT $? 0 0 "Failed to find file: tmp/po/translation.esp"
  CHECK_RESULT $? 0 0 "Failed to find file: tmp/po/translation.esp"
```

- 涉及命令：sed×3, po4a-updatepo×1, po4a×1

#### oe_test_po4a_02

- 描述：test command po4a
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --keep-translations"
  CHECK_RESULT $? 1 0 "Failed to run command: po4a tmp/po4a.cfg --rm-translations"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --translate-only tmp/po/translation.esp"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --variable lang=esp"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --srcdir . --destdir ."
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --porefs full"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --msgid-bugs-address mybug@test"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --copyright-holder my copyright"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --package-name my package"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --package-version 2.0"
```

- 涉及命令：test×6, sed×3, po4a-updatepo×1

#### oe_test_po4a_03

- 描述：test command po4a
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --msgmerge-opt --no-wrap"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --no-previous"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --previous"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --force"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/bug.cfg --debug"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --stamp"
  CHECK_RESULT $? 1 0 "Failed to run command: po4a tmp/po4a.cfg --no-translations"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a tmp/po4a.cfg --no-update"
```

- 涉及命令：test×7, sed×5, po4a-updatepo×1

#### oe_test_po4a-gettextize_01

- 描述：test command po4a-gettextize
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize --help"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -h"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize --help-format"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize --version"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -V"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m --debug"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_01.po"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_011.po"
```

- 涉及命令：po4a-gettextize×3, grep×2

#### oe_test_po4a-gettextize_02

- 描述：test command po4a-gettextize
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_02.po -M UTF-8 -L UTF-8"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_022.po -M UTF-8 -L UTF-8"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_03.po -o tabs=split"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt -l tmp/translation_esp.txt -p tmp/translation_esp_033.po --option tabs=split"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt --msgid-bugs-address test@test"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt --copyright"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt --package-name a_new_package"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-gettextize -f text -m tmp/master.txt --package-version 2.0"
```

- 涉及命令：grep×4, po4a-updatepo×4, po4a-gettextize×2

#### oe_test_po4a-translate_01

- 描述：test command po4a-translate
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translated -h"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate --help"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate --help-format"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate --version"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -V"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m master.en -p --debug"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_1.txt --verbose"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_2.txt --verbose"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_3.txt -o tabs=split"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_4.txt -o tabs=split"
```

- 涉及命令：po4a-translate×4, po4a-updatepo×1, sed×1

#### oe_test_po4a-translate_02

- 描述：test command po4a-translate
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_5.txt -k 85 -w 85"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_6.txt -k 85 -w 85"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_7.txt -M UTF-8 -L UTF-8"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m tmp/master.txt -p tmp/translation_Esp.po -l tmp/result_8.txt -M UTF-8 -L UTF-8"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m master.en -p tmp/translation_Esp.po -a addendum -A UTF-8"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-translate -f text -m master.en -p tmp/translation_Esp.po -a addendum -A UTF-8"
```

- 涉及命令：po4a-translate×3, po4a-updatepo×1, sed×1

#### oe_test_po4a-updatepo_01

- 描述：test command po4a
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo --help"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -h"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo --help-format"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo --version"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -V"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p out.po -M --debug"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_01.po --verbose"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_02.po -M UTF-8"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_022.po -M UTF-8"
```

- 涉及命令：po4a-updatepo×4

#### oe_test_po4a-updatepo_02

- 描述：test command po4a
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_01.po --package-name a_new_package"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_02.po --package-version 2.0"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_03.po --previous"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_04.po --no-previous"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m master.en -p tmp/translation_05.po --msgmerge-opt=--no-wrap"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m master.en -p tmp/translation_06.po --porefs full"
```

- 涉及命令：po4a-updatepo×6

#### oe_test_po4a-updatepo_03

- 描述：test command po4a
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_03.po -o tabs=split"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo --format text --master tmp/master.txt --po tmp/translation_033.po --option tabs=split"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_04.po -M UTF-8"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo --format text --master tmp/master.txt --po tmp/translation_044.po --master-charset UTF-8"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_05.po -o tabs=split -M UTF-8 -L UTF-8 --msgid-bugs-address test@test"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-updatepo -f text -m tmp/master.txt -p tmp/translation_06.po --copyrigh-holder"
```

- 涉及命令：po4a-updatepo×4

#### oe_test_po4a-normalize_01

- 描述：test command po4a-normalize
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalized -h"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize --help"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize --help-format"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize --version"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -V"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize --format text tmp/master.txt"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt"
```

- 涉及命令：po4a-normalize×3

#### oe_test_po4a-normalize_02

- 描述：test command po4a-normalize
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt --blank"
  CHECK_RESULT $? 1 0 "Failed to run command: po4a-normalize -f text tmp/master.txt --blank"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt -b"
  CHECK_RESULT $? 1 0 "Failed to run command: po4a-normalize -f text tmp/master.txt -b"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt -o tabs=split"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-normalize -f text tmp/master.txt --option tabs=split"
```

- 涉及命令：po4a-normalize×4, grep×2, test×1

#### oe_test_po4aman-display-po

- 描述：test command po4aman-display-po
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-man -h"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-man -p tmp/translation_Esp.po"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-man -p tmp/translation_Esp.po -m tmp/master.txt -o tabs=split"
```

- 涉及命令：po4a-display-man×3, po4a-updatepo×1, sed×1

#### oe_test_po4apod-display-po

- 描述：test command po4a-display-pod and msguntypot
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-pod -h"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-pod -p tmp/translation_Esp.po -m tmp/master.txt"
  CHECK_RESULT $? 0 0 "Failed to run command: po4a-display-pod -p tmp/translation_Esp.po -m tmp/master.txt -o tabs=split"
  CHECK_RESULT $? 0 0 "Failed to run command: msguntypotd -h"
  CHECK_RESULT $? 0 0 "Failed to run command: msguntypot -o tmp/old.pot -n tmp/new.pot tmp/old.pot"
```

- 涉及命令：po4a-updatepo×3, po4a-display-pod×3, msguntypot×2, sed×1
