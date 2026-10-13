# groovy18

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/groovy18` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_java2groovy18 | Test groovy | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_groovy18sh | Test groovy | pre_test/run_test/post_test | 19 | ✔ |  | 200m |
| oe_test_groovy18_01 | Test groovy | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_groovy18_02 | Test groovy | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_groovy18c_01 | Test groovy | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_grape_01 | Test grape | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_grape_02 | Test grape | pre_test/run_test/post_test | 10 | ✔ |  | 60m |
| oe_test_groovy18c_02 | Test groovy | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_java2groovy18

- 描述：Test groovy
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check java2groovy18 failed"
```

- 涉及命令：tar×1

#### oe_test_groovy18sh

- 描述：Test groovy
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Check groovy18sh --help failed"
  CHECK_RESULT $? 0 0 "Check groovy18sh -h failed"
  CHECK_RESULT $? 0 0 "Check groovy18sh --version failed"
  CHECK_RESULT $? 0 0 "Check groovy18sh -V failed"
  CHECK_RESULT $? 0 0 "Check groovy18sh --terminal failed"
  CHECK_RESULT $? 0 0 "Check groovy18sh -T failed"
  CHECK_RESULT $? 0 0 "Check groovy18sh --color failed"
  CHECK_RESULT $? 0 0 "Check groovy18sh -C failed"
  CHECK_RESULT $? 0 0 "Check groovy18sh -D failed"
  CHECK_RESULT $? 0 0 "Check groovy18sh --define failed"
  CHECK_RESULT $? 0 0 "Check groovy18sh -d failed"
  CHECK_RESULT $? 0 0 "Check groovy18sh --define failed"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：groovy18sh×6, tar×1

#### oe_test_groovy18_01

- 描述：Test groovy
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check groovy18 -v failed"
  CHECK_RESULT $? 0 0 "Check groovy18 --version failed"
  CHECK_RESULT $? 0 0 "Check groovy18 --help failed"
  CHECK_RESULT $? 0 0 "Check groovy18 -h failed"
  CHECK_RESULT $? 0 0 "Check groovy18 -e failed"
  CHECK_RESULT $? 0 0 "Check groovy18 file failed"
  CHECK_RESULT $? 0 0 "Check groovy18 -cp failed"
  CHECK_RESULT $? 0 0 "Check groovy18 --classpath failed"
  CHECK_RESULT $? 0 0 "Check groovy18 -l failed"
```

- 涉及命令：groovy18×5, tar×1, kill×1

#### oe_test_groovy18_02

- 描述：Test groovy
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check groovy18 -p failed"
  CHECK_RESULT $? 0 0 "Check groovy18 -a failed"
  CHECK_RESULT $? 0 0 "Check groovy18 -i failed"
  CHECK_RESULT $? 0 0 "Check groovy18 -pe failed"
  CHECK_RESULT $? 0 0 "Check groovy18 -n failed"
  CHECK_RESULT $? 0 0 "Check groovy18 --debug failed"
  CHECK_RESULT $? 0 0 "Check groovy18 -d failed"
  CHECK_RESULT $? 0 0 "Check groovy18 -D failed"
  CHECK_RESULT $? 0 0 "Check groovy18 --define failed"
  CHECK_RESULT $? 0 0 "Check groovy18 --encoding failed"
  CHECK_RESULT $? 0 0 "Check groovy18 -c failed"
  CHECK_RESULT $? 0 0 "Check groovy18 --disableopt failed"
```

- 涉及命令：groovy18×4, grep×2, tar×1, test×1

#### oe_test_groovy18c_01

- 描述：Test groovy
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check groovy18c --help failed"
  CHECK_RESULT $? 0 0 "Check groovy18c -h failed"
  CHECK_RESULT $? 0 0 "Check groovy18c -v failed"
  CHECK_RESULT $? 0 0 "Check groovy18c --version failed"
  CHECK_RESULT $? 0 0 "Check groovy18c -d failed"
  CHECK_RESULT $? 0 0 "Check groovy18c -e failed"
  CHECK_RESULT $? 0 0 "Check groovy18c --encoding failed"
  CHECK_RESULT $? 0 0 "Check groovy18c -j failed"
  CHECK_RESULT $? 0 0 "Check groovy18c -classpath failed"
  CHECK_RESULT $? 0 0 "Check groovy18c --classpath failed"
```

- 涉及命令：groovy18c×7, tar×1

#### oe_test_grape_01

- 描述：Test grape
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check grape install failed"
  CHECK_RESULT $? 0 0 "Check grape list failed"
  CHECK_RESULT $? 0 0 "Check grape resolve failed"
  CHECK_RESULT $? 0 0 "Check grape --help failed"
  CHECK_RESULT $? 0 0 "Check grape -h failed"
  CHECK_RESULT $? 0 0 "Check grape -v failed"
  CHECK_RESULT $? 0 0 "Check grape --version failed"
  CHECK_RESULT $? 0 0 "Check grape -D failed"
  CHECK_RESULT $? 0 0 "Check grape --define failed"
  CHECK_RESULT $? 0 0 "Check grape uninstall failed"
```

- 涉及命令：grape18×3, tar×1

#### oe_test_grape_02

- 描述：Test grape
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check grape -w failed"
  CHECK_RESULT $? 0 0 "Check grape --warn failed"
  CHECK_RESULT $? 0 0 "Check grape --info failed"
  CHECK_RESULT $? 0 0 "Check grape -i failed"
  CHECK_RESULT $? 0 0 "Check grape -V failed"
  CHECK_RESULT $? 0 0 "Check grape --verbose failed"
  CHECK_RESULT $? 0 0 "Check grape -d failed"
  CHECK_RESULT $? 0 0 "Check grape --debug failed"
  CHECK_RESULT $? 0 0 "Check grape -q failed"
  CHECK_RESULT $? 0 0 "Check grape --quiet failed"
```

- 涉及命令：grape18×5, tar×1

#### oe_test_groovy18c_02

- 描述：Test groovy
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check groovy18c -cp failed"
  CHECK_RESULT $? 0 0 "Check groovy18c --sourcepath failed"
  CHECK_RESULT $? 0 0 "Check groovy18c --temp failed"
  CHECK_RESULT $? 0 0 "Check groovy18c -J failed"
  CHECK_RESULT $? 0 0 "Check groovy18c --baseScript failed"
  CHECK_RESULT $? 0 0 "Check groovy18c -b failed"
```

- 涉及命令：test×6, groovy18c×4, tar×1
