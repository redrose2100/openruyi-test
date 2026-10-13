# pkgship_start_init

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/pkgship/pkgship_start_init` |
| 注册用例数 | 65 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pkgship_autostart_01 | Pkgship auto start | run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_autostart_02 | Pkgship auto start when reboot | pre_test/run_test/post_test | 3 |  | ✔ |  |
| oe_test_pkgship_check_client | Set pkgship server and check by client | pre_test/run_test/post_test | 8 | ✔ | ✔ |  |
| oe_test_pkgship_dbs_1 | Take the test pkgship list command | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_dbs_2 | Take the test pkgship list command | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_help | Pkgship items normal function test | run_test/post_test | 9 |  |  |  |
| oe_test_pkgship_init_exception_01 | Pkgship items normal function test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_init_exception_02 | Pkgship items normal function test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_init_exception_03 | Pkgship items normal function test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_init_exception_04 | Pkgship items normal function test | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pkgship_init_exception_05 | Pkgship items normal function test | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pkgship_init_exception_06 | Pkgship items normal function test | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pkgship_init_exception_07 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_init_exception_08 | Pkgship items normal function test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_init_exception_09 | Pkgship items normal function test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_init_exception_10 | Pkgship items normal function test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_install_service_check | Pkgship items normal function test | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_pkgship_loop_init | Pkgship items normal function test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_loop_restart | Pkgship items normal function test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_loop_install | Pkgship items normal function test | pre_test/run_test/post_test | 1 |  |  | 60m |
| oe_test_pkgship_remote | Pkgship items normal function test | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pkgship_service_start | Pkgship auto start | run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_start_exception_01 | Pkgship items normal function test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_start_exception_02 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_exception_03 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_exception_04 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_exception_05 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_start_exception_06 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_start_exception_07 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_exception_08 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_start_exception_09 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_start_exception_10 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_start_exception_11 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_start_exception_12 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_start_exception_13 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_start_exception_14 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_start_exception_15 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_start_exception_16 | Pkgship items normal function test | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_pkgship_start_exception_17 | Pkgship items normal function test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_start_exception_18 | Pkgship items normal function test | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_pkgship_start_exception_19 | Pkgship items normal function test | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_pkgship_start_exception_20 | Pkgship items normal function test | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_pkgship_start_exception_21 | Pkgship items normal function test | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pkgship_start_exception_22 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_exception_23 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_exception_24 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_exception_25 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_exception_26 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_exception_27 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_exception_28 | Pkgship items normal function test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_start_exception_29 | Pkgship items normal function test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_start_exception_30 | Pkgship items normal function test | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pkgship_start_exception_31 | Pkgship items normal function test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pkgship_start_exception_32 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_exception_33 | Pkgship items normal function test | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pkgship_start_exception_34 | Pkgship items normal function test | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_pkgship_start_exception_35 | Pkgship items normal function test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_start_init_1 | Pkgship items normal function test | pre_test/run_test/post_test | 3 |  |  |  |
| oe_test_pkgship_start_init_2 | Pkgship items normal function test | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pkgship_start_init_3 | Pkgship items normal function test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_start_init_4 | Pkgship items normal function test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_start_init_5 | Pkgship items normal function test | pre_test/run_test/post_test | 2 |  |  |  |
| oe_test_pkgship_version | Pkgship items normal function test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_install_fail_01 | Pkgship install test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pkgship_install_fail_02 | Pkgship install test | pre_test/run_test/post_test | 1 |  |  |  |

### 断言与命令明细

#### oe_test_pkgship_autostart_01

- 描述：Pkgship auto start
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "systemctl start pkgship failed."
  CHECK_RESULT $? 0 0 "pkgship auto start failed."
  CHECK_RESULT $? 0 0 "systemctl stop pkgship failed."
  CHECK_RESULT $? 0 0 "pkgship close failed."
```

- 涉及命令：kill×1

