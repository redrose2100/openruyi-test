# patchutils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/patchutils` |
| 注册用例数 | 18 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_patchutils_combinediff_01 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_combinediff_02 | verify the uasge of patchutils command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_patchutils_filterdiff_01 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_filterdiff_02 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_filterdiff_03 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_flipdiff_01 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_flipdiff_02 | verify the uasge of patchutils command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_patchutils_grepdiff_01 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_grepdiff_02 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_grepdiff_03 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_grepdiff_04 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_interdiff_01 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_interdiff_02 | verify the uasge of patchutils command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_patchutils_lsdiff_01 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_lsdiff_02 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_lsdiff_03 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_lsdiff_04 | verify the uasge of patchutils command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_patchutils_splitdiff | verify the uasge of patchutils command | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_patchutils_combinediff_01

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check combinediff --help  failed"
  CHECK_RESULT $? 0 0 "Check combinediff --version  failed"
  CHECK_RESULT $? 0 0 "Check combinediff -U 10 -i -w -b -B -q test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check combinediff --unified=10 --ignore-case --ignore-all-space --ignore-space-change --ignore-blank-lines --quiet test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check combinediff -p 1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check combinediff --strip-match=1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check combinediff -d 1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check combinediff --drop-context=1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check combinediff -z --interpolate test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check combinediff --decompress --interpolate test1.patch test2.patch  failed"
```

- 涉及命令：combinediff×4, diff×2

#### oe_test_patchutils_combinediff_02

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check combinediff --combine test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check combinediff --flip test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check combinediff --no-revert-omitted test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check dehtmldiff --help  failed"
  CHECK_RESULT $? 0 0 "Check dehtmldiff --version  failed"
  CHECK_RESULT $? 0 0 "Check dehtmldiff t1.html  failed"
  CHECK_RESULT $? 0 0 "Check editdiff --help  failed"
  CHECK_RESULT $? 0 0 "Check editdiff --version  failed"
  CHECK_RESULT $? 0 0 "Check echo :q |editdiff 1.txt  failed"
```

- 涉及命令：diff×2

#### oe_test_patchutils_filterdiff_01

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check filterdiff --help  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff -h  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --version  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff -x  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --exclude=  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --exclude-from-file=pattern --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check  filterdiff -i '*.txt' --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --include='*.txt' --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff -I pattren --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --include-from-file=pattren --lines=-5 test2.patch  failed"
```

- 涉及命令：filterdiff×4, diff×1

#### oe_test_patchutils_filterdiff_02

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check filterdiff -# 1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --hunks=1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff -F 1 --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --files=1 --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --annotate --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --as-numbered-lines=before --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --format=context --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --remove-timestamps --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --clean --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff -z 1.txt.gz  failed"
```

- 涉及命令：filterdiff×2, diff×1

#### oe_test_patchutils_filterdiff_03

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check filterdiff --decompress 1.txt.gz  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff -p 1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --strip-match=1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --strip=1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --addprefix=1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --addoldprefix=1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --addnewprefix=1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff -v test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --verbose test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --list test2.patch  failed"
```

- 涉及命令：filterdiff×2, diff×1

#### oe_test_patchutils_flipdiff_01

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check flipdiff --help  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff --version  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff -U 10 -i -w -b -B -q test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff --unified=10 --ignore-case --ignore-all-space --ignore-space-change --ignore-blank-lines --quiet test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff -p 1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff --strip-match=1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff -d 1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff --drop-context=1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff -z --interpolate test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff --decompress --interpolate test1.patch test2.patch  failed"
```

- 涉及命令：flipdiff×4, diff×2

#### oe_test_patchutils_flipdiff_02

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check flipdiff --combine test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff --flip test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff --no-revert-omitted test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check flipdiff --in-place test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff --grep ... test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check filterdiff -X pattren --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check fixcvsdiff -p -b --deep-brainwave-mode --recurse --compare 1.csv  failed"
```

- 涉及命令：diff×2, filterdiff×1, fixcvsdiff×1

#### oe_test_patchutils_grepdiff_01

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check grepdiff --help  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -h  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --version  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -x '*.c' --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --exclude='*.c' --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -X pattren --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --exclude-from-file=pattern --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -i '*.txt' --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --include='*.txt' --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -I pattren --lines=-5 aaa test2.patch  failed"
```

- 涉及命令：grepdiff×5, diff×1

#### oe_test_patchutils_grepdiff_02

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check grepdiff --include-from-file=pattren --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -# 1 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --hunks=1 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -F 1 --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --files=1 --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --annotate --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -v --as-numbered-lines=before --lines=-5 --output-matching=hunk aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --format=context --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --output-matching=hunk --lines=-5 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --remove-timestamps --lines=-5 aaa test2.patch  failed"
```

- 涉及命令：grepdiff×2, diff×1

#### oe_test_patchutils_grepdiff_03

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check grepdiff -z aaa 1.txt.gz  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --decompress aaa 1.txt.gz  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -n -N -H aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --line-number --number-files --with-filename aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Checkgrepdiff -h aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --no-filename aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -p 1 -i '*.txt' aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --strip-match=1 -i '*.txt' aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --strip=1 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --addprefix=1 aaa test2.patch  failed"
```

