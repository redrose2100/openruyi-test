# libosinfo

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libosinfo` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_osinfo-detect | verify the uasge of osinfo-detect command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_osinfo-install-script | verify the uasge of osinfo-install-script command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_osinfo-query | verify the uasge of osinfo-query command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_osinfo-db-import | verify the uasge of osinfo-db-import command | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_osinfo-detect

- 描述：verify the uasge of osinfo-detect command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_osinfo-install-script

- 描述：verify the uasge of osinfo-install-script command
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

- 涉及命令：test×3

#### oe_test_osinfo-query

- 描述：verify the uasge of osinfo-query command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_osinfo-db-import

- 描述：verify the uasge of osinfo-db-import command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to import data"
  CHECK_RESULT $? 0 0 "Failed to export data"
  CHECK_RESULT $? 0 0 "Export file does not exist"
```

- 涉及命令：mkdir×1, test×1