#### oe_test_pkgship_autostart_02

- 描述：Pkgship auto start when reboot
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Set pkgship auto start failed."
  CHECK_RESULT $? 0 0 "pkgship start failed after reboot."
  CHECK_RESULT $? 0 0 "pkgship start unexpectly after reboot."
```

#### oe_test_pkgship_check_client

- 描述：Set pkgship server and check by client
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Create pkgship server failed."
  CHECK_RESULT $? 0 0 "Check pkgship dbs -remote failed."
  CHECK_RESULT $? 0 0 "Check pkgship list openEuler -remote failed."
  CHECK_RESULT $? 0 0 "Check pkgship pkginfo Judy openeuler -remote failed."
  CHECK_RESULT $? 0 0 "Check pkgship installdep Judy -remote failed."
  CHECK_RESULT $? 0 0 "Check pkgship builddep Judy -remote failed."
  CHECK_RESULT $? 0 0 "Check pkgship selfdepend Judy -remote failed."
  CHECK_RESULT $? 0 0 "Check pkgship bedepend openeuler Judy -remote failed."
```

- 涉及命令：pkgship×7, sed×3

#### oe_test_pkgship_dbs_1

- 描述：Take the test pkgship list command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check dbs failed."
```

- 涉及命令：sed×2

#### oe_test_pkgship_dbs_2

- 描述：Take the test pkgship list command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check dbs failed."
```

- 涉及命令：sed×2

#### oe_test_pkgship_help

- 描述：Pkgship items normal function test
- 函数：`run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "The help message of pkgship is error."
  CHECK_RESULT $? 0 0 "The help message of pkgship init is error."
  CHECK_RESULT $? 0 0 "The help message of pkgship list is error."
  CHECK_RESULT $? 0 0 "The help message of pkgship pkginfo is error."
  CHECK_RESULT $? 0 0 "The help message of pkgship buildep is error."
  CHECK_RESULT $? 0 0 "The help message of pkgship installdep is error."
  CHECK_RESULT $? 0 0 "The help message of pkgship selfdepend is error."
  CHECK_RESULT $? 0 0 "The help message of pkgship bedpend is error."
  CHECK_RESULT $? 0 0 "The help message of pkgship dbs is error."
```

- 涉及命令：pkgship×1

#### oe_test_pkgship_init_exception_01

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check init while set file as package.ini unexpectly."
  CHECK_RESULT $? 0 0 "Check init while set file as empty.yaml unexpectly."
  CHECK_RESULT $? 0 0 "Check init while set file as over.yaml unexpectly."
  CHECK_RESULT $? 0 0 "Check init while set file as duplicate.ini unexpectly."
```

#### oe_test_pkgship_init_exception_02

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Execute cmd unexpectly."
```

#### oe_test_pkgship_init_exception_03

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Execute cmd unexpectly."
```

#### oe_test_pkgship_init_exception_04

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Init while dbname is empty unexpectly."
  CHECK_RESULT $? 0 0 "Init while dbname is too long unexpectly."
  CHECK_RESULT $? 0 0 "Init while dbname is lower&upper unexpectly."
  CHECK_RESULT $? 0 0 "Init while dbname is deleted unexpectly."
  CHECK_RESULT $? 0 0 "Init while dbname is lower&upper unexpectly."
```

- 涉及命令：sed×2

#### oe_test_pkgship_init_exception_05

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Init unexpectly or mesg error when set src_db_file=''."
  CHECK_RESULT $? 0 0 "Init unexpectly or mesg error when set src_db_file=${para[$i]}."
  CHECK_RESULT $? 0 0 "Init unexpectly or mesg error when set src_db_file=${SYS_CONF_PATH}/package.ini."
  CHECK_RESULT $? 0 0 "Init unexpectly or mesg error when set SRC_DB_FILE."
  CHECK_RESULT $? 0 0 "Init unexpectly or mesg error when delete src_db_file."
