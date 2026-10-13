# alsa-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/alsa-tools` |
| 注册用例数 | 17 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_alsa_tools_as10k1 | Test as10k1 command parameters | config_params/pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_alsa_tools_basic | Test alsa-tools package installation and basic functionality | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_alsa_tools_cspctl | Test cspctl command parameters | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_alsa_tools_dl10k1 | Test dl10k1 command parameters | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_alsa_tools_hda-verb | Test hda-verb command parameters | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_alsa_tools_hdajacksensetest | Test hdajacksensetest command parameters | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_alsa_tools_ld10k1 | Test ld10k1 command parameters | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_alsa_tools_ld10k1d | Test ld10k1d command parameters | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_alsa_tools_lo10k1 | Test lo10k1 command parameters | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_alsa_tools_misc | Test misc alsa-tools commands (GTK/GUI tools, simple checks) | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_alsa_tools_mixartloader | Test mixartloader command parameters | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_alsa_tools_pcxhrloader | Test pcxhrloader command parameters | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_alsa_tools_sbiload | Test sbiload command parameters | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_alsa_tools_sscape_ctl | Test sscape_ctl command parameters | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_alsa_tools_us428control | Test us428control command parameters | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_alsa_tools_usx2yloader | Test usx2yloader command parameters | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_alsa_tools_vxloader | Test vxloader command parameters | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_alsa_tools_as10k1

- 描述：Test as10k1 command parameters
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "as10k1 -h check failed"
  CHECK_RESULT $? 0 0 "as10k1 -v check failed"
  CHECK_RESULT $? 0 0 "as10k1 -o option check failed"
  CHECK_RESULT $? 0 0 "as10k1 -l option check failed"
  CHECK_RESULT $? 0 0 "as10k1 -d s option check failed"
  CHECK_RESULT $? 0 0 "as10k1 -d g option check failed"
  CHECK_RESULT $? 0 0 "as10k1 -d t option check failed"
  CHECK_RESULT $? 0 0 "as10k1 -d i option check failed"
  CHECK_RESULT $? 0 0 "as10k1 -d sgti option check failed"
  CHECK_RESULT $? 0 1 "as10k1 should fail with nonexistent file"
```

- 涉及命令：as10k1×9, test×2, mkdir×1

#### oe_test_alsa_tools_basic

- 描述：Test alsa-tools package installation and basic functionality
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "alsa-tools package not installed"
  CHECK_RESULT $? 0 0 "alsa-tools version check failed"
  CHECK_RESULT $? 0 0 "liblo10k1 library not found"
```

- 涉及命令：rpm×2

#### oe_test_alsa_tools_cspctl

- 描述：Test cspctl command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "cspctl command not found"
  CHECK_RESULT $? 0 0 "cspctl -h check failed"
  CHECK_RESULT $? 0 0 "cspctl --help check failed"
  CHECK_RESULT $? 0 0 "cspctl -c card option check failed"
  CHECK_RESULT $? 0 0 "cspctl -f function option check failed"
  CHECK_RESULT $? 0 0 "cspctl -d description option check failed"
  CHECK_RESULT $? 0 0 "cspctl load command check failed"
  CHECK_RESULT $? 0 0 "cspctl unload command check failed"
```

- 涉及命令：cspctl×4, command×1

#### oe_test_alsa_tools_dl10k1

- 描述：Test dl10k1 command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "dl10k1 command not found"
  CHECK_RESULT $? 0 0 "dl10k1 -h check failed"
  CHECK_RESULT $? 0 0 "dl10k1 --help check failed"
  CHECK_RESULT $? 0 0 "dl10k1 -c card option check failed"
  CHECK_RESULT $? 0 0 "dl10k1 -d dump option check failed"
  CHECK_RESULT $? 0 0 "dl10k1 dump file not created"
```

- 涉及命令：dl10k1×3, command×1, test×1

#### oe_test_alsa_tools_hda-verb

- 描述：Test hda-verb command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "hda-verb -l check failed"
  CHECK_RESULT $? 0 0 "hda-verb -L check failed"
  CHECK_RESULT $? 0 0 "hda-verb -l should show SET_STREAM_FORMAT"
  CHECK_RESULT $? 0 0 "hda-verb -L (${L_lines} lines) should output more lines than -l (${l_lines} lines)"
```

- 涉及命令：hda-verb×3

#### oe_test_alsa_tools_hdajacksensetest

- 描述：Test hdajacksensetest command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "hdajacksensetest command not found"
  CHECK_RESULT $? 0 0 "hdajacksensetest -h check failed"
  CHECK_RESULT $? 0 0 "hdajacksensetest --help check failed"
  CHECK_RESULT $? 0 0 "hdajacksensetest -c card option check failed"
  CHECK_RESULT $? 0 0 "hdajacksensetest -d codec option check failed"
  CHECK_RESULT $? 0 0 "hdajacksensetest -a allpins option check failed"
  CHECK_RESULT $? 0 0 "hdajacksensetest -s setpinsense option check failed"
```

- 涉及命令：hdajacksensetest×5, command×1

#### oe_test_alsa_tools_ld10k1

- 描述：Test ld10k1 command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "ld10k1 command not found"
  CHECK_RESULT $? 0 0 "ld10k1 -h check failed"
  CHECK_RESULT $? 0 0 "ld10k1 --help check failed"
  CHECK_RESULT $? 0 0 "ld10k1 -c card option check failed"
  CHECK_RESULT $? 0 0 "ld10k1 -p pipe_name option check failed"
  CHECK_RESULT $? 0 0 "ld10k1 -t tram_size option check failed"
