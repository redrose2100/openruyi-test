# cmake

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/cmake` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ccmake | verify the uasge of ccmake command | pre_test/run_test/post_test | 17 |  |  |  |
| oe_test_ccmake3 | verify the uasge of ccmake3 command | pre_test/run_test/post_test | 17 |  |  |  |
| oe_test_cmake | verify the uasge of cmake command | pre_test/run_test/post_test | 36 |  |  |  |
| oe_test_cmake3 | verify the uasge of cmake3 command | pre_test/run_test/post_test | 36 |  |  |  |
| oe_test_cpack | verify the uasge of cpack command | pre_test/run_test/post_test | 30 |  |  |  |
| oe_test_cpack3 | verify the uasge of cpack3 command | pre_test/run_test/post_test | 30 |  |  |  |
| oe_test_ctest | verify the uasge of ctest command | pre_test/run_test/post_test | 35 |  |  |  |
| oe_test_ctest3 | verify the uasge of ctest3 command | pre_test/run_test/post_test | 35 |  |  |  |

### 断言与命令明细

#### oe_test_ccmake

- 描述：verify the uasge of ccmake command
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

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
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：test×12, ccmake×2

#### oe_test_ccmake3

- 描述：verify the uasge of ccmake3 command
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

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
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：test×12, ccmake3×2

#### oe_test_cmake

- 描述：verify the uasge of cmake command
- 函数：`pre_test, run_test, post_test`
- 断言（36 条）：

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
  ... 共 36 条（其余见源脚本）
```

- 涉及命令：test×18, cmake×13

#### oe_test_cmake3

- 描述：verify the uasge of cmake3 command
- 函数：`pre_test, run_test, post_test`
- 断言（36 条）：

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
  ... 共 36 条（其余见源脚本）
```

- 涉及命令：test×18, cmake3×13

#### oe_test_cpack

- 描述：verify the uasge of cpack command
- 函数：`pre_test, run_test, post_test`
- 断言（30 条）：

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
  ... 共 30 条（其余见源脚本）
```

- 涉及命令：test×11, cpack×7, grep×3

#### oe_test_cpack3

- 描述：verify the uasge of cpack3 command
- 函数：`pre_test, run_test, post_test`
- 断言（30 条）：

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
  ... 共 30 条（其余见源脚本）
```

- 涉及命令：test×11, cpack3×5, grep×3, cpack×2

#### oe_test_ctest

- 描述：verify the uasge of ctest command
- 函数：`pre_test, run_test, post_test`
- 断言（35 条）：

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
  ... 共 35 条（其余见源脚本）
```

- 涉及命令：ctest×8, test×4, grep×1

#### oe_test_ctest3

- 描述：verify the uasge of ctest3 command
- 函数：`pre_test, run_test, post_test`
- 断言（35 条）：

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
  ... 共 35 条（其余见源脚本）
```

- 涉及命令：ctest3×8, test×4, grep×1
