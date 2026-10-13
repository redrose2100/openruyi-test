# swig

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/swig` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_swig_01 | The usage of commands in swig package | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_swig_02 | The usage of commands in swig package | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_swig_03 | The usage of commands in swig package | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_swig_04 | The usage of commands in swig package | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_swig_05 | The usage of commands in swig package | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_swig_06 | The usage of commands in swig package | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_swig_07 | The usage of commands in swig package | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_swig_08 | The usage of commands in swig package | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_swig_09 | The usage of commands in swig package | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_swig_10 | The usage of commands in swig package | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_swig_11 | The usage of commands in swig package | pre_test/run_test/post_test | 15 | ✔ |  |  |

### 断言与命令明细

#### oe_test_swig_01

- 描述：The usage of commands in swig package
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

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
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：swig×9, test×9

#### oe_test_swig_02

- 描述：The usage of commands in swig package
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

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
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：swig×9, test×9

#### oe_test_swig_03

- 描述：The usage of commands in swig package
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

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
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：swig×9, test×5, grep×1

#### oe_test_swig_04

- 描述：The usage of commands in swig package
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

- 涉及命令：swig×9

#### oe_test_swig_05

- 描述：The usage of commands in swig package
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

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
  CHECK_RESULT $? 1
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：swig×9, grep×4

#### oe_test_swig_06

- 描述：The usage of commands in swig package
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
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
  CHECK_RESULT $?
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：swig×9, grep×7, test×1

#### oe_test_swig_07

- 描述：The usage of commands in swig package
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：swig×9, test×3, grep×3

#### oe_test_swig_08

- 描述：The usage of commands in swig package
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：swig×9, grep×3

#### oe_test_swig_09

- 描述：The usage of commands in swig package
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

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
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：swig×9, grep×6, test×1

#### oe_test_swig_10

- 描述：The usage of commands in swig package
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
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
  CHECK_RESULT $? 0 1
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：swig×9, test×3, grep×2, diff×1

#### oe_test_swig_11

- 描述：The usage of commands in swig package
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
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
  CHECK_RESULT $? 1
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：swig×8, grep×4, sed×1
