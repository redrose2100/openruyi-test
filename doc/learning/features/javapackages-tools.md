# javapackages-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/javapackages-tools` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_binary_files_operation | verify the uasge of check-binary-files,clean-binary-files,create-jar-links and diff-jars command | pre_test/run_test/post_test | 21 | ✔ |  |  |
| oe_test_build-classpath | verify the uasge of build-classpath and build-classpath-directory command | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_build-jar-repository | verify the uasge of build-jar-repository and rebuild-jar-repository command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_find-shade-jar | verify the uasge of find-jar and shade-jar command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_gradle-local | verify the uasge of gradle-local command | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_javapackages-local | verify the uasge of abs2rel and xmvn-builddep command | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_binary_files_operation

- 描述：verify the uasge of check-binary-files,clean-binary-files,create-jar-links and diff-jars command
- 函数：`pre_test, run_test, post_test`
- 断言（21 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：test×7, create-jar-links×4, clean-binary-files×2, check-binary-files×2

#### oe_test_build-classpath

- 描述：verify the uasge of build-classpath and build-classpath-directory command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check build-classpath log4j failed"
  CHECK_RESULT $? 0 0 "Check build-classpath junit failed"
  CHECK_RESULT $? 0 0 "Check build-classpath easymock failed"
  CHECK_RESULT $? 0 0 "Check build-classpath-directory failed"
  CHECK_RESULT $? 0 0 "Check build-classpath-directory failed"
  CHECK_RESULT $? 0 0 "Check build-classpath-directory failed"
  CHECK_RESULT $? 0 0 "Check build-classpath-directory faile"
```

#### oe_test_build-jar-repository

- 描述：verify the uasge of build-jar-repository and rebuild-jar-repository command
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

- 涉及命令：build-jar-repository×4, rebuild-jar-repository×3

#### oe_test_find-shade-jar

- 描述：verify the uasge of find-jar and shade-jar command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×1, test×1

#### oe_test_gradle-local

- 描述：verify the uasge of gradle-local command
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：gradle-local×4

#### oe_test_javapackages-local

- 描述：verify the uasge of abs2rel and xmvn-builddep command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```
