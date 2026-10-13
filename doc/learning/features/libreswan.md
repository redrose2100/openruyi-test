# libreswan

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/libreswan` |
| 注册用例数 | 19 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libreswan_ipsec_01 | Test ipsec command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_libreswan_ipsec_02 | Test ipsec command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_libreswan_ipsec_03 | Test ipsec command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_libreswan_ipsec_addconn | Check ipsec addconn | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_libreswan_ipsec_algparse | Check ipsec algparse | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_libreswan_ipsec_auto_1 | Check ipsec addconn | pre_test/run_test/post_test | 10 |  | ✔ |  |
| oe_test_libreswan_ipsec_auto_2 | Check ipsec auto list cmd | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_libreswan_ipsec_check | Check ipsec status | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_libreswan_ipsec_pluto | Check ipsec pluto | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_libreswan_ipsec_setup | Start ipsec servier by systemctl setup | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_libreswan_ipsec_showhostkey_nss | Check ipsec showhostkey/nss/cavp | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_libreswan_ipsec_systemctl | Start ipsec servier by systemctl | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_libreswan_ipsec_whack_1 | Check ipsec whack list | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_libreswan_ipsec_whack_2 | Check ipsec whack status | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_libreswan_ipsec_whack_3 | Check ipsec whack | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_libreswan_ipsec_whack_4 | Check ipsec whack | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_service_ipsec | Test ipsec.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_host_to_host_vpn | Creating a host-to-host VPN | pre_test/run_test/post_test | 11 | ✔ | ✔ |  |
| oe_test_site_to_site_vpn | Configuring a site-to-site VPN | pre_test/run_test/post_test | 11 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_libreswan_ipsec_01

- 描述：Test ipsec command
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

#### oe_test_libreswan_ipsec_02

- 描述：Test ipsec command
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

#### oe_test_libreswan_ipsec_03

- 描述：Test ipsec command
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

#### oe_test_libreswan_ipsec_addconn

- 描述：Check ipsec addconn
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check ipsec addconn --config --varprefix --noexport --verbose failed."
  CHECK_RESULT $? 0 0 "Check ipsec addconn --autoall failed."
  CHECK_RESULT $? 0 0 "Check ipsec addconn --listall failed."
  CHECK_RESULT $? 0 0 "Check ipsec addconn --listroute failed."
  CHECK_RESULT $? 0 0 "Check ipsec addconn --liststart failed."
  CHECK_RESULT $? 0 0 "Check ipsec addconn --liststack failed."
  CHECK_RESULT $? 0 0 "Check ipsec addconn --listignore failed."
  CHECK_RESULT $? 0 0 "Check ipsec addconn --configsetup failed."
```

#### oe_test_libreswan_ipsec_algparse

- 描述：Check ipsec algparse
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Check ipsec algparse ike failed."
  CHECK_RESULT $? 0 0 "Check ipsec algparse esp failed."
  CHECK_RESULT $? 0 0 "Check ipsec algparse ah failed."
  CHECK_RESULT $? 0 0 "Check ipsec algparse -tp failed."
  CHECK_RESULT $? 0 0 "Check ipsec algparse -ta failed."
  CHECK_RESULT $? 0 0 "Check ipsec algparse  -v2 'ike=aes_gcm-none-sha2;modp2048' failed."
  CHECK_RESULT $? 0 0 "Check ipsec algparse -v1 failed."
  CHECK_RESULT $? 0 0 "Check ipsec algparse -pfs failed."
  CHECK_RESULT $? 0 0 "Check ipsec algparse -P testpwd failed."
  CHECK_RESULT $? 0 0 "Check ipsec algparse -v failed."
  CHECK_RESULT $? 0 0 "Check ipsec algparse --verbose failed."
  CHECK_RESULT $? 0 0 "Check ipsec algparse --debug failed."
  ... 共 18 条（其余见源脚本）
```

#### oe_test_libreswan_ipsec_auto_1

- 描述：Check ipsec addconn
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check ipsec auto --add failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --up failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --status failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --replace failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --ready failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --showonly --status --verbose failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --down failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --delete failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --listall failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --status --config failed."
```

#### oe_test_libreswan_ipsec_auto_2

- 描述：Check ipsec auto list cmd
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check ipsec auto --listpubkeys failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --listcerts failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --checkpubkeys failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --listcacerts failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --listcrls failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --listall failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --purgeocsp failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --rereadsecrets failed."
  CHECK_RESULT $? 0 0 "Check ipsec crls failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --rereadcerts failed."
  CHECK_RESULT $? 0 0 "Check ipsec auto --rereadall failed."
