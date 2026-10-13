# gradle

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gradle` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gradle_01 | verification gradle‘s command | pre_test/run_test/post_test | 9 | ✔ |  | 60m |
| oe_test_gradle_02 | verification gradle‘s command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_gradle_03 | verification gradle‘s command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_gradle_04 | verification gradle‘s command | pre_test/run_test/post_test | 13 | ✔ |  | 60m |

### 断言与命令明细

#### oe_test_gradle_01

- 描述：verification gradle‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check gradle --help failed"
  CHECK_RESULT $? 0 0 "Check gradle --version failed."
  CHECK_RESULT $? 0 0 "Check gradle failed."
  CHECK_RESULT $? 0 0 "Check gradle buildEnvironment failed."
  CHECK_RESULT $? 0 0 "Check gradle components failed."
  CHECK_RESULT $? 0 0 "Check gradle model failed."
  CHECK_RESULT $? 0 0 "Check gradle properties failed."
  CHECK_RESULT $? 0 0 "Check gradle -q projects failed."
  CHECK_RESULT $? 0 0 "Check gradle dependencies failed."
```

- 涉及命令：gradle×1

#### oe_test_gradle_02

- 描述：verification gradle‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check gradle tasks init failed"
  CHECK_RESULT $? 0 0 "Failed to generate these four files and the directory of gradle."
  CHECK_RESULT $? 0 0 "Check gradle tasks wrapper failed."
  CHECK_RESULT $? 0 0 "Failed to generate the directory of gradle and these two files."
  CHECK_RESULT $? 0 0 "Check gradle -m build failed."
  CHECK_RESULT $? 0 0 "Check gradle build --profile failed."
  CHECK_RESULT $? 0 0 "Failed to generate the directory of profile."
  CHECK_RESULT $? 0 0 "Check gradle -q -b failed."
  CHECK_RESULT $? 0 0 "Check gradle -q -p failed."
  CHECK_RESULT $? 0 0 "Check gradle base failed."
  CHECK_RESULT $? 1 0 "Check gradle -q base failed."
  CHECK_RESULT $? 0 0 "Check gradle -w base failed."
```

- 涉及命令：gradle×5, test×3

#### oe_test_gradle_03

- 描述：verification gradle‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check gradle -i base failed."
  CHECK_RESULT $? 0 0 "Check gradle extend failed."
  CHECK_RESULT $? 0 0 "Check gradle base dolast failed."
  CHECK_RESULT $? 1 0 "Check gradle base dolast -x dolast failed."
  CHECK_RESULT $? 0 0 "Check gradle base --rerun-tasks failed."
  CHECK_RESULT $? 0 0 "Check gradle base --continue failed."
  CHECK_RESULT $? 0 0 "Check gradle base --console plain failed."
  CHECK_RESULT $? 0 0 "Check gradle base --console plain failed."
  CHECK_RESULT $? 0 0 "Check gradle base --status failed."
```

- 涉及命令：gradle×1

#### oe_test_gradle_04

- 描述：verification gradle‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check gradle base --scan failed"
  CHECK_RESULT $? 0 0 "Check gradle build failed."
  CHECK_RESULT $? 0 0 "Failed to generate the directory of build."
  CHECK_RESULT $? 0 0 "Check gradle check failed."
  CHECK_RESULT $? 0 0 "Check gradle clean failed."
  CHECK_RESULT $? 1 0 "Test failed, we hope clean the directory of build."
  CHECK_RESULT $? 0 0 "Check gradle -q help task base failed."
  CHECK_RESULT $? 0 0 "Check gradle dependencyInsight failed."
  CHECK_RESULT $? 0 0 "Check gradle javadoc failed."
  CHECK_RESULT $? 0 0 "Check gradle assemble failed."
  CHECK_RESULT $? 0 0 "Check gradle jar failed."
  CHECK_RESULT $? 0 0 "Failed to generate the jar."
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×3, gradle×1
