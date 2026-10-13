# aspell

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/aspell` |
| 注册用例数 | 10 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_aspell_01 | verify the uasge of aspell command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_aspell_02 | verify the uasge of aspell command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_aspell_precat_01 | verify the uasge of aspell command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_aspell_precat_02 | verify the uasge of aspell command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_aspell_preunzip_01 | verify the uasge of aspell command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_aspell_preunzip_02 | verify the uasge of aspell command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_aspell_prezip-bin | verify the uasge of aspell command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_aspell_prezip_01 | verify the uasge of aspell command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_aspell_prezip_02 | verify the uasge of aspell command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_aspell_word-list-compress | verify the uasge of aspell command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_aspell_01

- 描述：verify the uasge of aspell command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check aspell -? failed"
  CHECK_RESULT $? 0 0 "Check aspell usage failed"
  CHECK_RESULT $? 0 0 "Check aspell help failed"
  CHECK_RESULT $? 0 0 "Check aspell -v failed"
  CHECK_RESULT $? 0 0 "Check aspell version failed"
  CHECK_RESULT $? 0 0 "Check aspell list failed"
  CHECK_RESULT $? 0 0 "Check aspell config failed"
  CHECK_RESULT $? 0 0 "Check aspell config f-html-skip failed"
  CHECK_RESULT $? 0 0 "Check aspell -a failed"
```

- 涉及命令：aspell×1

#### oe_test_aspell_02

- 描述：verify the uasge of aspell command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check aspell pipe failed"
  CHECK_RESULT $? 0 0 "Check aspell soundslike failed"
  CHECK_RESULT $? 0 0 "Check aspell expand failed"
  CHECK_RESULT $? 0 0 "Check aspell clean failed"
  CHECK_RESULT $? 0 0 "Check aspell munch-list failed"
  CHECK_RESULT $? 0 0 "Check aspell dicts failed"
  CHECK_RESULT $? 0 0 "Check aspell filters failed"
  CHECK_RESULT $? 0 0 "Check aspell modes failed"
  CHECK_RESULT $? 0 0 "Check aspell munch --sug-mode=bad-spellers conv from to either none failed"
  CHECK_RESULT $? 0 0 "Check aspell munch --sug-mode=bad-spellers -l en norm-map 1.txt failed"
  CHECK_RESULT $? 0 0 "Check spell failed"
```

#### oe_test_aspell_precat_01

- 描述：verify the uasge of aspell command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check precat -h failed"
  CHECK_RESULT $? 0 0 "Check precat --help failed"
  CHECK_RESULT $? 0 0 "Check precat -V  failed"
  CHECK_RESULT $? 0 0 "Check precat --version failed"
  CHECK_RESULT $? 0 0 "Check precat -d 1.txt.pz failed"
  CHECK_RESULT $? 0 0 "Check precat --decompress 1.txt.pz failed"
  CHECK_RESULT $? 0 0 "Check precat -z 1.txt.pz failed"
  CHECK_RESULT $? 0 0 "Check precat --compress 1.txt.pz failed"
  CHECK_RESULT $? 0 0 "Check precat -L failed"
  CHECK_RESULT $? 0 0 "Check precat --license failed"
```

- 涉及命令：precat×5

#### oe_test_aspell_precat_02

- 描述：verify the uasge of aspell command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check precat -f -c -k failed"
  CHECK_RESULT $? 0 0 "Check precat --force --stdout --keep failed"
  CHECK_RESULT $? 0 0 "Check precat -q -S -s failed"
  CHECK_RESULT $? 0 0 "Check precat --quiet --nocwl --sort failed"
```

- 涉及命令：precat×2

#### oe_test_aspell_preunzip_01

- 描述：verify the uasge of aspell command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check preunzip -h failed"
  CHECK_RESULT $? 0 0 "Check preunzip --help failed"
  CHECK_RESULT $? 0 0 "Check preunzip -V failed"
  CHECK_RESULT $? 0 0 "Check preunzip --version failed"
  CHECK_RESULT $? 0 0 "Check preunzip -z failed"
  CHECK_RESULT $? 0 0 "Check preunzip -d failed"
  CHECK_RESULT $? 0 0 "Check preunzip --compress failed"
  CHECK_RESULT $? 0 0 "Check preunzip --decompress failed"
  CHECK_RESULT $? 0 0 "Check preunzip -L failed"
  CHECK_RESULT $? 0 0 "Check preunzip --license failed"
```

- 涉及命令：preunzip×5

#### oe_test_aspell_preunzip_02

- 描述：verify the uasge of aspell command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check preunzip -k failed"
  CHECK_RESULT $? 0 0 "Check preunzip --keep failed"
  CHECK_RESULT $? 0 0 "Check preunzip -q -S -s failed"
  CHECK_RESULT $? 0 0 "Check preunzip --quiet --nocwl --sort failed"
  CHECK_RESULT $? 0 0 "Check preunzip -f -c failed"
  CHECK_RESULT $? 0 0 "Check preunzip --force --stdout failed"
```

- 涉及命令：preunzip×7

#### oe_test_aspell_prezip-bin

- 描述：verify the uasge of aspell command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check prezip-bin -z failed"
  CHECK_RESULT $? 0 0 "Check prezip-bin -d failed"
  CHECK_RESULT $? 0 0 "Check prezip-bin --help failed"
```

- 涉及命令：prezip-bin×2

#### oe_test_aspell_prezip_01

- 描述：verify the uasge of aspell command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check prezip -h  failed"
  CHECK_RESULT $? 0 0 "Check prezip --help  failed"
  CHECK_RESULT $? 0 0 "Check prezip -V  failed"
  CHECK_RESULT $? 0 0 "Check prezip --version  failed"
  CHECK_RESULT $? 0 0 "Check prezip -z failed"
  CHECK_RESULT $? 0 0 "Check prezip -d failed"
  CHECK_RESULT $? 0 0 "Check prezip --compress failed"
  CHECK_RESULT $? 0 0 "Check prezip --decompress failed"
  CHECK_RESULT $? 0 0 "Check prezip -L failed"
  CHECK_RESULT $? 0 0 "Check prezip --license failed"
```

- 涉及命令：prezip×5

#### oe_test_aspell_prezip_02

- 描述：verify the uasge of aspell command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check prezip -k failed"
  CHECK_RESULT $? 0 0 "Check prezip -q -S -s failed"
  CHECK_RESULT $? 0 0 "Check prezip --keep failed"
  CHECK_RESULT $? 0 0 "Check prezip --quiet --nocwl --sort failed"
  CHECK_RESULT $? 0 0 "Check prezip -f -c failed"
  CHECK_RESULT $? 0 0 "Check prezip --force --stdout failed"
```

- 涉及命令：prezip×3

#### oe_test_aspell_word-list-compress

- 描述：verify the uasge of aspell command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check word-list-compress c failed"
  CHECK_RESULT $? 0 0 "Check word-list-compress d failed"
  CHECK_RESULT $? 0 0 "Check word-list-compress --help failed"
  CHECK_RESULT $? 0 0 "Check run-with-aspell -a java -c -l failed"
  CHECK_RESULT $? 0 0 "Check run-with-aspell --help failed"
```

- 涉及命令：run-with-aspell×1
