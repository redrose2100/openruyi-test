# nss

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nss` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nss | Test nslcd.service restart | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_nss-config | test nss-devel | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_nss-softokn-devel | test nss-softokn-devel | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_nss

- 描述：Test nslcd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to create the certificate database."
  CHECK_RESULT $? 0 0 "Failed to create a root certificate"
  CHECK_RESULT $? 0 0 "Failed to create an issuing certificate"
```

- 涉及命令：certutil×6

#### oe_test_nss-config

- 描述：test nss-devel
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Error retrieving library file"
  CHECK_RESULT $? 0 0 "Error in obtaining version command"
  CHECK_RESULT $? 0 0 "Error in obtaining flags"
  CHECK_RESULT $? 0 0 "Error getting library file directory"
  CHECK_RESULT $? 0 0 "Error in obtaining display header file"
  CHECK_RESULT $? 0 0 "Error getting prefix for displaying executable file installation directory"
  CHECK_RESULT $? 0 0 "Error getting installation prefix path"
  CHECK_RESULT $? 0 0 "Error getting specified library link parameters"
```

#### oe_test_nss-softokn-devel

- 描述：test nss-softokn-devel
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Error retrieving library file"
  CHECK_RESULT $? 0 0 "Error in obtaining version command"
  CHECK_RESULT $? 0 0 "Error in obtaining flags"
  CHECK_RESULT $? 0 0 "Error getting library file directory"
  CHECK_RESULT $? 0 0 "Error in obtaining display header file"
  CHECK_RESULT $? 0 0 "Error getting prefix for displaying executable file installation directory"
```
