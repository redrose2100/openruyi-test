# groovy

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/groovy` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_groovy_01 | verification groovy's commnd | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_groovy_02 | verification groovy's commnd | pre_test/run_test/post_test | 18 | ✔ |  |  |

### 断言与命令明细

#### oe_test_groovy_01

- 描述：verification groovy's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check grape help failed."
  CHECK_RESULT $? 0 0 "Check grape --help failed."
  CHECK_RESULT $? 0 0 "Check grape -v failed."
  CHECK_RESULT $? 0 0 "Check grape list failed."
  CHECK_RESULT $? 0 0 "Check groovyConsole --help failed."
  CHECK_RESULT $? 0 0 "Check groovy --help failed."
  CHECK_RESULT $? 0 0 "Check groovy -v failed."
  CHECK_RESULT $? 0 0 "Check groovy -e failed."
  CHECK_RESULT $? 0 0 "Check groovy -e failed."
  CHECK_RESULT $? 0 0 "Check groovyc --help failed."
  CHECK_RESULT $?
  CHECK_RESULT $? 0 0 "Check groovysh failed."
```

- 涉及命令：groovy×3, grape×1, groovyc×1

#### oe_test_groovy_02

- 描述：verification groovy's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Check groovyc -d failed."
  CHECK_RESULT $? 0 0 "Check groovyc -d failed."
  CHECK_RESULT $? 0 0 "Check groovyc failed."
  CHECK_RESULT $? 0 0 "Check groovyc -e failed."
  CHECK_RESULT $? 0 0 "Check groovyc -e failed."
  CHECK_RESULT $? 0 0 "Check groovyc -cp failed."
  CHECK_RESULT $? 0 0 "Check groovyc -cp failed."
  CHECK_RESULT $? 0 0 "Check groovyc --encoding failed."
  CHECK_RESULT $? 0 0 "Check groovyc --encoding failed."
  CHECK_RESULT $? 0 0 "Check groovyc --indy failed."
  CHECK_RESULT $? 0 0 "Check test.class not exist."
  CHECK_RESULT $? 0 0 "Check groovy failed."
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：test×7, groovyc×3, groovydoc×1
