# netsniff-ng

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/netsniff-ng` |
| 注册用例数 | 19 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_astraceroute_01 | Test astraceroute | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_astraceroute_02 | Test astraceroute | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_astraceroute_03 | Test astraceroute | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_astraceroute_04 | Test astraceroute | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_astraceroute_05 | Test astraceroute | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_bpfc | Test bpfc | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_curvetun_client | Test curvetun | pre_test/run_test/post_test | 4 | ✔ | ✔ |  |
| oe_test_curvetun_common | Test curvetun | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_curvetun_server | Test curvetun | pre_test/run_test/post_test | 18 | ✔ | ✔ |  |
| oe_test_flowtop_01 | Test trafgen | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ifpps_01 | Test ifpps | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_ifpps_02 | Test ifpps | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_netsniff_ng_01 | Test netsniff-ng | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_netsniff_ng_02 | Test netsniff-ng | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_netsniff_ng_03 | Test netsniff-ng | pre_test/run_test/post_test | 26 | ✔ |  |  |
| oe_test_netsniff_ng_04 | Test netsniff-ng | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_trafgen_01 | Test trafgen | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_trafgen_02 | Test trafgen | pre_test/run_test/post_test | 16 | ✔ |  |  |
| oe_test_trafgen_03 | Test trafgen | pre_test/run_test/post_test | 19 | ✔ |  |  |

### 断言与命令明细

#### oe_test_astraceroute_01

- 描述：Test astraceroute
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "Check astraceroute -v failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --version failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -h failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --help failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -H failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --host failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -p failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --port failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -i failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -d failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --dev failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -b failed"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：astraceroute×12, kill×11, tar×1

#### oe_test_astraceroute_02

- 描述：Test astraceroute
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check astraceroute -m failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --max-ttl failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -q failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --num-probes failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -x failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --timeout failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -X failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --payload failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -l failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --totlen failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -4 failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --ipv4 failed"
```

- 涉及命令：astraceroute×12, kill×12, tar×1

#### oe_test_astraceroute_03

- 描述：Test astraceroute
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check astraceroute -n failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --numeric failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -N failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --dns failed"
```

- 涉及命令：astraceroute×4, grep×4, kill×4, tar×1

#### oe_test_astraceroute_04

- 描述：Test astraceroute
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Check astraceroute -S failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --syn failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -A failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --ack failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -F failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --fin failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -P failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --psh failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -U failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --urg failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -R failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --rst failed"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：astraceroute×14, kill×14, tar×1

#### oe_test_astraceroute_05

- 描述：Test astraceroute
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check astraceroute -L failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --latitude failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -t failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --tos failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -G failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --nofrag failed"
  CHECK_RESULT $? 0 0 "Check astraceroute -Z failed"
  CHECK_RESULT $? 0 0 "Check astraceroute --show-packet failed"
```

- 涉及命令：astraceroute×6, grep×2, tar×1

#### oe_test_bpfc

- 描述：Test bpfc
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Check bpfc --version failed"
  CHECK_RESULT $? 0 0 "Check bpfc -v failed"
  CHECK_RESULT $? 0 0 "Check bpfc -h failed"
  CHECK_RESULT $? 0 0 "Check bpfc --help failed"
  CHECK_RESULT $? 0 0 "Check bpfc -i failed"
  CHECK_RESULT $? 0 0 "Check bpfc --input failed"
  CHECK_RESULT $? 0 0 "Check bpfc -p failed"
  CHECK_RESULT $? 0 0 "Check bpfc --cpp failed"
  CHECK_RESULT $? 0 0 "Check bpfc -D failed"
  CHECK_RESULT $? 0 0 "Check bpfc --define failed"
  CHECK_RESULT $? 0 0 "Check bpfc -f failed"
  CHECK_RESULT $? 0 0 "Check bpfc --format failed"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：bpfc×13, tar×1

#### oe_test_curvetun_client

- 描述：Test curvetun
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check -S failed"
  CHECK_RESULT $? 0 0 "Check --dumps failed"
  CHECK_RESULT $? 0 0 "Check -c failed"
  CHECK_RESULT $? 0 0 "Check --client failed"