```

- 涉及命令：sed×2

#### oe_test_pkgship_init_exception_06

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check init msg failed when set bin_db_file=${para[$i]}"
  CHECK_RESULT $? 0 0 "Check init msg failed when set bin_db_file=/etc/pkgship/package.ini"
  CHECK_RESULT $? 0 0 "Check init msg failed when set bin_db_file empty"
  CHECK_RESULT $? 0 0 "Check init msg failed when set bin_db_file as BIN_DB_FILE"
  CHECK_RESULT $? 0 0 "Check init msg failed when delete bin_db_file"
```

- 涉及命令：sed×2

#### oe_test_pkgship_init_exception_07

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check init msg failed when set priority = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check init msg failed when set priority =''."
  CHECK_RESULT $? 0 0 "Check init msg failed when set priority ='hello'."
  CHECK_RESULT $? 0 0 "Check init msg failed when set priority ='1.1'."
  CHECK_RESULT $? 0 0 "Check init msg failed when set priority to be upper."
  CHECK_RESULT $? 0 0 "Check init msg failed when delete priority."
```

- 涉及命令：sed×2

#### oe_test_pkgship_init_exception_08

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Move bin filelist failed."
  CHECK_RESULT $? 0 0 "Initialize pkgship unexpectly."
```

#### oe_test_pkgship_init_exception_09

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "The error msg is error while priority of fedora is false."
  CHECK_RESULT $? 0 0 "The error msg is error while dbname is duolicate."
```

#### oe_test_pkgship_init_exception_10

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check init msg failed when set error1.yaml."
  CHECK_RESULT $? 0 0 "Check init msg failed when set error$i.yaml."
```

#### oe_test_pkgship_install_service_check

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "The admin pkgshipuser doesn't create."
  CHECK_RESULT 1 1 0 "The redis service doesn't install or start by auto_install_pkgship_requires.sh"
  CHECK_RESULT 1 1 0 "The elastic service doesn't install or start by auto_install_pkgship_requires.sh"
  CHECK_RESULT $? 0 0 "Start service failed."
  CHECK_RESULT $? 0 0 "Stop service failed."
```

- 涉及命令：test×1, kill×1

#### oe_test_pkgship_loop_init

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "pkgship init $i failed."
  CHECK_RESULT $? 0 0 "Check pkgship init failed."
```

#### oe_test_pkgship_loop_restart

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "pkgship service start failed."
```

- 涉及命令：pkgship×1

#### oe_test_pkgship_loop_install

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Install failed."
```

#### oe_test_pkgship_remote

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Modify config file failed."
  CHECK_RESULT $? 0 0 "Check remote -v failed."
  CHECK_RESULT $? 0 0 "Check remote dbs failed."
  CHECK_RESULT $? 0 0 "Check remote list failed."
  CHECK_RESULT $? 0 0 "Check remote pkginfo failed."
  CHECK_RESULT $? 0 0 "Check remote installdep failed."
  CHECK_RESULT $? 0 0 "Check remote builddep failed."
  CHECK_RESULT $? 0 0 "Check remote selfdepend failed."
  CHECK_RESULT $? 0 0 "Check remote bedepend failed."
```

- 涉及命令：pkgship×1

#### oe_test_pkgship_service_start

- 描述：Pkgship auto start
- 函数：`run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT 1 0 0 "The uwsgi_logrotate start failed by systemctl."
  CHECK_RESULT 1 0 0 "The uwsgi_logrotate doesn't stop by systemctl."
  CHECK_RESULT 1 0 0 "The uwsgi_logrotate start failed by pkgshipd."
  CHECK_RESULT 1 0 0 "The uwsgi_logrotate doesn't stop by pkgshipd."
```

#### oe_test_pkgship_start_exception_01

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "The error msg is false or not exist when init_conf_path doesn't exist."
```