```

#### oe_test_libreswan_ipsec_check

- 描述：Check ipsec status
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Check ipsec verify failed."
  CHECK_RESULT $? 0 0 "Check ipsec trafficstatus failed."
  CHECK_RESULT $? 0 0 "Check ipsec globalstatus failed."
  CHECK_RESULT $? 0 0 "Check ipsec shuntstatus failed."
  CHECK_RESULT $? 0 0 "Check ipsec briefstatus failed."
  CHECK_RESULT $? 0 0 "Check ipsec showstates failed."
  CHECK_RESULT $? 0 0 "Check ipsec fips failed."
  CHECK_RESULT $? 0 0 "Check ipsec checknflog failed."
  CHECK_RESULT $? 0 0 "Check ipsec barf failed."
  CHECK_RESULT $? 0 0 "Check ipsec look failed."
  CHECK_RESULT $? 0 0 "Check ipsec newhostkey failed."
  CHECK_RESULT $? 0 0 "Check ipsec readwriteconf failed."
  ... 共 15 条（其余见源脚本）
```

#### oe_test_libreswan_ipsec_pluto

- 描述：Check ipsec pluto
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Check ipsec pluto --dnssec-rootkey-file failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --dnssec-trusted failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --leak-detective failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto version failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto help failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --debug-none failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --debug-all failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --debug failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --listen failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --listen-tcp failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --no-listen-udp failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --log-no-ip --stderrlog --logfile testlog failed."
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：test×2

#### oe_test_libreswan_ipsec_setup

- 描述：Start ipsec servier by systemctl setup
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Start failed."
  CHECK_RESULT $? 0 0 "Check start status failed."
  CHECK_RESULT $? 0 0 "Stop failed."
  CHECK_RESULT $? 0 0 "Check stop status failed."
  CHECK_RESULT $? 0 0 "Restart failed."
  CHECK_RESULT $? 0 0 "Check restart status failed."
```

#### oe_test_libreswan_ipsec_showhostkey_nss

- 描述：Check ipsec showhostkey/nss/cavp
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check ipsec initnss failed."
  CHECK_RESULT $? 0 0 "Check ipsec checknss failed."
  CHECK_RESULT $? 0 0 "Create db file failed."
  CHECK_RESULT $? 0 0 "Check ipsec import failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --version failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --dump failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --list failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --left failed."
  CHECK_RESULT $? 0 0 "Check ipsec pluto --ipseckey failed."
  CHECK_RESULT $? 0 0 "Check ipsec cavp help message failed."
```

- 涉及命令：test×1

#### oe_test_libreswan_ipsec_systemctl

- 描述：Start ipsec servier by systemctl
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Start ipsec.service failed."
  CHECK_RESULT $? 0 0 "Check ipsec.service start status failed."
  CHECK_RESULT $? 0 0 "Stop ipsec.service failed."
  CHECK_RESULT $? 0 0 "Check ipsec.service stop status failed."
  CHECK_RESULT $? 0 0 "Restart ipsec.service failed."
  CHECK_RESULT $? 0 0 "Check ipsec.service restart status failed."
```

#### oe_test_libreswan_ipsec_whack_1

- 描述：Check ipsec whack list
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check ipsec whack --version failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --listen failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --listpubkeys failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --listcerts failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --listcacerts failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --listcrls failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --listpsks failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --listevents failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --listall failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --ike-socket-errqueue-toggle failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --purgeocsp failed."
```

#### oe_test_libreswan_ipsec_whack_2

- 描述：Check ipsec whack status
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check ipsec whack --status failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --trafficstatus failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --globalstatus failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --clearstats failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --shuntstatus failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --fipsstatus failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --briefstatus failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --showstates failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --addresspoolstatus failed."
```

#### oe_test_libreswan_ipsec_whack_3

- 描述：Check ipsec whack
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check ipsec whack --ddos-busy failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --ddos-unlimited failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --ddos-auto failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --impair help failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --impair list failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --impair none failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --no-impair help failed."
```

#### oe_test_libreswan_ipsec_whack_4

- 描述：Check ipsec whack
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check ipsec whack --seccomp-crashtest failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --listen failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --unlisten failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --ddns failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --rereadsecrets failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --fetchcrls failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --rereadall failed."
  CHECK_RESULT $? 0 0 "Check ipsec whack --shutdown failed."
```

#### oe_test_service_ipsec

- 描述：Test ipsec.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ipsec.service"
```

- 涉及命令：sed×2

#### oe_test_host_to_host_vpn

- 描述：Creating a host-to-host VPN
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

#### oe_test_site_to_site_vpn

- 描述：Configuring a site-to-site VPN
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
  CHECK_RESULT $? 0 0 "add mysubnet failed"
  CHECK_RESULT $? 0 0 "up mysubnet failed"
  CHECK_RESULT $?
```
