# sanlock

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/sanlock` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_sanlock_base_01 | verify the uasge of sanlock command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_sanlock_base_02 | verify the uasge of sanlock command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_sanlock_base_03 | verify the uasge of sanlock command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_sanlock_base_04 | verify the uasge of sanlock command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_sanlock_wdmd | verify the uasge of sanlock command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_sanlock_sanlk-reset_01 | verify the uasge of sanlock command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_sanlock_sanlk-reset_02 | verify the uasge of sanlock command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_sanlock_sanlk_resetd | verify the uasge of sanlock command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_service_sanlk-resetd | Test sanlk-resetd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_sanlock | Test sanlock.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_wdmd | Test wdmd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |

### 断言与命令明细

#### oe_test_sanlock_base_01

- 描述：verify the uasge of sanlock command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check sanlock -h failed"
  CHECK_RESULT $? 0 0 "Check sanlock --help failed"
  CHECK_RESULT $? 0 0 "Check sanlock daemon -D -Q -R -H -L -S -U -G -e failed"
  CHECK_RESULT $? 0 0 "Check sanlock daemon -D -U -G -t -g -w -h -l -b -e failed"
  CHECK_RESULT $? 0 0 "Check sanlock client init -s -Z -A failed"
  CHECK_RESULT $? 0 0 "Check sanlock client host_status -s -D failed"
  CHECK_RESULT $? 0 0 "Check sanlock client status -D -o failed"
  CHECK_RESULT $? 0 0 "Check sanlock client gets -h failed"
  CHECK_RESULT $? 0 0 "Check sanlock client renewal -s -D failed"
  CHECK_RESULT $? 0 0 "Check sanlock client set_event -s -i -g -e -d failed"
```

- 涉及命令：kill×2, sanlock×1

#### oe_test_sanlock_base_02

- 描述：verify the uasge of sanlock command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check sanlock client init -r failed"
  CHECK_RESULT $? 0 0 "Check sanlock client add_lockspace -s failed"
  CHECK_RESULT $? 0 0 "Check sanlock client command -r failed"
  CHECK_RESULT $? 0 0 "Check sanlock client set_config -s -u -O failed"
  CHECK_RESULT $? 0 0 "Check sanlock client log_dump failed"
  CHECK_RESULT $? 0 0 "Check sanlock client shutdown -f -w failed"
  CHECK_RESULT $? 0 0 "Check sanlock client read -s failed"
  CHECK_RESULT $? 0 0 "Check sanlock client acquire -r -p failed"
  CHECK_RESULT $? 0 0 "Check sanlock client inq_lockspace -s failed"
  CHECK_RESULT $? 0 0 "Check sanlock client rem_lockspace -s failed"
```

- 涉及命令：kill×2

#### oe_test_sanlock_base_03

- 描述：verify the uasge of sanlock command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check sanlock client release -r -p failed"
  CHECK_RESULT $? 0 0 "Check sanlock client convert -r -p failed"
  CHECK_RESULT $? 0 0 "Check sanlock client inquire -p failed"
  CHECK_RESULT $? 0 0 "Check sanlock client request -r failed"
  CHECK_RESULT $? 0 0 "Check sanlock client examine -r failed"
  CHECK_RESULT $? 0 0 "Check sanlock client examine -s failed"
  CHECK_RESULT $? 0 0 "Check sanlock client format -x -Z -A failed"
  CHECK_RESULT $? 0 0 "Check sanlock client create -x -e failed"
  CHECK_RESULT $? 0 0 "Check sanlock client update -x -e -z failed"
  CHECK_RESULT $? 0 0 "Check sanlock client lookup -x -e failed"
  CHECK_RESULT $? 0 0 "Check sanlock client delete -x -e failed"
  CHECK_RESULT $? 0 0 "Check sanlock client rebuild -x failed"
```

- 涉及命令：kill×2

#### oe_test_sanlock_base_04

