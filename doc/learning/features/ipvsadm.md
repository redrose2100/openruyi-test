# ipvsadm

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ipvsadm` |
| 注册用例数 | 24 |
| 环境约束 | machine num = 4；add network interface = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ipvs_ADD_01 | verification ipvsadm‘s add command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ipvs_DEL_01 | verification ipvsadm‘s DEL command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ipvs_MOD_01 | verification ipvsadm‘s MOD command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ipvs_SAVE_01 | verification ipvsadm‘s save/restore command | run_test/post_test | 5 |  | ✔ |  |
| oe_test_ipvs_SCEN_off_httpd_01 | verification ipvsadm‘s DR_rr model | pre_test/run_test/post_test | 6 |  | ✔ |  |
| oe_test_ipvs_SCEN_on_firewalld_01 | verification ipvsadm‘s DR_rr model | pre_test/run_test/post_test | 6 |  | ✔ |  |
| oe_test_ipvs_SCEN_DR_01 | verification ipvsadm‘s DR_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_SCEN_DR_02 | verification ipvsadm‘s DR_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_SCEN_DR_03 | verification ipvsadm‘s DR_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_SCEN_DR_04 | verification ipvsadm‘s DR_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_SCEN_DR_05 | verification ipvsadm‘s DR_rr model | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_ipvs_SCEN_DR_06 | verification ipvsadm‘s DR_rr model | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_ipvs_SCEN_DR_07 | verification ipvsadm‘s DR_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_SCEN_DR_08 | verification ipvsadm‘s DR_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_SCEN_TUN_01 | verification ipvsadm‘s TUN_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_SCEN_TUN_02 | verification ipvsadm‘s TUN_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_SCEN_TUN_03 | verification ipvsadm‘s TUN_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_SCEN_TUN_04 | verification ipvsadm‘s TUN_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_SCEN_TUN_05 | verification ipvsadm‘s TUN_rr model | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_ipvs_SCEN_TUN_06 | verification ipvsadm‘s TUN_rr model | pre_test/run_test/post_test | 1 |  | ✔ |  |
| oe_test_ipvs_SCEN_TUN_07 | verification ipvsadm‘s TUN_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_SCEN_TUN_08 | verification ipvsadm‘s TUN_rr model | pre_test/run_test/post_test | 2 |  | ✔ |  |
| oe_test_ipvs_WRONG_COMMAND_01 | verification ipvsadm‘s add/del/modify illegale command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_service_ipvsadm | Test ipvsadm.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ipvs_ADD_01

- 描述：verification ipvsadm‘s add command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT "$(ls /usr/sbin | grep -wcE 'ipvsadm')" 3
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'Route')" 2
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'rr')" 1
```

- 涉及命令：ipvsadm×4

#### oe_test_ipvs_DEL_01

- 描述：verification ipvsadm‘s DEL command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT "$(ls /usr/sbin | grep -wcE 'ipvsadm')" 3
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'Route')" 2
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'rr')" 1
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'Route')" 1
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'http')" 2
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'http')" 0
```

- 涉及命令：ipvsadm×7

#### oe_test_ipvs_MOD_01

- 描述：verification ipvsadm‘s MOD command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT "$(ls /usr/sbin | grep -wcE 'ipvsadm')" 3
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'Route')" 2
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'rr')" 1
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'wrr')" 1
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'Masq')" 1
  CHECK_RESULT "$(ipvsadm -L | grep -wcE 'Tunnel')" 1
```

- 涉及命令：ipvsadm×8

#### oe_test_ipvs_SAVE_01

- 描述：verification ipvsadm‘s save/restore command
- 函数：`run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT "$(wc -l ./ipvsadm | grep -wcE '2')" 1
  CHECK_RESULT "$(grep -wcE 'Route' ./ipvsadm_restore.txt)" 1
  CHECK_RESULT "$(grep -wcE 'rr' ./ipvsadm_restore.txt)" 1
  CHECK_RESULT "$(grep -wcE 'Route' ./ipvsadm_restore1.txt)" 1
  CHECK_RESULT "$(grep -wcE 'rr' ./ipvsadm_restore1.txt)" 1
```

#### oe_test_ipvs_SCEN_off_httpd_01

- 描述：verification ipvsadm‘s DR_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 3
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 3
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl1.txt)" 0
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl1.txt)" 3
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl1.txt)" 0
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl1.txt)" 0
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_on_firewalld_01

- 描述：verification ipvsadm‘s DR_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 3
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 3
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl1.txt)" 0
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl1.txt)" 3
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl1.txt)" 0
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl1.txt)" 0
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_DR_01

- 描述：verification ipvsadm‘s DR_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 3
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 3
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_DR_02

- 描述：verification ipvsadm‘s DR_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 4
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 2
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_DR_03

- 描述：verification ipvsadm‘s DR_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 3
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 3
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_DR_04

- 描述：verification ipvsadm‘s DR_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 4
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 2
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_DR_05

- 描述：verification ipvsadm‘s DR_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$(wc -l ./result_curl.txt | grep -wcE "6")" 1
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_DR_06

- 描述：verification ipvsadm‘s DR_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$(wc -l ./result_curl.txt | grep -wcE "6")" 1
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_DR_07

- 描述：verification ipvsadm‘s DR_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 0
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 6
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_DR_08

- 描述：verification ipvsadm‘s DR_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 0
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 6
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_TUN_01

- 描述：verification ipvsadm‘s TUN_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 3
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 3
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_TUN_02

- 描述：verification ipvsadm‘s TUN_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 4
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 2
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_TUN_03

- 描述：verification ipvsadm‘s TUN_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 3
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 3
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_TUN_04

- 描述：verification ipvsadm‘s TUN_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 4
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 2
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_TUN_05

- 描述：verification ipvsadm‘s TUN_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$(wc -l ./result_curl.txt | grep -wcE "6")" 1
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_TUN_06

- 描述：verification ipvsadm‘s TUN_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$(wc -l ./result_curl.txt | grep -wcE "6")" 1
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_TUN_07

- 描述：verification ipvsadm‘s TUN_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 0
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 6
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_SCEN_TUN_08

- 描述：verification ipvsadm‘s TUN_rr model
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT "$(grep -wcE "${ipvs_ip2}" ./result_curl.txt)" 0
  CHECK_RESULT "$(grep -wcE "${ipvs_ip3}" ./result_curl.txt)" 6
```

- 涉及命令：sed×7, ipvsadm×3, bash×3

#### oe_test_ipvs_WRONG_COMMAND_01

- 描述：verification ipvsadm‘s add/del/modify illegale command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT "$(ipvsadm -A -t $VIP -s rr)" $check_port
  CHECK_RESULT "$(ipvsadm -a -t $VIP:80 -s rr)" $check_parameter
  CHECK_RESULT "$(ipvsadm -A -t $VIP:80 -s wr)" $check_algorithm
  CHECK_RESULT "$(ipvsadm -a -t $VIP:80 -r ${NODE2_IPV4}:80 -j)" $check_mode
  CHECK_RESULT $?
```

- 涉及命令：ipvsadm×4

#### oe_test_service_ipvsadm

- 描述：Test ipvsadm.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：ipvsadm-save×1
