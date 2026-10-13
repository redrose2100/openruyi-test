# junit5

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/junit5` |
| 注册用例数 | 13 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_junit5_abnormal_removejar | Abnormal test, delete necessary jar | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_junit5_annotation_tag | Annotation test | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_junit5_annotation_timeout | Annotation Timeout test function performance | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_junit5_ant | Use with ant | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_junit5_assert | Assert test | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_junit5_epeat | Repeat testing, embedded unit testing | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_junit5_gradle | Run junit5 in gradle | pre_test/run_test/post_test | 3 | ✔ |  | 60m |
| oe_test_junit5_junit4 | Use in combination with junit4 | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_junit5_kotlin_maven | Used with maven to support kotlin programming language | pre_test/run_test/post_test | 4 |  |  | 60m |
| oe_test_junit5_maven | Run junit5 in maven | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_junit5_noimport | Unimport required classes such as org.junit.jupiter.api.Test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_junit5_parametric | Parametric test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_junit5_spring_maven | Use in combination with spring | pre_test/run_test/post_test | 2 | ✔ |  | 90m |

### 断言与命令明细

#### oe_test_junit5_abnormal_removejar

- 描述：Abnormal test, delete necessary jar
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $? 0 1
```

- 涉及命令：javac×2, java×2

#### oe_test_junit5_annotation_tag

- 描述：Annotation test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：javac×1, java×1

#### oe_test_junit5_annotation_timeout

- 描述：Annotation Timeout test function performance
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：javac×1, java×1

#### oe_test_junit5_ant

- 描述：Use with ant
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×2, ant×1

#### oe_test_junit5_assert

- 描述：Assert test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：javac×1, java×1

#### oe_test_junit5_epeat

- 描述：Repeat testing, embedded unit testing
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：javac×1, java×1

#### oe_test_junit5_gradle

- 描述：Run junit5 in gradle
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×2, gradle×1

#### oe_test_junit5_junit4

- 描述：Use in combination with junit4
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×2, mvn×1

#### oe_test_junit5_kotlin_maven

- 描述：Used with maven to support kotlin programming language
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×2, sed×1, mvn×1

#### oe_test_junit5_maven

- 描述：Run junit5 in maven
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×2, mvn×1

#### oe_test_junit5_noimport

- 描述：Unimport required classes such as org.junit.jupiter.api.Test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：javac×2, sed×2, java×1

#### oe_test_junit5_parametric

- 描述：Parametric test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：javac×1, java×1

#### oe_test_junit5_spring_maven

- 描述：Use in combination with spring
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：mkdir×2, mvn×1