```

- 涉及命令：curvetun×2, kill×2, tar×1

#### oe_test_curvetun_common

- 描述：Test curvetun
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check curvetun -v failed"
  CHECK_RESULT $? 0 0 "Check curvetun --version failed"
  CHECK_RESULT $? 0 0 "Check curvetun -h failed"
  CHECK_RESULT $? 0 0 "Check curvetun -h failed"
  CHECK_RESULT $? 0 0 "Check curvetun -k failed"
  CHECK_RESULT $? 0 0 "Check curvetun --keygen failed"
  CHECK_RESULT $? 0 0 "Check curvetun -x failed"
  CHECK_RESULT $? 0 0 "Check curvetun --export failed"
  CHECK_RESULT $? 0 0 "Check curvetun -C failed"
  CHECK_RESULT $? 0 0 "Check curvetun --dumpc failed"
```

- 涉及命令：curvetun×5, test×2, tar×1

#### oe_test_curvetun_server

- 描述：Test curvetun
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Check curvetun -s failed"
  CHECK_RESULT $? 0 0 "Check curvetun --dev failed"
  CHECK_RESULT $? 0 0 "Check curvetun --port failed"
  CHECK_RESULT $? 0 0 "Check curvetun -p failed"
  CHECK_RESULT $? 0 0 "Check curvetun --server failed"
  CHECK_RESULT $? 0 0 "Check curvetun -s failed"
  CHECK_RESULT $? 0 0 "Check curvetun -N failed"
  CHECK_RESULT $? 0 0 "Check curvetun --no-logging failed"
  CHECK_RESULT $? 0 0 "Check curvetun -u failed"
  CHECK_RESULT $? 0 0 "Check curvetun --udp failed"
  CHECK_RESULT $? 0 0 "Check curvetun -4 failed"
  CHECK_RESULT $? 0 0 "Check curvetun --ipv4 failed"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：curvetun×11, tar×1

#### oe_test_flowtop_01

- 描述：Test trafgen
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check flowtop -v failed"
  CHECK_RESULT $? 0 0 "Check flowtop --version failed"
  CHECK_RESULT $? 0 0 "Check flowtop -h failed"
  CHECK_RESULT $? 0 0 "Check flowtop --help failed"
```

- 涉及命令：flowtop×2, tar×1

#### oe_test_ifpps_01

- 描述：Test ifpps
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check ifpps -v failed"
  CHECK_RESULT $? 0 0 "Check ifpps --version failed"
  CHECK_RESULT $? 0 0 "Check ifpps -g failed"
  CHECK_RESULT $? 0 0 "Check ifpps --help failed"
  CHECK_RESULT $? 0 0 "Check ifpps -d failed"
  CHECK_RESULT $? 0 0 "Check ifpps --dev failed"
  CHECK_RESULT $? 0 0 "Check ifpps -t failed"
  CHECK_RESULT $? 0 0 "Check ifpps --interval failed"
  CHECK_RESULT $? 0 0 "Check ifpps -c failed"
  CHECK_RESULT $? 0 0 "Check ifpps --csv failed"
  CHECK_RESULT $? 0 0 "Check ifpps -l failed"
  CHECK_RESULT $? 0 0 "Check ifpps --loop failed"
```

- 涉及命令：ifpps×9, kill×2, tar×1

#### oe_test_ifpps_02

- 描述：Test ifpps
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check ifpps -m failed"
  CHECK_RESULT $? 0 0 "Check ifpps --median failed"
  CHECK_RESULT $? 0 0 "Check ifpps -o failed"
  CHECK_RESULT $? 0 0 "Check ifpps --omit-header failed"
  CHECK_RESULT $? 0 0 "Check ifpps -p failed"
  CHECK_RESULT $? 0 0 "Check ifpps --promisc failed"
  CHECK_RESULT $? 0 0 "Check ifpps -P failed"
  CHECK_RESULT $? 0 0 "Check ifpps --percentage failed"
  CHECK_RESULT $? 0 0 "Check ifpps -W failed"
  CHECK_RESULT $? 0 0 "Check ifpps --no-warn failed"
