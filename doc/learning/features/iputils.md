# iputils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/iputils` |
| 注册用例数 | 15 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_iputils_ping_01 | Test ping command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_iputils_ping_02 | Test ping command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_iputils_ping_03 | Test ping command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_iputils_ping_04 | Test ping command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_iputils_ping6_01 | Test ping6 command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_iputils_ping6_02 | Test ping6 command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_iputils_ping6_03 | Test ping6 command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_iputils_ping6_04 | Test ping6 command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_iputils_ifenslave_01 | Test ifenslave command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_iputils_tracepath | Test tracepath command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_iputils_tracepath6 | Test tracepath6 command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_iputils_clockdiff | Test clockdiff command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_iputils_arping | Test arping command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_service_ninfod | Test ninfod.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_rdisc | Test rdisc.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_iputils_ping_01

- 描述：Test ping command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "ping -a execute failed"
  CHECK_RESULT $? 0 0 "ping -A execute failed"
  CHECK_RESULT $? 0 0 "ping -B execute failed"
  CHECK_RESULT $? 0 0 "ping -c execute failed"
  CHECK_RESULT $? 0 0 "ping -D execute failed"
  CHECK_RESULT $? 0 0 "ping -d execute failed"
  CHECK_RESULT $? 0 0 "ping -C execute failed"
  CHECK_RESULT $? 0 0 "ping -e execute failed"
  CHECK_RESULT $? 0 0 "ping -f execute failed"
  CHECK_RESULT $? 0 0 "ping -h execute failed"
```

- 涉及命令：ping×9

#### oe_test_iputils_ping_02

- 描述：Test ping command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "ping -I execute failed"
  CHECK_RESULT $? 0 0 "ping -i execute failed"
  CHECK_RESULT $? 0 0 "ping -L execute failed"
  CHECK_RESULT $? 0 0 "ping -l execute failed"
  CHECK_RESULT $? 0 0 "ping -m execute failed"
  CHECK_RESULT $? 0 0 "ping -M execute failed"
  CHECK_RESULT $? 0 0 "ping -n execute failed"
  CHECK_RESULT $? 0 0 "ping -O execute failed"
  CHECK_RESULT $? 0 0 "ping -p execute failed"
  CHECK_RESULT $? 0 0 "ping -q execute failed"
```

- 涉及命令：ping×10

#### oe_test_iputils_ping_03

- 描述：Test ping command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "ping -Q execute failed"
  CHECK_RESULT $? 0 0 "ping -s execute failed"
  CHECK_RESULT $? 0 0 "ping -S execute failed"
  CHECK_RESULT $? 0 0 "ping -t execute failed"
  CHECK_RESULT $? 0 0 "ping -U execute failed"
  CHECK_RESULT $? 0 0 "ping -v execute failed"
  CHECK_RESULT $? 0 0 "ping -V execute failed"
  CHECK_RESULT $? 0 0 "ping -w execute failed"
  CHECK_RESULT $? 0 0 "ping -W execute failed"
```

- 涉及命令：ping×9

#### oe_test_iputils_ping_04

- 描述：Test ping command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "ping -4 execute failed"
  CHECK_RESULT $? 0 0 "ping -b execute failed"
  CHECK_RESULT $? 0 0 "ping -R execute failed"
  CHECK_RESULT $? 0 0 "ping -T execute failed"
  CHECK_RESULT $? 0 0 "ping -6 execute failed"
  CHECK_RESULT $? 0 0 "ping -F execute failed"
  CHECK_RESULT $? 0 0 "ping -N execute failed"
```

- 涉及命令：ping×7

#### oe_test_iputils_ping6_01

- 描述：Test ping6 command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "ping6 -a execute failed"
  CHECK_RESULT $? 0 0 "ping6 -A execute failed"
  CHECK_RESULT $? 0 0 "ping6 -B execute failed"
  CHECK_RESULT $? 0 0 "ping6 -c execute failed"
  CHECK_RESULT $? 0 0 "ping6 -D execute failed"
  CHECK_RESULT $? 0 0 "ping6 -d execute failed"
  CHECK_RESULT $? 0 0 "ping6 -C execute failed"
  CHECK_RESULT $? 0 0 "ping6 -e execute failed"
  CHECK_RESULT $? 0 0 "ping6 -f execute failed"
  CHECK_RESULT $? 0 0 "ping6 -h execute failed"
```

- 涉及命令：ping6×9

#### oe_test_iputils_ping6_02

- 描述：Test ping6 command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "ping6 -I execute failed"
  CHECK_RESULT $? 0 0 "ping6 -i execute failed"
  CHECK_RESULT $? 0 0 "ping6 -L execute failed"
  CHECK_RESULT $? 0 0 "ping6 -l execute failed"
  CHECK_RESULT $? 0 0 "ping6 -m execute failed"
  CHECK_RESULT $? 0 0 "ping6 -M execute failed"
  CHECK_RESULT $? 0 0 "ping6 -n execute failed"
  CHECK_RESULT $? 0 0 "ping6 -O execute failed"
  CHECK_RESULT $? 0 0 "ping6 -p execute failed"
  CHECK_RESULT $? 0 0 "ping6 -q execute failed"
```

- 涉及命令：ping6×10

#### oe_test_iputils_ping6_03

