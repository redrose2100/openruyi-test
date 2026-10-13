# java-17-openjdk

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/java-17-openjdk` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_keytool | Verify the usage of the keytool command | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_openjdk17_javadoc | verification openjdk17 | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_keytool

- 描述：Verify the usage of the keytool command
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check option : --help"
  CHECK_RESULT $? 0 0 "Failed to check option : -h"
  CHECK_RESULT $? 0 0 "Failed to check option : -?"
  CHECK_RESULT $? 0 0 "Failed to create mykeystore.jks keystore file."
  CHECK_RESULT $? 0 0 "Failed to create mykeystore2.jks keystore file."
  CHECK_RESULT $? 0 0 "Failed to view the contents of the mykeystore.jks keystore."
  CHECK_RESULT $? 0 0 "Failed to view the contents of the mykeystore2.jks keystore."
  CHECK_RESULT $? 0 0 "Failed to export cert from keystore."
  CHECK_RESULT $? 0 0 "Failed to create mycert.cer file."
  CHECK_RESULT $? 0 0 "Failed to delete keystore file."
  CHECK_RESULT $? 0 0 "Failed to verify that the keystore contents are empty."
  CHECK_RESULT $? 0 0 "Certificate import failed."
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：keytool×14, test×3, grep×1

#### oe_test_openjdk17_javadoc

- 描述：verification openjdk17
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
