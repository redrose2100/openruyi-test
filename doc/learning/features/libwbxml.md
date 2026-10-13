# libwbxml

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libwbxml` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libwbxml_wbxml2xml | The usage of commands in libwbxml package | pre_test/run_test/post_test | 74 | ✔ |  |  |
| oe_test_libwbxml_xml2wbxml | The usage of commands in libwbxml package | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libwbxml_wbxml2xml

- 描述：The usage of commands in libwbxml package
- 函数：`pre_test, run_test, post_test`
- 断言（74 条）：

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
  ... 共 74 条（其余见源脚本）
```

- 涉及命令：wbxml2xml×36, diff×2, test×2, xml2wbxml×1, grep×1

#### oe_test_libwbxml_xml2wbxml

- 描述：The usage of commands in libwbxml package
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
```

- 涉及命令：xml2wbxml×3, test×1