- 描述：Test ping6 command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "ping6 -Q execute failed"
  CHECK_RESULT $? 0 0 "ping6 -s execute failed"
  CHECK_RESULT $? 0 0 "ping6 -S execute failed"
  CHECK_RESULT $? 0 0 "ping6 -t execute failed"
  CHECK_RESULT $? 0 0 "ping6 -U execute failed"
  CHECK_RESULT $? 0 0 "ping6 -v execute failed"
  CHECK_RESULT $? 0 0 "ping6 -V execute failed"
  CHECK_RESULT $? 0 0 "ping6 -w execute failed"
  CHECK_RESULT $? 0 0 "ping6 -W execute failed"
```

- 涉及命令：ping6×9

#### oe_test_iputils_ping6_04

- 描述：Test ping6 command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "ping6 -4 execute failed"
  CHECK_RESULT $? 0 0 "ping6 -b execute failed"
  CHECK_RESULT $? 0 0 "ping6 -R execute failed"
  CHECK_RESULT $? 0 0 "ping6 -T execute failed"
  CHECK_RESULT $? 0 0 "ping6 -6 execute failed"
  CHECK_RESULT $? 0 0 "ping6 -F execute failed"
  CHECK_RESULT $? 0 0 "ping6 -N execute failed"
```

- 涉及命令：ping6×7

#### oe_test_iputils_ifenslave_01

- 描述：Test ifenslave command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "ifenslave -h execute failed"
  CHECK_RESULT $? 0 0 "ifenslave --h execute failed"
  CHECK_RESULT $? 0 0 "ifenslave --help execute failed"
  CHECK_RESULT $? 0 0 "ifenslave -V execute failed"
  CHECK_RESULT $? 0 0 "ifenslave --version execute failed"
  CHECK_RESULT $? 0 0 "ifenslave -u execute failed"
  CHECK_RESULT $? 0 0 "ifenslave --usage execute failed"
  CHECK_RESULT $? 0 0 "ifenslave -a execute failed"
  CHECK_RESULT $? 0 0 "ifenslave -all-interfaces execute failed"
  CHECK_RESULT $? 0 0 "ifenslave -v execute failed"
  CHECK_RESULT $? 0 0 "ifenslave -verbose execute failed"
```

- 涉及命令：ifenslave×5

#### oe_test_iputils_tracepath

- 描述：Test tracepath command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "tracepath -V execute failed"
  CHECK_RESULT $? 0 0 "tracepath -4 execute failed"
  CHECK_RESULT $? 0 0 "tracepath -6 execute failed"
  CHECK_RESULT $? 0 0 "tracepath -b execute failed"
  CHECK_RESULT $? 0 0 "tracepath -l execute failed"
  CHECK_RESULT $? 0 0 "tracepath -m execute failed"
  CHECK_RESULT $? 0 0 "tracepath -n execute failed"
  CHECK_RESULT $? 0 0 "tracepath -p execute failed"
```

- 涉及命令：tracepath×8

#### oe_test_iputils_tracepath6

- 描述：Test tracepath6 command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "tracepath6 -V execute failed"
  CHECK_RESULT $? 1 0 "tracepath6 -4 execute failed"
  CHECK_RESULT $? 0 0 "tracepath6 -6 execute failed"
  CHECK_RESULT $? 0 0 "tracepath6 -b execute failed"
  CHECK_RESULT $? 0 0 "tracepath6 -l execute failed"
  CHECK_RESULT $? 0 0 "tracepath6 -m execute failed"
  CHECK_RESULT $? 0 0 "tracepath6 -n execute failed"
  CHECK_RESULT $? 0 0 "tracepath6 -p execute failed"
```

- 涉及命令：tracepath6×8

#### oe_test_iputils_clockdiff

- 描述：Test clockdiff command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "clockdiff -V execute failed"
  CHECK_RESULT $? 0 0 "clockdiff -version execute failed"
  CHECK_RESULT $? 0 0 "clockdiff -h execute failed"
  CHECK_RESULT $? 0 0 "clockdiff --help execute failed"
  CHECK_RESULT $? 0 0 "clockdiff -o execute failed"
  CHECK_RESULT $? 0 0 "clockdiff -o1 execute failed"
  CHECK_RESULT $? 0 0 "clockdiff -T ctime execute failed"
  CHECK_RESULT $? 0 0 "clockdiff --time-format execute failed"
  CHECK_RESULT $? 0 0 "clockdiff -I execute failed"
```

- 涉及命令：clockdiff×6

#### oe_test_iputils_arping

- 描述：Test arping command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "arping -f execute failed"
  CHECK_RESULT $? 0 0 "arping -qf execute failed"
  CHECK_RESULT $? 0 0 "arping -b execute failed"
  CHECK_RESULT $? 0 0 "arping -D execute failed"
  CHECK_RESULT $? 0 0 "arping -U execute failed"
  CHECK_RESULT $? 0 0 "arping -A execute failed"
  CHECK_RESULT $? 0 0 "arping -V execute failed"
  CHECK_RESULT $? 0 0 "arping -c execute failed"
  CHECK_RESULT $? 0 0 "arping -w execute failed"
  CHECK_RESULT $? 0 0 "arping -i execute failed"
  CHECK_RESULT $? 0 0 "arping -I execute failed"
  CHECK_RESULT $? 0 0 "arping -s execute failed"
```

- 涉及命令：arping×12

#### oe_test_service_ninfod

- 描述：Test ninfod.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_rdisc

- 描述：Test rdisc.service restart
- 函数：`pre_test, run_test, post_test`