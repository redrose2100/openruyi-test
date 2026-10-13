# wsmancli

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/wsmancli` |
| 注册用例数 | 11 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_wsmancli_wseventmgr_01 | Test wsmancli | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_wsmancli_wseventmgr_02 | Test wsmancli | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_wsmancli_wseventmgr_03 | Test wsmancli | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_wsmancli_wseventmgr_04 | Test wsmancli | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_wsmancli_wsman_01 | Test wsmancli | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_wsmancli_wsman_02 | Test wsmancli | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_wsmancli_wsman_03 | Test wsmancli | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_wsmancli_wsman_04 | Test wsmancli | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_wsmancli_wsman_05 | Test wsmancli | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_wsmancli_wsman_06 | Test wsmancli | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_wsmancli_wsman_07 | Test wsmancli | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_wsmancli_wseventmgr_01

- 描述：Test wsmancli
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -h -P -u -p -x -D -Z"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -b"
  CHECK_RESULT $? 1 0 "wamancli.wseventmgr: faild to test option -d"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -d"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -j"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -c"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -A"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -K"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -g"
```

- 涉及命令：openwsmand×1, kill×1

#### oe_test_wsmancli_wseventmgr_02

- 描述：Test wsmancli
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -X -Y"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -y"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -C"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -O"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -V"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -v"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -I"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option --enum-context"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -i"
```

- 涉及命令：openwsmand×1, test×1, kill×1

#### oe_test_wsmancli_wseventmgr_03

- 描述：Test wsmancli
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -G "
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -s "
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -U --delivery-password"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -T "
  CHECK_RESULT $? 0 0 "wamancli: faild to test -r"
  CHECK_RESULT $? 0 0 "wamancli: faild to test --event-reference-properties"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -H -R"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test -l "
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr:: faild to test -E"
```

- 涉及命令：openwsmand×1, kill×1

#### oe_test_wsmancli_wseventmgr_04

- 描述：Test wsmancli
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option -?"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option --help"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option --help-all"
  CHECK_RESULT $? 0 0 "wamancli.wseventmgr: faild to test option --help-event"
```

#### oe_test_wsmancli_wsman_01

- 描述：Test wsmancli
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -q"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option --non-interactive"
  CHECK_RESULT $? 1 0 "wamancli: faild to test option -d"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -d"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -j"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -J"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -c"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -K"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -A"
```

- 涉及命令：kill×2, openwsmand×1, wsman×1, uerdel×1

#### oe_test_wsmancli_wsman_02

- 描述：Test wsmancli
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -b"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -P"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -X -Y"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -y"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -a"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -C"
```

- 涉及命令：openwsmand×1, kill×1

#### oe_test_wsmancli_wsman_03

- 描述：Test wsmancli
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -O"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -V"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -v"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -I"
```

- 涉及命令：openwsmand×1, test×1, kill×1

#### oe_test_wsmancli_wsman_04

- 描述：Test wsmancli
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -?"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option --help"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-all"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-enumeration"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-tests"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-cim"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-flags"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option --help-event"
```

#### oe_test_wsmancli_wsman_05

- 描述：Test wsmancli
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "wamancli: faild to test -x -D -Z"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -G "
  CHECK_RESULT $? 0 0 "wamancli: faild to test -s "
  CHECK_RESULT $? 0 0 "wamancli: faild to test -n -z "
  CHECK_RESULT $? 0 0 "wamancli: faild to test --delivery-thumbprint"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -r"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -H -R"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -l "
```

- 涉及命令：openwsmand×1, kill×1

#### oe_test_wsmancli_wsman_06

- 描述：Test wsmancli
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "wamancli: faild to test -R"
  CHECK_RESULT $? 1 0 "wamancli: faild to test -S"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -N"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -B"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -t"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -e"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -F"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -L"
```

- 涉及命令：openwsmand×1, kill×1

#### oe_test_wsmancli_wsman_07

- 描述：Test wsmancli
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "wamancli: faild to test -m"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -o"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -E"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -M"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -M"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -T"
  CHECK_RESULT $? 0 0 "wamancli: faild to test option -i"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -g"
  CHECK_RESULT $? 0 0 "wamancli: faild to test -k"
```

- 涉及命令：openwsmand×1, kill×1