#### oe_test_pkgship_start_exception_02

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed failed."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed."
```

- 涉及命令：journalctl×1

#### oe_test_pkgship_start_exception_03

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed."
```

- 涉及命令：journalctl×1

#### oe_test_pkgship_start_exception_04

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when set init_conf_path=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set init_conf_path=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set init_conf_path=''."
```

- 涉及命令：journalctl×1

#### oe_test_pkgship_start_exception_05

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set query_port=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set query_port=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set query_port=''."
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when delete set query_port."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete set query_port."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete set query_port."
```

- 涉及命令：journalctl×2, sed×1

#### oe_test_pkgship_start_exception_06

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when set query_ip_addr=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set query_ip_addr=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set query_ip_addr=''."
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when delete query_ip_addr."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete query_ip_addr."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete query_ip_addr."
```

- 涉及命令：journalctl×2, sed×1

#### oe_test_pkgship_start_exception_07

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check start pkgship.service when set remote_host=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set remote_host=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set remote_host=''."
```

- 涉及命令：journalctl×1

#### oe_test_pkgship_start_exception_08

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when set temporary_directory=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set temporary_directory=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set temporary_directory=''."
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when set temporary_directory=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set temporary_directory=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set temporary_directory=''."
```

- 涉及命令：journalctl×2, sed×1

#### oe_test_pkgship_start_exception_09

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when set log_path=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set log_path=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set log_path=''."
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when delete log_path."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete log_path."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete log_path."
```

- 涉及命令：journalctl×2, sed×1

#### oe_test_pkgship_start_exception_10

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when set log_level=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set log_level=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set log_level=''."
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when delete log_level."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete log_level."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete log_level."
```

- 涉及命令：journalctl×2, sed×1

#### oe_test_pkgship_start_exception_11

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when set daemonize=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set daemonize=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set daemonize=''."
  CHECK_RESULT $? 0 0 "pkgship.service failed when delete daemonize."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete daemonize."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete daemonize."
```

- 涉及命令：journalctl×2, sed×1

#### oe_test_pkgship_start_exception_12

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check start pkgship.service when set buffer-size=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set buffer-size=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set buffer-size=''."
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when delete buffer-size"
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete buffer-size"
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete log_pbuffer-sizeath"
```

- 涉及命令：journalctl×2, sed×1

#### oe_test_pkgship_start_exception_13

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when set http-timeout=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set http-timeout=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set http-timeout=''."
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when delete http-timeout"
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete http-timeout"
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete http-timeout"
```

- 涉及命令：journalctl×2, sed×1

#### oe_test_pkgship_start_exception_14

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when set harakiri=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set harakiri=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set harakiri=''."
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when delete harakiri."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete harakiri."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete harakiri."
```

- 涉及命令：journalctl×2, sed×1

#### oe_test_pkgship_start_exception_15

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check start pkgship.service failed when set redis_host=''."
  CHECK_RESULT $? 0 0 "Check start value of below when set redis_host=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set redis_host=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set redis_host=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete redis_host"
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete redis_host"
```

- 涉及命令：journalctl×3, sed×1

#### oe_test_pkgship_start_exception_16

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when set redis_port=''."
  CHECK_RESULT $? 0 0 "Check value of below config names failed when set redis_port=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set redis_port=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set redis_port=''."
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when delete redis_port"
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete redis_port"
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete redis_port"
```

- 涉及命令：journalctl×3, sed×1

#### oe_test_pkgship_start_exception_17

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when set redis_max_connections=''."
  CHECK_RESULT $? 0 0 "Check value of below config names when set redis_max_connections=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set redis_max_connections=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set redis_max_connections=''."
```

- 涉及命令：journalctl×2

