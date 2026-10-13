# testng

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/testng` |
| 注册用例数 | 13 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_testNG_annotations_assert | Assert related notes | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_testNG_annotations_before_after | Before and after related notes | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_testNG_annotations_common | Annotation Comprehensive Application | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_testNG_annotations_group | Group related notes | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_testNG_annotations_listen | Listen related notes | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_testNG_annotations_parameters | Parameter related notes | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_testNG_exception | testNG exception handling | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_testNG_retry | TestNG error case retry | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_testNG_thread | testNG multi-threaded processing | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_testNG_with_ant | testNG integration ant | config_params/pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_testNG_with_Junit | testNG integration Junit | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_testNG_with_maven | testNG integration maven | config_params/pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_testNG_with_spring | testNG integration spring | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_testNG_annotations_assert

- 描述：Assert related notes
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "java source code compilation failed."
  CHECK_RESULT $? 0 0 "testng execution use case failed."
```

- 涉及命令：javac×1, java×1

#### oe_test_testNG_annotations_before_after

- 描述：Before and after related notes
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "java source code compilation failed."
  CHECK_RESULT $? 0 0 "Use case execution failed."
```

- 涉及命令：javac×1, java×1

#### oe_test_testNG_annotations_common

- 描述：Annotation Comprehensive Application
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "java source code compilation failed."
  CHECK_RESULT $? 0 0 "testng execution use case failed."
```

- 涉及命令：javac×1, java×1

#### oe_test_testNG_annotations_group

- 描述：Group related notes
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "java source code compilation failed."
  CHECK_RESULT $? 0 0 "testng execution use case failed."
```

- 涉及命令：javac×1, java×1

#### oe_test_testNG_annotations_listen

- 描述：Listen related notes
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "IHookableImp.java source code compilation failed."
  CHECK_RESULT $? 0 0 "TExpListern.java source code compilation failed."
  CHECK_RESULT $? 0 0 "testng execution use case failed."
```

- 涉及命令：javac×2, java×1

#### oe_test_testNG_annotations_parameters

- 描述：Parameter related notes
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "java source code compilation failed."
  CHECK_RESULT $? 0 0 "testng execution use case failed."
```

- 涉及命令：javac×1, java×1

#### oe_test_testNG_exception

- 描述：testNG exception handling
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "java source code compilation failed."
  CHECK_RESULT $? 0 0 "testng execution use case failed."
```

- 涉及命令：java×1

#### oe_test_testNG_retry

- 描述：TestNG error case retry
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "java source code compilation failed."
  CHECK_RESULT $? 0 0 "testng execution use case failed"
```

- 涉及命令：java×2

#### oe_test_testNG_thread

- 描述：testNG multi-threaded processing
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "java source code compilation failed."
  CHECK_RESULT $? 0 0 "testng execution use case failed,The xml file is TExpTh1.xml"
  CHECK_RESULT $? 0 0 "testng execution use case failed,The xml is TExpTh2.xml"
  CHECK_RESULT $? 0 0 "testng execution use case failed,The xml is TExpTh3.xml"
  CHECK_RESULT $? 0 0 "testng execution use case failed,The xml is TExpTh4.xml"
  CHECK_RESULT $? 0 0 "testng execution use case failed,The xml is TExpTh6.xml"
  CHECK_RESULT $? 0 0 "testng execution use case failed,The xml is TExpTh5.xml"
  CHECK_RESULT $? 0 0 "testng execution use case failed,The xml is TExpTh7.xml"
```

- 涉及命令：java×7

#### oe_test_testNG_with_ant

- 描述：testNG integration ant
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "testng execution use case failed."
```

- 涉及命令：mkdir×3, ant×1

#### oe_test_testNG_with_Junit

- 描述：testNG integration Junit
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "java source code compilation failed."
  CHECK_RESULT $? 0 0 "testng execution use case failed."
```

- 涉及命令：java×1

#### oe_test_testNG_with_maven

- 描述：testNG integration maven
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "mvn -f failed."
  CHECK_RESULT $? 0 0 "testng execution use case failed."
```

- 涉及命令：mkdir×3, mvn×1

#### oe_test_testNG_with_spring

- 描述：testNG integration spring
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "User.java source code compilation failed."
```
