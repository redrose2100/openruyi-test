# mariadb

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/mariadb` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_mariadb | Test mariadb.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_mariadb-db | Test mongodb create | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_mariadb-table | Test mariadb table data | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_socket_mariadb-extra | Test mariadb-extra.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_socket_mariadb | Test mariadb.socket restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_mariadb

- 描述：Test mariadb.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of mariadb.service"
```

- 涉及命令：sed×1

#### oe_test_mariadb-db

- 描述：Test mongodb create
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "create db error"
  CHECK_RESULT $? 0 0 "create table error"
  CHECK_RESULT $? 0 1 "drop table error"
  CHECK_RESULT $? 0 1 "drop db error"
```

- 涉及命令：mysql×2, test×1

#### oe_test_mariadb-table

- 描述：Test mariadb table data
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "insert table error"
  CHECK_RESULT $? 0 0 "update table error"
  CHECK_RESULT $? 0 1 "delete table error"
```

- 涉及命令：mysql×2, test×1

#### oe_test_socket_mariadb-extra

- 描述：Test mariadb-extra.socket restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_socket_mariadb

- 描述：Test mariadb.socket restart
- 函数：`pre_test, run_test, post_test`