# php

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/php` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_phar | verify the uasge of phar and phar.phar command | pre_test/run_test/post_test | 56 | ✔ |  |  |
| oe_test_phar_phar | verify the uasge of phar.phar command | pre_test/run_test/post_test | 56 | ✔ |  |  |
| oe_test_php | verify the uasge of php command | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_php-cgi_phpize | verify the uasge of php-cgi and phpize command | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_php-config | verify the uasge of php-config command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_phpdbg | verify the uasge of php-dbg command | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_php-fpm | verify the uasge of php-fpm command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_service_php-fpm | Test php-fpm.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_php_001 | Use php case | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_phar

- 描述：verify the uasge of phar and phar.phar command
- 函数：`pre_test, run_test, post_test`
- 断言（56 条）：

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
  ... 共 56 条（其余见源脚本）
```

- 涉及命令：test×5, sed×2

#### oe_test_phar_phar

- 描述：verify the uasge of phar.phar command
- 函数：`pre_test, run_test, post_test`
- 断言（56 条）：

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
  ... 共 56 条（其余见源脚本）
```

- 涉及命令：test×5, sed×2

#### oe_test_php

- 描述：verify the uasge of php command
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

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
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：php×14

#### oe_test_php-cgi_phpize

- 描述：verify the uasge of php-cgi and phpize command
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

- 涉及命令：php-cgi×13

#### oe_test_php-config

- 描述：verify the uasge of php-config command
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

#### oe_test_phpdbg

- 描述：verify the uasge of php-dbg command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_php-fpm

- 描述：verify the uasge of php-fpm command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：php-fpm×3

#### oe_test_service_php-fpm

- 描述：Test php-fpm.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "php-fpm.service reload failed"
  CHECK_RESULT $? 0 0 "php-fpm.service reload causes the service status to change"
```

- 涉及命令：sed×2

#### oe_test_php_001

- 描述：Use php case
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Error,Fail to create hello.php"
  CHECK_RESULT $? 0 0 "Error,check hello.php"
```