- 涉及命令：grepdiff×4, diff×1

#### oe_test_patchutils_grepdiff_04

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check grepdiff --addoldprefix=1 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --addnewprefix=1 aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -v aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --verbose aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -E aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --extended-regexp aaa test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff -f 2.txt test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --file=2.txt test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --filter test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check grepdiff --list test2.patch  failed"
```

- 涉及命令：grepdiff×3, diff×1

#### oe_test_patchutils_interdiff_01

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check interdiff --help  failed"
  CHECK_RESULT $? 0 0 "Check interdiff --version  failed"
  CHECK_RESULT $? 0 0 "Check interdiff -U 10 -i -w -b -B -q test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check interdiff --unified=10 --ignore-case --ignore-all-space --ignore-space-change --ignore-blank-lines --quiet test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check interdiff -p 1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check interdiff --strip-match=1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check interdiff -d 1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check  interdiff --drop-context=1 test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check interdiff -z --interpolate test1.patch test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check interdiff --decompress --interpolate test1.patch test2.patch  failed"
```

- 涉及命令：interdiff×4, diff×2

#### oe_test_patchutils_interdiff_02

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check interdiff -z --interpolate test1.patch test2.patch failed"
  CHECK_RESULT $? 0 0 "Check interdiff --combine test1.patch test2.patch failed"
  CHECK_RESULT $? 0 0 "Check interdiff --flip test1.patch test2.patch failed"
  CHECK_RESULT $? 0 0 "Check interdiff --no-revert-omitted test1.patch test2.patch failed"
  CHECK_RESULT $? 0 0 "Check espdiff --help failed"
  CHECK_RESULT $? 0 0 "Check espdiff --version failed"
  CHECK_RESULT $? 0 0 "Check espdiff --deep-brainwave-mode --recurse --compare failed"
```

- 涉及命令：diff×2, interdiff×1

#### oe_test_patchutils_lsdiff_01

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check lsdiff --help failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --version failed"
  CHECK_RESULT $? 0 0 "Check lsdiff -x '*.c' --lines=-5 test2.patch failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --exclude='*.c' --lines=-5 test2.patch failed"
  CHECK_RESULT $? 0 0 "Check lsdiff -X pattren --lines=-5 test2.patch failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --exclude-from-file=pattern --lines=-5 test2.patch failed"
  CHECK_RESULT $? 0 0 "Check lsdiff -i '*.txt' --lines=-5 test2.patch failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --include='*.txt' --lines=-5 test2.patch failed"
  CHECK_RESULT $? 0 0 "Check lsdiff -I pattren --lines=-5 test2.patch failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --include-from-file=pattren --lines=-5 test2.patch failed"
```

- 涉及命令：lsdiff×4, diff×1

#### oe_test_patchutils_lsdiff_02

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check lsdiff -# 1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --hunks=1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff -F 1 --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --files=1 --lines=-5 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff -z 1.txt.gz  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --decompress 1.txt.gz  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff -n -N -H test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --line-number --number-files --with-filename test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff -h test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --no-filename test2.patch  failed"
```

- 涉及命令：lsdiff×4, diff×1

#### oe_test_patchutils_lsdiff_03

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check lsdiff -p 1 -i '*.txt' test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --strip-match=1 -i '*.txt' test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --strip=1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --addprefix=1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --addoldprefix=1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --addnewprefix=1 test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff -s test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --status test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff -v test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --verbose test2.patch  failed"
```

- 涉及命令：lsdiff×3, diff×1

#### oe_test_patchutils_lsdiff_04

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check lsdiff -E test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --extended-regexp test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --filter test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check lsdiff --grep ... test2.patch  failed"
  CHECK_RESULT $? 0 0 "Check recountdiff --help  failed"
  CHECK_RESULT $? 0 0 "Check recountdiff --version  failed"
  CHECK_RESULT $? 0 0 "Check recountdiff 1.txt  failed"
  CHECK_RESULT $? 0 0 "Check rediff --help  failed"
  CHECK_RESULT $? 0 0 "Check rediff --version  failed"
  CHECK_RESULT $? 0 0 "Check rediff 1.txt  failed"
```

- 涉及命令：diff×1, lsdiff×1

#### oe_test_patchutils_splitdiff

- 描述：verify the uasge of patchutils command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check splitdiff --help  failed"
  CHECK_RESULT $? 0 0 "Check splitdiff --version  failed"
  CHECK_RESULT $? 0 0 "Check splitdiff -a -p 1 test1.patch  failed"
  CHECK_RESULT $? 0 0 "Check splitdiff -a -D ./ test1.patch  failed"
  CHECK_RESULT $? 0 0 "Check plitdiff -a -d -E test1.patch  failed"
  CHECK_RESULT $? 0 0 "Check unwrapdiff --help  failed"
  CHECK_RESULT $? 0 0 "Check unwrapdiff --version  failed"
  CHECK_RESULT $? 0 0 "Check unwrapdiff -v ./ 1.txt  failed"
```

- 涉及命令：splitdiff×3, diff×1, unwrapdiff×1