```

- 涉及命令：ld10k1×4, command×1

#### oe_test_alsa_tools_ld10k1d

- 描述：Test ld10k1d command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ld10k1d command not found"
  CHECK_RESULT $? 0 0 "ld10k1d should show start"
  CHECK_RESULT $? 0 0 "ld10k1d should show stop"
```

- 涉及命令：command×1

#### oe_test_alsa_tools_lo10k1

- 描述：Test lo10k1 command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "lo10k1 command not found"
  CHECK_RESULT $? 0 0 "lo10k1 -h check failed"
  CHECK_RESULT $? 0 0 "lo10k1 --help check failed"
  CHECK_RESULT $? 0 0 "lo10k1 -i info option check failed"
  CHECK_RESULT $? 0 0 "lo10k1 -l list option check failed"
  CHECK_RESULT $? 0 0 "lo10k1 --debug option check failed"
  CHECK_RESULT $? 0 0 "lo10k1 -P path option check failed"
  CHECK_RESULT $? 0 0 "lo10k1 --dump option check failed"
  CHECK_RESULT $? 0 0 "lo10k1 dump file not created"
```

- 涉及命令：lo10k1×4, command×1, test×1

#### oe_test_alsa_tools_misc

- 描述：Test misc alsa-tools commands (GTK/GUI tools, simple checks)
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "echomixer execution check failed"
  CHECK_RESULT $? 0 0 "envy24control execution check failed"
  CHECK_RESULT $? 0 0 "hdajackretask execution check failed"
  CHECK_RESULT $? 0 0 "hdspconf execution check failed"
  CHECK_RESULT $? 0 0 "hwmixvolume execution check failed"
  CHECK_RESULT $? 0 0 "init_audigy execution check failed"
  CHECK_RESULT $? 0 0 "init_audigy_eq10 execution check failed"
  CHECK_RESULT $? 0 0 "init_live execution check failed"
  CHECK_RESULT $? 0 0 "rmedigicontrol execution check failed"
  CHECK_RESULT $? 0 0 "hdsploader -D option check failed"
```

#### oe_test_alsa_tools_mixartloader

- 描述：Test mixartloader command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "mixartloader command not found"
  CHECK_RESULT $? 0 0 "mixartloader banner check failed"
  CHECK_RESULT $? 0 0 "mixartloader -h check failed"
  CHECK_RESULT $? 0 0 "mixartloader -c card option check failed"
  CHECK_RESULT $? 0 0 "mixartloader -D device option check failed"
```

- 涉及命令：mixartloader×3, command×1

#### oe_test_alsa_tools_pcxhrloader

- 描述：Test pcxhrloader command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "pcxhrloader command not found"
  CHECK_RESULT $? 0 0 "pcxhrloader banner check failed"
  CHECK_RESULT $? 0 0 "pcxhrloader -h check failed"
  CHECK_RESULT $? 0 0 "pcxhrloader -c card option check failed"
  CHECK_RESULT $? 0 0 "pcxhrloader -D device option check failed"
```

- 涉及命令：pcxhrloader×3, command×1

#### oe_test_alsa_tools_sbiload

- 描述：Test sbiload command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "sbiload --help check failed"
  CHECK_RESULT $? 0 0 "sbiload -V version check failed"
  CHECK_RESULT $? 0 0 "sbiload -c clear option check failed"
  CHECK_RESULT $? 0 0 "sbiload -D device option check failed"
  CHECK_RESULT $? 0 0 "sbiload -2 opl2 option check failed"
  CHECK_RESULT $? 0 0 "sbiload -4 opl3 option check failed"
  CHECK_RESULT $? 0 0 "sbiload -P path option check failed"
  CHECK_RESULT $? 0 0 "sbiload -v verbose option check failed"
```

- 涉及命令：sbiload×7

#### oe_test_alsa_tools_sscape_ctl

- 描述：Test sscape_ctl command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "sscape_ctl --help check failed"
  CHECK_RESULT $? 0 0 "sscape_ctl --version check failed"
  CHECK_RESULT $? 0 0 "sscape_ctl --card option check failed"
  CHECK_RESULT $? 0 0 "sscape_ctl --directory option check failed"
```

#### oe_test_alsa_tools_us428control

- 描述：Test us428control command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "us428control execution check failed"
  CHECK_RESULT $? 0 0 "us428control -v verbosity option check failed"
  CHECK_RESULT $? 0 0 "us428control -c card option check failed"
  CHECK_RESULT $? 0 0 "us428control -D device option check failed"
  CHECK_RESULT $? 0 0 "us428control -u usb-device option check failed"
  CHECK_RESULT $? 0 0 "us428control -m mode option check failed"
```

- 涉及命令：us428control×5

#### oe_test_alsa_tools_usx2yloader

- 描述：Test usx2yloader command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "usx2yloader command not found"
  CHECK_RESULT $? 0 0 "usx2yloader banner check failed"
  CHECK_RESULT $? 0 0 "usx2yloader -h check failed"
  CHECK_RESULT $? 0 0 "usx2yloader -u usb-device option check failed"
  CHECK_RESULT $? 0 0 "usx2yloader -D device option check failed"
```

- 涉及命令：usx2yloader×3, command×1

#### oe_test_alsa_tools_vxloader

- 描述：Test vxloader command parameters
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "vxloader command not found"
  CHECK_RESULT $? 0 0 "vxloader banner check failed"
  CHECK_RESULT $? 0 0 "vxloader -h check failed"
  CHECK_RESULT $? 0 0 "vxloader -c card option check failed"
  CHECK_RESULT $? 0 0 "vxloader -D device option check failed"
```

- 涉及命令：vxloader×3, command×1
