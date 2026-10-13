# java-11-openjdk

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/java-11-openjdk` |
| 注册用例数 | 12 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_java | Use java case | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_openjdk11_javac | verification openjdk11 | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_openjdk11_javadoc | verification openjdk11 | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_openjdk11_javap | verification openjdk11 command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_openjdk11_jdb_jdeps | verification openjdk11 command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_openjdk11_jjs_jmap | verification openjdk11 command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_openjdk11_jstack | verification openjdk11 command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_openjdk11_pack200 | verification openjdk11 command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_openjdk11_rmid | verification openjdk11 command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_openjdk11_unpack200 | verification openjdk11 command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_openjdk11_jfr_jinfo | verification openjdk11 command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_openjdk11_jcmd_jstat | verification openjdk11 command | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_java

- 描述：Use java case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Fail to create Hello.java"
  CHECK_RESULT $? 0 0 "Error,fail to create helloworld"
  CHECK_RESULT $? 0 0 "Error,check the 'Java' installation package or 'helloworld' file"
```

#### oe_test_openjdk11_javac

- 描述：verification openjdk11
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "java -h failed"
  CHECK_RESULT $? 0 0 "java Hello failed"
  CHECK_RESULT $? 0 0 "java -version failed"
  CHECK_RESULT $? 0 0 "javac -g failed"
  CHECK_RESULT $? 0 0 "not find Hello.class"
  CHECK_RESULT $? 0 0 "javac -hellp failed"
  CHECK_RESULT $? 0 0 "javac -version failed"
  CHECK_RESULT $? 0 0 "javac -nowarn failed"
```

- 涉及命令：javac×4, java×3

#### oe_test_openjdk11_javadoc

- 描述：verification openjdk11
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "javadoc -help failed"
  CHECK_RESULT $? 0 0 "javad -public failed"
  CHECK_RESULT $? 0 0 "find  public failed"
  CHECK_RESULT $? 0 0 "javadoc -protected failed"
  CHECK_RESULT $? 0 0 "find protected failed"
  CHECK_RESULT $? 0 0 "javadoc -private"
  CHECK_RESULT $? 0 0 "find private failed"
  CHECK_RESULT $? 0 0 "javadoc -package failed"
  CHECK_RESULT $? 0 0 "find package failed"
```

- 涉及命令：javadoc×5

#### oe_test_openjdk11_javap

- 描述：verification openjdk11 command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "javap -help failed"
  CHECK_RESULT $? 0 0 "javap -version failed"
  CHECK_RESULT $? 0 0 "javap  public failed"
  CHECK_RESULT $? 0 0 "javap -protected failed"
  CHECK_RESULT $? 0 0 "javap -package failed"
  CHECK_RESULT $? 0 0 "javap -private failed"
  CHECK_RESULT $? 0 0 "javap -p -v failed"
```

- 涉及命令：javap×7

#### oe_test_openjdk11_jdb_jdeps

- 描述：verification openjdk11 command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "jdb -help failed"
  CHECK_RESULT $? 0 0 "javac Hello.java failed"
  CHECK_RESULT $? 0 0 "no find common list"
  CHECK_RESULT $? 0 0 "no find VM Start"
  CHECK_RESULT $? 0 0 "no find Hello,world"
  CHECK_RESULT $? 0 0 "jdeps -help failed"
  CHECK_RESULT $? 0 0 "jdeps -version failed"
```

- 涉及命令：jdeps×2, jdb×1, expect×1

#### oe_test_openjdk11_jjs_jmap

- 描述：verification openjdk11 command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "jjs -help failed"
  CHECK_RESULT $? 0 0 "testlog1 is defined"
  CHECK_RESULT $? 0 0 "jmap -h failed"
  CHECK_RESULT $? 0 0 "jps -version failed"
  CHECK_RESULT $? 0 0 "jps -help failed"
```

- 涉及命令：jjs×1, expect×1, jmap×1, jps×1

#### oe_test_openjdk11_jstack

- 描述：verification openjdk11 command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "jstack -h failed"
  CHECK_RESULT $? 0 0 "jstack -m failed"
  CHECK_RESULT $? 0 0 "jstat -help failed"
  CHECK_RESULT $? 0 0 "jstat -gc failed"
  CHECK_RESULT $? 0 0 "kill jstack_pid failed"
```

- 涉及命令：jstack×2, jstat×2, kill×1

#### oe_test_openjdk11_pack200

- 描述：verification openjdk11 command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "pack200  -help failed"
  CHECK_RESULT $? 0 0 "pack200 --version failed"
  CHECK_RESULT $? 0 0 "jar cvf failed"
  CHECK_RESULT $? 0 0 "not find Hello.jar"
  CHECK_RESULT $? 0 0 "pack200 Hello.jar.pack.gz failed"
  CHECK_RESULT $? 0 0 "not find Hello.jar.pack.gz"
  CHECK_RESULT $? 0 0 "unpack200 failed"
  CHECK_RESULT $? 0 0 "not find Hello.jar"
  CHECK_RESULT $? 0 0 "pack -q failed"
  CHECK_RESULT $? 0 0 "not find Hello.jar.pack.gz"
```

- 涉及命令：pack200×2

#### oe_test_openjdk11_rmid

- 描述：verification openjdk11 command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "expect usage, failed"
  CHECK_RESULT $? 0 0 "rmid -stop -port failed"
  CHECK_RESULT $? 0 0 "not find portlog"
```

- 涉及命令：rmid×2

#### oe_test_openjdk11_unpack200

- 描述：verification openjdk11 command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "unpack200  -help failed"
  CHECK_RESULT $? 0 0 "unpack200 --version failed"
```

- 涉及命令：unpack200×1

#### oe_test_openjdk11_jfr_jinfo

- 描述：verification openjdk11 command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "jfr --help failed"
  CHECK_RESULT $? 0 0 "jfr --version failed"
  CHECK_RESULT $? 0 0 "jinfo -h failed"
```

- 涉及命令：jinfo×1

#### oe_test_openjdk11_jcmd_jstat

- 描述：verification openjdk11 command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "jcmd -h failed"
  CHECK_RESULT $? 0 0 "jcmd -l failed"
  CHECK_RESULT $? 0 0 "jstat -h failed"
```

- 涉及命令：jcmd×2, jstat×1