- 描述：verify the uasge of sanlock command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check sanlock direct lookup -x -e failed"
  CHECK_RESULT $? 0 0 "Check sanlock direct init -s test:0:./dev:0 failed"
  CHECK_RESULT $? 0 0 "Check sanlock direct init -r test:testres:./res:0 -Z 512 -A 1M failed"
  CHECK_RESULT $? 0 0 "Check sanlock direct read_leader -r test:testres:./res:0 -a 1 -o 1 -Z 512 -A 1M failed"
  CHECK_RESULT $? 0 0 "Check sanlock direct read_leader -s test:1:./dev:0 failed"
  CHECK_RESULT $? 0 0 "Check sanlock direct read_leader -r test:testres:./res:0 failed"
  CHECK_RESULT $? 0 0 "Check sanlock direct dump ./res:0 failed"
  CHECK_RESULT $? 0 0 "Check sanlock direct format -x test:./res:0 -Z 512 -A 1M failed"
  CHECK_RESULT $? 0 0 "Check sanlock direct update -x -e -z failed"
  CHECK_RESULT $? 0 0 "Check sanlock direct rebuild -x failed"
```

- 涉及命令：kill×1

#### oe_test_sanlock_wdmd

- 描述：verify the uasge of sanlock command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check wdmd -h failed"
  CHECK_RESULT $? 0 0 "Check wdmd --help failed"
  CHECK_RESULT $? 0 0 "Check wdmd --version failed"
  CHECK_RESULT $? 0 0 "Check wdmd -V failed"
  CHECK_RESULT $? 0 0 "Check wdmd -d -D failed"
  CHECK_RESULT $? 0 0 "Check wdmd -d -p failed"
  CHECK_RESULT $? 0 0 "Check wdmd -d -HD failed"
  CHECK_RESULT $? 0 0 "Check wdmd -d -G failed"
  CHECK_RESULT $? 0 0 "Check wdmd -d -S failed"
  CHECK_RESULT $? 0 0 "Check wdmd -s -k -w failed"
  CHECK_RESULT $? 0 0 "Check wdmd --dump --probe failed"
```

- 涉及命令：wdmd×8, kill×1

#### oe_test_sanlock_sanlk-reset_01

- 描述：verify the uasge of sanlock command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check sanlk-reset -h failed"
  CHECK_RESULT $? 0 0 "Check sanlk-reset --help failed"
  CHECK_RESULT $? 0 0 "Check sanlk-reset -V failed"
  CHECK_RESULT $? 0 0 "Check sanlk-reset --version failed"
  CHECK_RESULT $? 0 0 "Check sanlk-reset -D reg test failed"
  CHECK_RESULT $? 0 0 "Check sanlk-reset -D end test failed"
  CHECK_RESULT $? 0 0 "Check sanlk-reset -D clear all failed"
  CHECK_RESULT $? 0 0 "Check sanlk-reset -D reset -i -w -b -R failed"
  CHECK_RESULT $? 0 0 "Check sanlk-reset -D reset --host-id --watchdog --sysrq-reboot --resource-mode failed"
```

- 涉及命令：sanlk-reset×5, kill×2

#### oe_test_sanlock_sanlk-reset_02

- 描述：verify the uasge of sanlock command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check sanlk-reset -D reset -g -i failed"
  CHECK_RESULT $? 0 0 "Check sanlk-reset -D reset --generation -i failed"
  CHECK_RESULT $? 0 0 "Check sanlk-reset -D reset -i --native-timeout failed"
  CHECK_RESULT $? 0 0 "Check sanlk-reset -D reset -i -t failed"
```

- 涉及命令：kill×2

#### oe_test_sanlock_sanlk_resetd

- 描述：verify the uasge of sanlock command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check sanlk-resetd -h failed"
  CHECK_RESULT $? 0 0 "Check sanlk-resetd --help failed"
  CHECK_RESULT $? 0 0 "Check sanlk-resetd -V failed"
  CHECK_RESULT $? 0 0 "Check sanlk-resetd --version failed"
  CHECK_RESULT $? 0 0 "Check sanlk-resetd -f -D -w -b -R -d failed"
  CHECK_RESULT $? 0 0 "Check sanlk-resetd --foreground --daemon-debug --watchdog --sysrq-reboot --resource-mode --sysrq-delay failed"
```

- 涉及命令：kill×3, sanlk-resetd×2

#### oe_test_service_sanlk-resetd

- 描述：Test sanlk-resetd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_sanlock

- 描述：Test sanlock.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_wdmd

- 描述：Test wdmd.service restart
- 函数：`pre_test, run_test, post_test`