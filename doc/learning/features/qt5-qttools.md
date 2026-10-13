# qt5-qttools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/qt5-qttools` |
| 注册用例数 | 12 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_qt5-qttools_lconvert-qt5 | The usage of commands in qt5-linguist binary package | pre_test/run_test/post_test | 26 | ✔ |  |  |
| oe_test_qt5-qttools_lrelease-qt5 | The usage of commands in qt5-linguist binary package | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_qt5-qttools_lupdate-qt5_01 | The usage of commands in qt5-linguist binary package | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_qt5-qttools_lupdate-qt5_02 | The usage of commands in qt5-linguist binary package | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_qt5-qttools_qdbus-qt5 | The usage of commands in qt5-qttools package | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_qt5-qttools_qdoc_01 | The usage of commands in qt5-doctools binary package | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_qt5-qttools_qdoc_02 | The usage of commands in qt5-doctools binary package | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_qt5-qttools_qdoc_03 | The usage of commands in qt5-doctools binary package | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_qt5-qttools_qhelpgenerator-qt5 | The usage of commands in qt5-doctools binary package | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_qt5-qttools_qt5-qttools-devel | The usage of commands in qt5-qttools-devel binary package | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_qt5-qttools_qtattributionsscanner-qt5 | The usage of commands in qt5-doctools binary package | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_qt5-qttools_qtpaths | The usage of commands in qt5-qttools package | pre_test/run_test/post_test | 16 | ✔ |  |  |

### 断言与命令明细

#### oe_test_qt5-qttools_lconvert-qt5

- 描述：The usage of commands in qt5-linguist binary package
- 函数：`pre_test, run_test, post_test`
- 断言（26 条）：

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
  ... 共 26 条（其余见源脚本）
```

- 涉及命令：lconvert-qt5×14, grep×3

#### oe_test_qt5-qttools_lrelease-qt5

- 描述：The usage of commands in qt5-linguist binary package
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

- 涉及命令：lrelease-qt5×7, grep×1, test×1

#### oe_test_qt5-qttools_lupdate-qt5_01

- 描述：The usage of commands in qt5-linguist binary package
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：lupdate-qt5×9, grep×3, mkdir×1

#### oe_test_qt5-qttools_lupdate-qt5_02

- 描述：The usage of commands in qt5-linguist binary package
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $?
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
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：lupdate-qt5×8, test×1

#### oe_test_qt5-qttools_qdbus-qt5

- 描述：The usage of commands in qt5-qttools package
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_qt5-qttools_qdoc_01

- 描述：The usage of commands in qt5-doctools binary package
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

- 涉及命令：grep×4, qdoc×3, test×1

#### oe_test_qt5-qttools_qdoc_02

- 描述：The usage of commands in qt5-doctools binary package
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

- 涉及命令：test×5, grep×2

#### oe_test_qt5-qttools_qdoc_03

- 描述：The usage of commands in qt5-doctools binary package
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

- 涉及命令：test×2, grep×1

#### oe_test_qt5-qttools_qhelpgenerator-qt5

- 描述：The usage of commands in qt5-doctools binary package
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
```

- 涉及命令：test×2, qhelpgenerator-qt5×1

#### oe_test_qt5-qttools_qt5-qttools-devel

- 描述：The usage of commands in qt5-qttools-devel binary package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：qtplugininfo-qt5×4, qcollectiongenerator-qt5×2, grep×1

#### oe_test_qt5-qttools_qtattributionsscanner-qt5

- 描述：The usage of commands in qt5-doctools binary package
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：qtattributionsscanner-qt5×2, test×1

#### oe_test_qt5-qttools_qtpaths

- 描述：The usage of commands in qt5-qttools package
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
  CHECK_RESULT $?
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：qtpaths×2, mkdir×1, test×1