#### oe_test_pkgship_start_exception_18

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check Job for pkgship.service failed when set backup_count=''."
  CHECK_RESULT $? 0 0 "Check value of below config name when set backup_count=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set backup_count=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set backup_count=''."
  CHECK_RESULT $? 0 0 "Check Job for pkgship.service failed when delete backup_count"
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete backup_count"
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete backup_count"
```

- 涉及命令：journalctl×3, sed×1

#### oe_test_pkgship_start_exception_19

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check Job for pkgship.service failed when set database_host=''."
  CHECK_RESULT $? 0 0 "Check value of below config names failed when set database_host=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set database_host=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set database_host=''."
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when delete database_host"
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete database_host"
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete database_host"
```

- 涉及命令：journalctl×3, sed×1

#### oe_test_pkgship_start_exception_20

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when set database_port=''."
  CHECK_RESULT $? 0 0 "Check value of below config names failed when set database_port=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set database_port=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set database_port=''."
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when delete database_port"
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete database_port"
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete database_port"
```

- 涉及命令：journalctl×3, sed×1

#### oe_test_pkgship_start_exception_21

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when query_port is 65537 failed."
  CHECK_RESULT $? 0 0 "Check start by systemctl when query_port is 65537 failed."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when query_port is 65537 failed."
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when query_port is test^# failed."
  CHECK_RESULT $? 0 0 "Check start by systemctl when query_port is test^# failed."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when query_port is test^# failed."
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when query_port is used_port failed."
  CHECK_RESULT $? 0 0 "Check start by systemctl when query_port is used_port failed."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when query_port is used_port failed."
```

- 涉及命令：journalctl×3

#### oe_test_pkgship_start_exception_22

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when query_ip_addr = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by systemctl when query_ip_addr = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when query_ip_addr = ${para[$i]}."
```

- 涉及命令：journalctl×1

#### oe_test_pkgship_start_exception_23

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check failed when remote_host = http://127.0.0.2:8090"
  CHECK_RESULT $? 0 0 "Check failed when remote_host = https.www.baidu.com"
  CHECK_RESULT $? 0 0 "Check failed when remote_host = @#$$%^&&"
```

#### oe_test_pkgship_start_exception_24

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The msg is error when start by systemctl."
  CHECK_RESULT $? 0 0 "The msg is error when start by systemctl."
  CHECK_RESULT $? 0 0 "The msg is error when start by pkgshipd."
```

- 涉及命令：journalctl×1

#### oe_test_pkgship_start_exception_25

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when buffer-size = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by systemctl when buffer-size = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when buffer-size = ${para[$i]}."
```

- 涉及命令：journalctl×1

#### oe_test_pkgship_start_exception_26

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when http-timeout=${para[$i]}."
  CHECK_RESULT $? 0 0 "Check by systemctl failed when http-timeout=${para[$i]}."
  CHECK_RESULT $? 0 0 "Check by systemctl failed when http-timeout=${para[$i]}."
```

- 涉及命令：journalctl×1

#### oe_test_pkgship_start_exception_27

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed  when harakiri=${para[$i]}."
  CHECK_RESULT $? 0 0 "Check by systemctl failed when harakiri=${para[$i]}."
  CHECK_RESULT $? 0 0 "Check by systemctl failed when harakiri=${para[$i]}."
```

- 涉及命令：journalctl×1

#### oe_test_pkgship_start_exception_28

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check failed by systemctl when redis_host=${para[$i]}."
  CHECK_RESULT $? 0 0 "Check failed by pkgshipd when redis_host=${para[$i]}."
```

- 涉及命令：journalctl×1

#### oe_test_pkgship_start_exception_29

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check failed by systemctl when redis_port=${para[$i]}"
  CHECK_RESULT $? 0 0 "Check failed by pkgshipd when redis_port=${para[$i]}"
  CHECK_RESULT $? 0 0 "Check failed by systemctl when redis_port=test^#"
  CHECK_RESULT $? 0 0 "Check failed by pkgshipd when redis_port=test^#"
```

- 涉及命令：journalctl×2

