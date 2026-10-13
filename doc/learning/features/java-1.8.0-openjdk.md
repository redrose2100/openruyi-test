# java-1.8.0-openjdk

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/java-1.8.0-openjdk` |
| 注册用例数 | 12 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_logstash_install | logstash install test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_openjdk_appletviewer_clhsdb | verification openjdk‘s command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_openjdk_javadoc_javah | verification openjdk‘s command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_openjdk_java_javac | verification openjdk‘s command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_openjdk_javap_jcmd | verification openjdk‘s command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_openjdk_jdb_jdeps | verification openjdk‘s command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_openjdk_jjs_jmap | verification openjdk‘s command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_openjdk_jsadebugd_jstack | verification openjdk‘s command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_openjdk_native2ascii_pack200 | verification openjdk‘s command | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_openjdk_rmic_rmid | verification openjdk‘s command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_openjdk_servertool_unpack200 | verification openjdk‘s command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_java | Use java case | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_logstash_install

- 描述：logstash install test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Tar file failed"
  CHECK_RESULT $? 0 0 "Test failed"
```

- 涉及命令：wget×1, tar×1

#### oe_test_openjdk_appletviewer_clhsdb

- 描述：verification openjdk‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：idlj×2, appletviewer×1, jar×1, jarsigner×1

#### oe_test_openjdk_javadoc_javah

- 描述：verification openjdk‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：javadoc×5, javah×3

#### oe_test_openjdk_java_javac

- 描述：verification openjdk‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：javac×4, java×3

#### oe_test_openjdk_javap_jcmd

- 描述：verification openjdk‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：javap×7, jcmd×2

#### oe_test_openjdk_jdb_jdeps

- 描述：verification openjdk‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：jdeps×2, jhat×2, jdb×1, expect×1, jinfo×1

#### oe_test_openjdk_jjs_jmap

- 描述：verification openjdk‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(jrunscript run.js arg1 arg2 arg3 | grep -icE 'arg1|arg2|arg3')" 3
  CHECK_RESULT $? 1
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：expect×3, jrunscript×2, jjs×1, grep×1, jmap×1, jps×1

#### oe_test_openjdk_jsadebugd_jstack

- 描述：verification openjdk‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：keytool×3, jstack×2, jstat×2, kill×2, jstatd×2, jsadebugd×1, jps×1

#### oe_test_openjdk_native2ascii_pack200

- 描述：verification openjdk‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：native2ascii×2, pack200×2

#### oe_test_openjdk_rmic_rmid

- 描述：verification openjdk‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rmid×3, schemagen×3, rmic×1, rmiregistry×1

#### oe_test_openjdk_servertool_unpack200

- 描述：verification openjdk‘s command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：xjc×3, wsgen×2, wsimport×2, expect×1, unpack200×1

#### oe_test_java

- 描述：Use java case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Fail to create HelloWorld.java"
  CHECK_RESULT $? 0 0 "Error,fail to create helloworld"
  CHECK_RESULT $? 0 0 "Error,Check the content of the 'Java' installation package or 'helloworld' file"
```
