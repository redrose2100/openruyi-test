# mysql

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/mysql` |
| 注册用例数 | 10 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_mysql | Test mysql.service restart | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_mysql_innochecksum_001 | mysql-server command test | pre_test/run_test/post_test | 23 | ✔ |  |  |
| oe_test_mysql_timezone_001 | mysql-server command test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_mysql_mysqlshow_001 | mysql-server command test | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_mysql_ibd2sdi_001 | mysql-server command test | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_mysql_ssl_rsa_setup_001 | mysql-server command test | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_mysql_mysqlslap_001 | mysql-server command test | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_mysql_myisam_ftdump_001 | mysql-server command test | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_mysql_myisam_myisamchk_001 | mysql-server command test | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_mysql_secure_installation_001 | mysql-server command test | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_mysql

- 描述：Test mysql.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "${service} disable failed"
  CHECK_RESULT $? 0 0 "${service} enable failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "${service} reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_mysql_innochecksum_001

- 描述：mysql-server command test
- 函数：`pre_test, run_test, post_test`
- 断言（23 条）：

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
  ... 共 23 条（其余见源脚本）
```

- 涉及命令：innochecksum×4, mysql×4, test×2

#### oe_test_mysql_timezone_001

- 描述：mysql-server command test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_mysql_mysqlshow_001

- 描述：mysql-server command test
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

- 涉及命令：mysql×3, mysqlshow×2

#### oe_test_mysql_ibd2sdi_001

- 描述：mysql-server command test
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

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
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：mysql×3, ibd2sdi×3, test×1

#### oe_test_mysql_ssl_rsa_setup_001

- 描述：mysql-server command test
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

- 涉及命令：mysql_ssl_rsa_setup×5, mysql×1, sed×1

#### oe_test_mysql_mysqlslap_001

- 描述：mysql-server command test
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

- 涉及命令：mysql×5, test×2, mysqlslap×2

#### oe_test_mysql_myisam_ftdump_001

- 描述：mysql-server command test
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

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
```

- 涉及命令：myisam_ftdump×4, mysql×2

#### oe_test_mysql_myisam_myisamchk_001

- 描述：mysql-server command test
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

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
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：myisamchk×9, mysql×2

#### oe_test_mysql_secure_installation_001

- 描述：mysql-server command test
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

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
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：expect×9, grep×9, mysqladmin×1