```

- 涉及命令：ifpps×8, kill×2, tar×1

#### oe_test_netsniff_ng_01

- 描述：Test netsniff-ng
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "Check netsniff-ng --help failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -h failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -v failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --version failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -i failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -d failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --dev failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --in failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --out failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -o failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --fanout-group failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -C failed"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：netsniff-ng×9, test×5, tar×1, kill×1

#### oe_test_netsniff_ng_02

- 描述：Test netsniff-ng
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Check netsniff-ng --interval failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -F failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -R failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --rfraw failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -n failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --num failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --prefix failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -P failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --overwrite failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -O failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -T failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --magic failed"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：netsniff-ng×2, tar×1, test×1, kill×1

#### oe_test_netsniff_ng_03

- 描述：Test netsniff-ng
- 函数：`pre_test, run_test, post_test`
- 断言（26 条）：

```
  CHECK_RESULT $? 0 0 "Check netsniff-ng -D failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --dump-pcap-types failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -B failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --dump-bpf failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -r failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --rand failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -M failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --no-promisc failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -A failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --no-sock-mem failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --no-hwtimestamp failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -N failed"
  ... 共 26 条（其余见源脚本）
```

- 涉及命令：tar×1, kill×1

#### oe_test_netsniff_ng_04

- 描述：Test netsniff-ng
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Check netsniff-ng -u failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --user failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -g failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --group failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -H failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --prio-high failed"
  CHECK_RESULT $? 1 0 "Check netsniff-ng -q failed"
  CHECK_RESULT $? 1 0 "Check netsniff-ng --less failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --notouch-irq failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -Q failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng -s failed"
  CHECK_RESULT $? 0 0 "Check netsniff-ng --silent failed"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：tar×1, kill×1, userdel×1

#### oe_test_trafgen_01

- 描述：Test trafgen
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Check trafgen -h failed"
  CHECK_RESULT $? 0 0 "Check trafgen --help failed"
  CHECK_RESULT $? 0 0 "Check trafgen -v failed"
  CHECK_RESULT $? 0 0 "Check trafgen --version failed"
  CHECK_RESULT $? 0 0 "Check trafgen -e failed"
  CHECK_RESULT $? 0 0 "Check trafgen --example failed"
  CHECK_RESULT $? 0 0 "Check trafgen --in failed"
  CHECK_RESULT $? 0 0 "Check trafgen -i failed"
  CHECK_RESULT $? 0 0 "Check trafgen -c failed"
  CHECK_RESULT $? 0 0 "Check trafgen --conf failed"
  CHECK_RESULT $? 0 0 "Check trafgen -o failed"
  CHECK_RESULT $? 0 0 "Check trafgen -d failed"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：trafgen×9, tar×1, kill×1

#### oe_test_trafgen_02

- 描述：Test trafgen
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Check trafgen --cpp failed"
  CHECK_RESULT $? 0 0 "Check trafgen -p failed"
  CHECK_RESULT $? 0 0 "Check trafgen --define failed"
  CHECK_RESULT $? 0 0 "Check trafgen -D failed"
  CHECK_RESULT $? 0 0 "Check trafgen -J failed"
  CHECK_RESULT $? 0 0 "Check trafgen --jumbo-support failed"
  CHECK_RESULT $? 0 0 "Check trafgen -R failed"
  CHECK_RESULT $? 0 0 "Check trafgen --rfraw failed"
  CHECK_RESULT $? 0 0 "Check trafgen --smoke-test failed"
  CHECK_RESULT $? 0 0 "Check trafgen -s failed"
  CHECK_RESULT $? 0 0 "Check trafgen -n failed"
  CHECK_RESULT $? 0 0 "Check trafgen -n failed"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：pkill×2, tar×1, trafgen×1

#### oe_test_trafgen_03

- 描述：Test trafgen
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Check trafgen --gap failed"
  CHECK_RESULT $? 0 0 "Check trafgen -t failed"
  CHECK_RESULT $? 0 0 "Check trafgen -b failed"
  CHECK_RESULT $? 0 0 "Check trafgen --rate failed"
  CHECK_RESULT $? 0 0 "Check trafgen -E failed"
  CHECK_RESULT $? 0 0 "Check trafgen --seed failed"
  CHECK_RESULT $? 0 0 "Check trafgen -u failed"
  CHECK_RESULT $? 0 0 "Check trafgen -user failed"
  CHECK_RESULT $? 0 0 "Check trafgen -g failed"
  CHECK_RESULT $? 0 0 "Check trafgen --group failed"
  CHECK_RESULT $? 0 0 "Check trafgen --prio-high failed"
  CHECK_RESULT $? 0 0 "Check trafgen -H failed"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：trafgen×6, tar×1
