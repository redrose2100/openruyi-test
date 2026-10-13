# wireshark

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/wireshark` |
| 注册用例数 | 12 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_capinfos | verify the uasge of capinfos command | pre_test/run_test/post_test | 25 | ✔ |  |  |
| oe_test_captype | verify the uasge of captype command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dumpcap_01 | verify the uasge of dumpcap command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_dumpcap_02 | verify the uasge of dumpcap command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_editcap_01 | verify the uasge of editcap command | pre_test/run_test/post_test | 22 | ✔ |  | 120m |
| oe_test_editcap_02 | verify the uasge of editcap command | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_mergecap | verify the uasge of mergecap command | pre_test/run_test/post_test | 19 | ✔ |  |  |
| oe_test_randpkt-reordercap | verify the uasge of randpkt and reordercap command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_text2pcap | verify the uasge of text2pcap command | pre_test/run_test/post_test | 34 | ✔ |  |  |
| oe_test_tshark_01 | verify the uasge of tshark command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_tshark_02 | verify the uasge of tshark command | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_tshark_03 | verify the uasge of tshark command | pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_capinfos

- 描述：verify the uasge of capinfos command
- 函数：`pre_test, run_test, post_test`
- 断言（25 条）：

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
  ... 共 25 条（其余见源脚本）
```

- 涉及命令：capinfos×21, test×2

#### oe_test_captype

- 描述：verify the uasge of captype command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2

#### oe_test_dumpcap_01

- 描述：verify the uasge of dumpcap command
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

- 涉及命令：grep×3, dumpcap×1

#### oe_test_dumpcap_02

- 描述：verify the uasge of dumpcap command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(find . -name "*" | grep -c 'testfile9_*')" 2
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_editcap_01

- 描述：verify the uasge of editcap command
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

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
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：editcap×7, grep×1

#### oe_test_editcap_02

- 描述：verify the uasge of editcap command
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

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
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：editcap×7, capinfos×2

#### oe_test_mergecap

- 描述：verify the uasge of mergecap command
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

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
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：mergecap×7, grep×1

#### oe_test_randpkt-reordercap

- 描述：verify the uasge of randpkt and reordercap command
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

- 涉及命令：randpkt×2

#### oe_test_text2pcap

- 描述：verify the uasge of text2pcap command
- 函数：`pre_test, run_test, post_test`
- 断言（34 条）：

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
  ... 共 34 条（其余见源脚本）
```

- 涉及命令：text2pcap×12, grep×7

#### oe_test_tshark_01

- 描述：verify the uasge of tshark command
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

- 涉及命令：grep×1

#### oe_test_tshark_02

- 描述：verify the uasge of tshark command
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(find . -name '*' | grep -c 'tsfile9_')" 3
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "$(find . -name '*' | grep -c 'tsfile13_')" 2
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：tshark×1

#### oe_test_tshark_03

- 描述：verify the uasge of tshark command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

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
```

- 涉及命令：tshark×8
