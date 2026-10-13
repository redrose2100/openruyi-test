# objectweb-asm3

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/objectweb-asm3` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_objectweb-asm3-processor | verify the uasge of objectweb-asm3 command | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_objectweb-asm3-processor_01 | test objectweb-asm3-processor | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_objectweb-asm3-processor

- 描述：verify the uasge of objectweb-asm3 command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check java -classpath asm.jar:asm-util.jar org.objectweb.asm.util.TraceClassVisitor java.lang.Void failed"
```

- 涉及命令：java×1

#### oe_test_objectweb-asm3-processor_01

- 描述：test objectweb-asm3-processor
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Error converting bytecode from code format to XML format"
  CHECK_RESULT $? 0 0 "Error converting bytecode from XML format to code format"
  CHECK_RESULT $? 0 0 "Error converting bytecode from XML format to a single XML format"
```
