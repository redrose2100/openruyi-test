# iw

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/iw` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_iw_install | test iw package installation completeness | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_iw_01 | iw basic commands, device info query, monitor mode and HT channel settings test | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_iw_02 | iw device info query, mesh operations, event monitoring and regulatory domain test | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_iw_03 | iw PHY parameter settings, power management, 4addr and monitor flags config test | pre_test/run_test/post_test | 20 |  |  |  |
| oe_test_iw_04 | iw device type switch, interface management, channel/freq settings and power save test | pre_test/run_test/post_test | 17 |  |  |  |

### 断言与命令明细

#### oe_test_iw_install

- 描述：test iw package installation completeness
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "iw binary not found in PATH"
  CHECK_RESULT $? 0 0 "iw is not executable"
  CHECK_RESULT $? 0 0 "iw package not installed"
  CHECK_RESULT $? 0 0 "iw library dependencies not resolved"
  CHECK_RESULT $? 0 0 "iw not linked to libnl library"
  CHECK_RESULT $? 0 0 "iw license file not found"
```

- 涉及命令：test×2, command×1, rpm×1

#### oe_test_iw_01

- 描述：iw basic commands, device info query, monitor mode and HT channel settings test
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "iw --help command failed"
  CHECK_RESULT $? 0 0 "iw --version command failed"
  CHECK_RESULT $? 0 0 "iw commands command failed"
  CHECK_RESULT $? 0 0 "iw features command failed"
  CHECK_RESULT $? 0 0 "iw list command failed"
  CHECK_RESULT $? 0 0 "iw phy info command failed"
  CHECK_RESULT $? 0 0 "iw phy channels failed: no channel data found"
  CHECK_RESULT $? 0 0 "iw phy reg get command failed"
  CHECK_RESULT $? 0 0 "iw set monitor active command failed"
  CHECK_RESULT $? 0 0 "iw set monitor active command failed after up"
  CHECK_RESULT $? 0 0 "iw dev set channel HT20 command failed"
```

#### oe_test_iw_02

- 描述：iw device info query, mesh operations, event monitoring and regulatory domain test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "iw dev info command failed"
  CHECK_RESULT $? 0 0 "iw dev link command failed"
  CHECK_RESULT $? 0 0 "iw dev survey dump command failed"
  CHECK_RESULT $? 0 0 "iw dev mpath dump command failed"
  CHECK_RESULT $? 0 0 "iw dev mpp dump command failed"
  CHECK_RESULT $? 0 0 "iw dev get mesh_param command failed"
  CHECK_RESULT $? 0 0 "iw event -t start check"
  CHECK_RESULT $? 0 0 "iw event -r start check"
  CHECK_RESULT $? 0 0 "iw event -f start check"
  CHECK_RESULT $? 0 0 "iw reg get verification failed"
```

#### oe_test_iw_03

- 描述：iw PHY parameter settings, power management, 4addr and monitor flags config test
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "iw phy set retry command failed"
  CHECK_RESULT $? 0 0 "iw phy set retry short 7 command failed"
  CHECK_RESULT $? 0 0 "iw phy set retry long 4 command failed"
  CHECK_RESULT $? 0 0 "iw phy set rts command failed"
  CHECK_RESULT $? 0 0 "iw phy set rts 500 command failed"
  CHECK_RESULT $? 0 0 "iw phy set frag command failed"
  CHECK_RESULT $? 0 0 "iw phy set frag 1000 command failed"
  CHECK_RESULT $? 0 0 "iw phy set txpower command failed"
  CHECK_RESULT $? 0 0 "iw phy set txpower 20dBm command failed"
  CHECK_RESULT $? 0 0 "iw phy set name command failed"
  CHECK_RESULT $? 0 0 "iw phy set name testphy0 command failed"
  CHECK_RESULT $? 0 0 "iw phy set netns command failed"
  ... 共 20 条（其余见源脚本）
```

#### oe_test_iw_04

- 描述：iw device type switch, interface management, channel/freq settings and power save test
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "iw set type station command failed"
  CHECK_RESULT $? 0 0 "iw verify type managed command failed"
  CHECK_RESULT $? 0 0 "iw phy interface add command failed"
  CHECK_RESULT $? 0 0 "iw new interface info command failed"
  CHECK_RESULT $? 0 0 "iw interface del command failed"
  CHECK_RESULT $? 0 0 "iw verify interface del command failed"
  CHECK_RESULT $? 0 0 "iw dev interface add command failed"
  CHECK_RESULT $? 0 0 "iw verify dev interface add command failed"
  CHECK_RESULT $? 0 0 "iw dev interface del command failed"
  CHECK_RESULT $? 0 0 "iw verify dev interface del command failed"
  CHECK_RESULT $? 0 0 "iw get power_save command failed"
  CHECK_RESULT $? 0 0 "iw set power_save off command failed"
  ... 共 17 条（其余见源脚本）
```
