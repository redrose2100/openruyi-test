# scala

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/scala` |
| 注册用例数 | 15 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_scala | verify the uasge of scala command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_scala_fsc_01 | verify the uasge of scala command | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_scala_fsc_02 | verify the uasge of scala command | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_scala_fsc_03 | verify the uasge of scala command | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_scala_fsc_04 | verify the uasge of scala command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_scala_scalac_01 | verify the uasge of scala command | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_scala_scalac_02 | verify the uasge of scala command | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_scala_scalac_03 | verify the uasge of scala command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_scala_scaladoc_01 | verify the uasge of scala command | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_scala_scaladoc_02 | verify the uasge of scala command | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_scala_scaladoc_03 | verify the uasge of scala command | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_scala_scaladoc_04 | verify the uasge of scala command | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_scala_scaladoc_05 | verify the uasge of scala command | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_scala_scaladoc_06 | verify the uasge of scala command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_scala_scalap | verify the uasge of scala command | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_scala

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check fsc -Dname failed"
  CHECK_RESULT $? 0 0 "Check fsc -nobootcp failed"
  CHECK_RESULT $? 0 0 "Check fsc -i failed"
  CHECK_RESULT $? 0 0 "Check fsc -server failed"
  CHECK_RESULT $? 0 0 "Check fsc -save failed"
  CHECK_RESULT $? 0 0 "Check fsc -J failed"
  CHECK_RESULT $? 0 0 "Check fsc -nc failed"
```

- 涉及命令：scala×7

#### oe_test_scala_fsc_01

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Check fsc -ipv4 failed"
  CHECK_RESULT $? 0 0 "Check test -max-idle failed"
  CHECK_RESULT $? 0 0 "Check test -port failed"
  CHECK_RESULT $? 0 0 "Check test -reset failed"
  CHECK_RESULT $? 0 0 "Check test -port failed"
  CHECK_RESULT $? 0 0 "Check test -reset failed"
  CHECK_RESULT $? 0 0 "Check test -Dproperty failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -X failed"
  CHECK_RESULT $? 0 0 "Check fsc -bootclasspath failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -classpath failed"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：fsc×12

#### oe_test_scala_fsc_02

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Check fsc -dependencyfile failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -deprecation failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -encoding failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -explaintypes failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -extdirs failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -feature failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：fsc×10

#### oe_test_scala_fsc_03

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Check fsc -no-specialization failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -nobootcp failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -nowarn failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -optimise failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -print failed"
  CHECK_RESULT $? 0 0 "Check fsc -sourcepath failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc target failed"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：fsc×10

#### oe_test_scala_fsc_04

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check fsc -verbose failed"
  CHECK_RESULT $? 0 0 "Check fsc -version failed"
  CHECK_RESULT $? 0 0 "Check fsc -port failed"
  CHECK_RESULT $? 0 0 "Check fsc -port failed"
  CHECK_RESULT $? 0 0 "Check fsc -server failed"
  CHECK_RESULT $? 0 0 "Check fsc @ failed"
  CHECK_RESULT $? 0 0 "Check fsc -toolcp failed"
  CHECK_RESULT $? 0 0 "Check fsc -toolcp failed"
  CHECK_RESULT $? 0 0 "Check fsc -javabootclasspath failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check fsc -P failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
```

- 涉及命令：fsc×9

#### oe_test_scala_scalac_01

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Check scalac -Dproperty failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -X failed"
  CHECK_RESULT $? 0 0 "Check scalac -bootclasspath failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -classpath failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -d failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -dependencyfile failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -deprecation failed"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：scalac×10

#### oe_test_scala_scalac_02

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Check scalac -feature failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -g:none failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -help failed"
  CHECK_RESULT $? 0 0 "Check scalac -javaextdirs failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -language:one failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -no-specialization failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -nobootcp failed"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：scalac×10

#### oe_test_scala_scalac_03

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check scalac -target:jvm-1.6 failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -toolcp failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -usejavacp failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac -verbose failed"
  CHECK_RESULT $? 0 0 "Check scalac -version failed"
  CHECK_RESULT $? 0 0 "Check scalac -save failed"
  CHECK_RESULT $? 0 0 "Check scalac -J-Xmx512m failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scalac @ failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：scalac×7

#### oe_test_scala_scaladoc_01

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Check scaladoc -diagrams failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -diagrams-dot-path failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -diagrams-dot-restart failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -diagrams-dot-timeout failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -diagrams-max-classes failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -diagrams-max-implicits failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：scaladoc×10

#### oe_test_scala_scaladoc_02

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Check scaladoc -doc-source-url  failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -doc-title failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -doc-version failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -expand-all-types  failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -groups failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -implicits  failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -implicits-show-all failed"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：scaladoc×10

#### oe_test_scala_scaladoc_03

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Check scaladoc -diagrams-debug failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -Dproperty failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -X failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -bootclasspath failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -classpath failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -d  failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：scaladoc×10

#### oe_test_scala_scaladoc_04

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Check scaladoc -encoding failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -explaintypes failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -extdirs failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -external-urls: failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -feature  failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -g:none failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：scaladoc×9

#### oe_test_scala_scaladoc_05

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "Check scaladoc  -no-specialization failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc  -nobootcp failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -nowarn failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -optimise failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -print failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -sourcepath failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：scaladoc×10

#### oe_test_scala_scaladoc_06

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check scaladoc -verbose failed"
  CHECK_RESULT $? 0 0 "Delete test file failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -version  failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -doc-no-compile failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -save failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -save failed"
  CHECK_RESULT $? 0 0 "Check scaladoc @ failed"
  CHECK_RESULT $? 0 0 "Check scaladoc -target failed"
```

- 涉及命令：scaladoc×6

#### oe_test_scala_scalap

- 描述：verify the uasge of scala command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check scalap -private failed"
  CHECK_RESULT $? 0 0 "Check scalap -verbose failed"
  CHECK_RESULT $? 0 0 "Check scalap -version failed"
  CHECK_RESULT $? 0 0 "Check scalap -help failed"
  CHECK_RESULT $? 0 0 "Check scalap -classpath failed"
  CHECK_RESULT $? 0 0 "Check scalap -cp failed"
```

- 涉及命令：scalap×6