#### oe_test_pkgship_start_exception_30

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when redis_max_connections = 0.123."
  CHECK_RESULT $? 0 0 "Check start by systemctl when redis_max_connections = 0.123."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when redis_max_connections = 0.123."
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when redis_max_connections = -5."
  CHECK_RESULT $? 0 0 "Check start by systemctl when redis_max_connections = -5."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when redis_max_connections = -5."
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when redis_max_connections = test."
  CHECK_RESULT $? 0 0 "Check start by systemctl when redis_max_connections = test."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when redis_max_connections = test."
```

- 涉及命令：journalctl×3

#### oe_test_pkgship_start_exception_31

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when backup_count = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by systemctl when backup_count = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when backup_count = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when backup_count = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by systemctl when backup_count = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when backup_count = ${para[$i]}."
```

- 涉及命令：journalctl×2

#### oe_test_pkgship_start_exception_32

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when database_host = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by systemctl when database_host = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when database_host = ${para[$i]}."
```

- 涉及命令：journalctl×1

#### oe_test_pkgship_start_exception_33

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when database_port = 65537."
  CHECK_RESULT $? 0 0 "Check start by systemctl when database_port = 65537."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when database_port = 65537."
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when database_port = test^#."
  CHECK_RESULT $? 0 0 "Check start by systemctl when database_port = test^#."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when database_port = test^#."
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when database_port = $used_port."
  CHECK_RESULT $? 0 0 "Check start by systemctl when database_port = $used_port."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when database_port = $used_port."
```

- 涉及命令：journalctl×3

#### oe_test_pkgship_start_exception_34

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check pkgship.service failed when set max_bytes=''."
  CHECK_RESULT $? 0 0 "Check value of below config names failed when set max_bytes=''."
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when set max_bytes=''."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when set max_bytes=''."
  CHECK_RESULT $? 0 0 "Checkpkgship.service failed when delete max_bytes"
  CHECK_RESULT $? 0 0 "Check start by systemctl failed when delete max_bytes"
  CHECK_RESULT $? 0 0 "Check start by pkgshipd failed when delete max_bytes"
```

- 涉及命令：journalctl×3, sed×1

#### oe_test_pkgship_start_exception_35

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check start by systemctl when max_bytes = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when max_bytes = ${para[$i]}."
  CHECK_RESULT $? 0 0 "Check start by systemctl when max_bytes = 0."
  CHECK_RESULT $? 0 0 "Check start by pkgshipd when max_bytes = 0."
```

- 涉及命令：journalctl×2

#### oe_test_pkgship_start_init_1

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The db openeuler-test-init doesn't create on ES."
  CHECK_RESULT $? 0 0 "Check log failed."
  CHECK_RESULT $? 0 0 "Check uwsgi log failed."
```

- 涉及命令：mkdir×1, chmod×1, chown×1

#### oe_test_pkgship_start_init_2

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "openeuler init failed."
  CHECK_RESULT $? 0 0 "openeuler init failed."
  CHECK_RESULT $? 0 0 "openeuler init failed."
  CHECK_RESULT $? 1 0 "The log contains INFO."
```

#### oe_test_pkgship_start_init_3

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "database init failed."
```

- 涉及命令：sed×2

#### oe_test_pkgship_start_init_4

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "database init failed."
  CHECK_RESULT $? 0 0 "The log doesn't show ERROR msg."
```

#### oe_test_pkgship_start_init_5

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "database init failed."
  CHECK_RESULT $? 0 0 "Old log is replaced."
```

#### oe_test_pkgship_version

- 描述：Pkgship items normal function test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check version of pkgship failed."
```

- 涉及命令：pkgship×1

#### oe_test_pkgship_install_fail_01

- 描述：Pkgship install test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Install pkgship succeed unexpectly."
```

#### oe_test_pkgship_install_fail_02

- 描述：Pkgship install test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 1 0 "Install pkgship unexpectly."
```

- 涉及命令：kill×1
