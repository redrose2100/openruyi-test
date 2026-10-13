# pcp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pcp` |
| 注册用例数 | 81 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_dbpmda | pcp testing(dbpmda) | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pcp | pcp testing(pcp) | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_pmdate | pcp testing(pmdate) | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pmdumplog_01 | pcp testing(pmdumplog) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pmdumplog_02 | pcp testing(pmdumplog) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pmevent_01 | pcp testing(pmevent) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pmevent_02 | pcp testing(pmevent) | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pmfind_pmgenmap_pmie2col_pminfo_01 | pcp testing(pmfind,pmgenmap,pmie2col,pminfo) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pminfo_02 | pcp testing(pminfo) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pminfo_03 | pcp testing(pminfo) | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_pmjson | pcp testing(pmjson) | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_pmlogcheck_pmlogmv | pcp testing(pmlogcheck,pmlogmv) | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_pmlogconf_pmlogsize | pcp testing(pmlogconf,pmlogsize) | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_pmloglabel | pcp testing(pmloglabel) | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_pmlogsummary_01 | pcp testing(pmlogsummary) | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_pmlogsummary_02 | pcp testing(pmlogsummary) | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_pmprobe_01 | pcp testing(pmprobe) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pmprobe_02 | pcp testing(pmprobe) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pmpython_mkaf_pcp-python | pcp testing(pmpython,mkaf,pcp-python) | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_pmstat | pcp testing(pmstat) | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_pmstore_install-sh | pcp testing(pmstore,install-sh) | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_pmval_01 | pcp testing(pmval) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pmval_02 | pcp testing(pmval) | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_pcp-summary_pcp-vmstat_pmcd_wait | pcp testing(pcp-summary,pcp-vmstat,pmcd_wait) | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_pmconfig_pmie_check | pcp testing(pmconfig,pmie_check) | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_pmhostname_pmlock_pmlogger_check | pcp testing(pmhostname,pmlock,pmlogger_check) | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_pmlogger_daily_01 | pcp testing(pmlogger_daily) | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_pmlogger_daily_02 | pcp testing(pmlogger_daily) | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_pmlogger_daily_report | (pcp-zeroconf) pmlogger_daily_report - write Performance Co-Pilot daily summary reports | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_pmlogger_merge_pmlogger_rewrite | pcp testing(pmlogger_merge,pmlogger_rewrite) | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_pmlogreduce_pmpause_pmpost_pmsleep | pcp testing(pmlogreduce,pmpause,pmpost,pmsleep) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pcp_atop_01 | (pcp-system-tools) (pcp-atop) | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_pcp_atop_02 | (pcp-system-tools) (pcp-atop) | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_pcp_pcp-import-collectl2pcp | The usage of commands in pcp-import-collectl2pcp binary package | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_pcp_pcp-import-ganglia2pcp | The usage of commands in pcp-import-ganglia2pcp binary package | pre_test/run_test/post_test | 3 | ✔ | ✔ |  |
| oe_test_pcp_pcp-import-iostat2pcp | The usage of commands in pcp-import-iostat2pcp binary package | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_pcp_pcp-import-mrtg2pcp | The usage of commands in pcp-import-mrtg2pcp binary package | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_pcp_pcp-import-sar2pcp | The usage of commands in pcp-import-sar2pcp binary package | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_service_pmcd | Test pmcd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_pmie | Test pmie.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_pmlogger | Test pmlogger.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_pmproxy | Test pmproxy.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_pcp2json_01 | (pcp-export-pcp2json) pcp2json - pcp-to-json metrics exporter | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pcp2json_02 | (pcp-export-pcp2json) pcp2json - pcp-to-json metrics exporter | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_pcp2json_03 | (pcp-export-pcp2json) pcp2json - pcp-to-json metrics exporter | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pcp2json_04 | (pcp-export-pcp2json) pcp2json - pcp-to-json metrics exporter | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pcp2json_05 | (pcp-export-pcp2json) pcp2json - pcp-to-json metrics exporter | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_pcp2xml_01 | (pcp-export-pcp2xml) pcp2xml - pcp-to-xml metrics exporter | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pcp2xml_02 | (pcp-export-pcp2xml) pcp2xml - pcp-to-xml metrics exporter | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_pcp2xml_03 | (pcp-export-pcp2xml) pcp2xml - pcp-to-xml metrics exporter | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pcp2xml_04 | (pcp-export-pcp2xml) pcp2xml - pcp-to-xml metrics exporter | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_pmdumptext_001 | pmdumptext -A -T test | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pmdumptext_002 | pmdumptext -d test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pmdumptext_003 | pmdumptext -N -P -R -U test | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pcp-pmda-elasticsearch | test pcp-pmda-elasticsearch | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_pmrep_01 | (pcp-system-tools) (pmrep) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pmrep_02 | (pcp-system-tools) (pmrep) | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_pmrep_03 | (pcp-system-tools) (pmrep) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pmrep_04 | (pcp-system-tools) (pmrep) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pmrep_05 | (pcp-system-tools) (pmrep) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pmrep_06 | (pcp-system-tools) (pmrep) | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_pcp_collectl | (pcp-system-tools) (pcp-collectl) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pcp_dmcache | (pcp-system-tools) (pcp-dmcache,pcp-lvmcache) | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_dstat_01 | (pcp-system-tools) (pcp-dstat) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_dstat_02 | (pcp-system-tools) (pcp-dstat) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_dstat_03 | (pcp-system-tools) (pcp-dstat) | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_pcp_free | (pcp-system-tools) (pcp-free) | pre_test/run_test/post_test | 16 |  |  |  |
| oe_test_pcp-pidstat_01 | (pcp-system-tools) (pcp-pidstat) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pcp-pidstat_02_pcp-ipcs | (pcp-system-tools) (pcp-pidstat,pcp-ipcs) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pcp-iostat | (pcp-system-tools) (pcp-iostat) | pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_pcp-mpstat_pcp-numastat | (pcp-system-tools) (pcp-mpstat,pcp-numastat) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_pcp-uptime_pcp-verify | (pcp-system-tools) (pcp-uptime,pcp-verify) | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_service_pcp-geolocate | Test pcp-geolocate.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_pcp-reboot-init | Test pcp-reboot-init.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_pmfind | Test pmfind.service restart | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_service_pmie_check | Test pmie_check.service restart | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_service_pmie_daily | Test pmie_daily.service restart | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_service_pmie_farm_check | Test pmie_farm_check.service restart | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_service_pmlogger_check | Test pmlogger_check.service restart | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_service_pmlogger_daily | Test pmlogger_daily.service restart | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_service_pmlogger_farm_check | Test pmlogger_farm_check.service restart | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_dbpmda

- 描述：pcp testing(dbpmda)
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 1 0 'dbpmda_n Command executed failed'
  CHECK_RESULT $? 1 0 'dbpmda_f Command executed failed'
  CHECK_RESULT $? 1 0 'dbpmda_q Command executed failed'
  CHECK_RESULT $? 1 0 'dbpmda_U Command executed failed'
  CHECK_RESULT $? 1 0 'dbpmda_e Command executed failed'
  CHECK_RESULT $?
```

- 涉及命令：grep×5

#### oe_test_pcp

- 描述：pcp testing(pcp)
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

- 涉及命令：pcp×10

#### oe_test_pmdate

- 描述：pcp testing(pmdate)
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

- 涉及命令：pmdate×3

#### oe_test_pmdumplog_01

- 描述：pcp testing(pmdumplog)
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

- 涉及命令：pmdumplog×8

#### oe_test_pmdumplog_02

- 描述：pcp testing(pmdumplog)
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

- 涉及命令：pmdumplog×9

#### oe_test_pmevent_01

- 描述：pcp testing(pmevent)
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

- 涉及命令：pmevent×8

#### oe_test_pmevent_02

- 描述：pcp testing(pmevent)
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

- 涉及命令：pmevent×8

#### oe_test_pmfind_pmgenmap_pmie2col_pminfo_01

- 描述：pcp testing(pmfind,pmgenmap,pmie2col,pminfo)
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

- 涉及命令：pminfo×4

#### oe_test_pminfo_02

- 描述：pcp testing(pminfo)
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

- 涉及命令：pminfo×9

#### oe_test_pminfo_03

- 描述：pcp testing(pminfo)
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

- 涉及命令：pminfo×10

#### oe_test_pmjson

- 描述：pcp testing(pmjson)
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

- 涉及命令：pmjson×6

#### oe_test_pmlogcheck_pmlogmv

- 描述：pcp testing(pmlogcheck,pmlogmv)
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

- 涉及命令：pmlogcheck×7, pmlogmv×1

#### oe_test_pmlogconf_pmlogsize

- 描述：pcp testing(pmlogconf,pmlogsize)
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

- 涉及命令：pmlogconf×4, pmlogsize×4, test×2

#### oe_test_pmloglabel

- 描述：pcp testing(pmloglabel)
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

- 涉及命令：pmloglabel×8

#### oe_test_pmlogsummary_01

- 描述：pcp testing(pmlogsummary)
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

- 涉及命令：pmlogsummary×9

#### oe_test_pmlogsummary_02

- 描述：pcp testing(pmlogsummary)
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

- 涉及命令：pmlogsummary×10

#### oe_test_pmprobe_01

- 描述：pcp testing(pmprobe)
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

- 涉及命令：pmprobe×6

#### oe_test_pmprobe_02

- 描述：pcp testing(pmprobe)
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

- 涉及命令：pmprobe×9

#### oe_test_pmpython_mkaf_pcp-python

- 描述：pcp testing(pmpython,mkaf,pcp-python)
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

#### oe_test_pmstat

- 描述：pcp testing(pmstat)
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

- 涉及命令：pmstat×11

#### oe_test_pmstore_install-sh

- 描述：pcp testing(pmstore,install-sh)
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

- 涉及命令：pmstore×6, test×2

#### oe_test_pmval_01

- 描述：pcp testing(pmval)
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

- 涉及命令：pmval×8

#### oe_test_pmval_02

- 描述：pcp testing(pmval)
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

- 涉及命令：pmval×7

#### oe_test_pcp-summary_pcp-vmstat_pmcd_wait

- 描述：pcp testing(pcp-summary,pcp-vmstat,pmcd_wait)
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

#### oe_test_pmconfig_pmie_check

- 描述：pcp testing(pmconfig,pmie_check)
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

- 涉及命令：test×2

#### oe_test_pmhostname_pmlock_pmlogger_check

- 描述：pcp testing(pmhostname,pmlock,pmlogger_check)
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

- 涉及命令：test×2, pgrep×1

#### oe_test_pmlogger_daily_01

- 描述：pcp testing(pmlogger_daily)
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

- 涉及命令：test×2, kill×1

#### oe_test_pmlogger_daily_02

- 描述：pcp testing(pmlogger_daily)
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

#### oe_test_pmlogger_daily_report

- 描述：(pcp-zeroconf) pmlogger_daily_report - write Performance Co-Pilot daily summary reports
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "-a option check failed"
  CHECK_RESULT $? 0 0 "/var/log/pcp/sa check failed"
  CHECK_RESULT $? 0 0 "-f option check failed"
  CHECK_RESULT $? 0 0 "-h option check failed"
  CHECK_RESULT $? 0 0 "-l option check failed"
  CHECK_RESULT $? 0 0 "dailyReport.txt check failed"
  CHECK_RESULT $? 0 0 "-p option check failed"
  CHECK_RESULT $? 0 0 "-o option check failed"
  CHECK_RESULT $? 0 0 "/var/log/pcp/ba check failed"
  CHECK_RESULT $? 0 0 "-t option check failed"
  CHECK_RESULT $? 0 0 "-AV option check failed"
  CHECK_RESULT $? 0 0 "pmlogger_daily_report.log check failed"
```

- 涉及命令：test×2

#### oe_test_pmlogger_merge_pmlogger_rewrite

- 描述：pcp testing(pmlogger_merge,pmlogger_rewrite)
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

#### oe_test_pmlogreduce_pmpause_pmpost_pmsleep

- 描述：pcp testing(pmlogreduce,pmpause,pmpost,pmsleep)
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

- 涉及命令：kill×1

#### oe_test_pcp_atop_01

- 描述：(pcp-system-tools) (pcp-atop)
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

- 涉及命令：kill×1

#### oe_test_pcp_atop_02

- 描述：(pcp-system-tools) (pcp-atop)
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

- 涉及命令：test×2, kill×1

#### oe_test_pcp_pcp-import-collectl2pcp

- 描述：The usage of commands in pcp-import-collectl2pcp binary package
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2, wget×1, collectl×1, collectl2pcp×1

#### oe_test_pcp_pcp-import-ganglia2pcp

- 描述：The usage of commands in pcp-import-ganglia2pcp binary package
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：sed×6, ganglia2pcp×1, grep×1, test×1

#### oe_test_pcp_pcp-import-iostat2pcp

- 描述：The usage of commands in pcp-import-iostat2pcp binary package
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×6, iostat2pcp×4, iostat×1

#### oe_test_pcp_pcp-import-mrtg2pcp

- 描述：The usage of commands in pcp-import-mrtg2pcp binary package
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×1, test×1

#### oe_test_pcp_pcp-import-sar2pcp

- 描述：The usage of commands in pcp-import-sar2pcp binary package
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×2, grep×1

#### oe_test_service_pmcd

- 描述：Test pmcd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_pmie

- 描述：Test pmie.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_pmlogger

- 描述：Test pmlogger.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_pmproxy

- 描述：Test pmproxy.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_pcp2json_01

- 描述：(pcp-export-pcp2json) pcp2json - pcp-to-json metrics exporter
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

- 涉及命令：pcp2json×6

#### oe_test_pcp2json_02

- 描述：(pcp-export-pcp2json) pcp2json - pcp-to-json metrics exporter
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

- 涉及命令：pcp2json×8, kill×1

#### oe_test_pcp2json_03

- 描述：(pcp-export-pcp2json) pcp2json - pcp-to-json metrics exporter
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

- 涉及命令：pcp2json×9

#### oe_test_pcp2json_04

- 描述：(pcp-export-pcp2json) pcp2json - pcp-to-json metrics exporter
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

- 涉及命令：pcp2json×9

#### oe_test_pcp2json_05

- 描述：(pcp-export-pcp2json) pcp2json - pcp-to-json metrics exporter
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：pcp2json×4

#### oe_test_pcp2xml_01

- 描述：(pcp-export-pcp2xml) pcp2xml - pcp-to-xml metrics exporter
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

- 涉及命令：pcp2xml×6

#### oe_test_pcp2xml_02

- 描述：(pcp-export-pcp2xml) pcp2xml - pcp-to-xml metrics exporter
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

- 涉及命令：pcp2xml×8, kill×1

#### oe_test_pcp2xml_03

- 描述：(pcp-export-pcp2xml) pcp2xml - pcp-to-xml metrics exporter
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

- 涉及命令：pcp2xml×9

#### oe_test_pcp2xml_04

- 描述：(pcp-export-pcp2xml) pcp2xml - pcp-to-xml metrics exporter
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

- 涉及命令：pcp2xml×12

#### oe_test_pmdumptext_001

- 描述：pmdumptext -A -T test
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

- 涉及命令：pmdumptext×5

#### oe_test_pmdumptext_002

- 描述：pmdumptext -d test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

- 涉及命令：pmdumptext×1

#### oe_test_pmdumptext_003

- 描述：pmdumptext -N -P -R -U test
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $?
```

#### oe_test_pcp-pmda-elasticsearch

- 描述：test pcp-pmda-elasticsearch
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "domain.h pmns not exist"
  CHECK_RESULT $? 0 0 "domain.h.python pmns.python not exist"
```

#### oe_test_pmrep_01

- 描述：(pcp-system-tools) (pmrep)
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

- 涉及命令：pmrep×6

#### oe_test_pmrep_02

- 描述：(pcp-system-tools) (pmrep)
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

- 涉及命令：pmrep×8

#### oe_test_pmrep_03

- 描述：(pcp-system-tools) (pmrep)
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

- 涉及命令：pmrep×9

#### oe_test_pmrep_04

- 描述：(pcp-system-tools) (pmrep)
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

- 涉及命令：pmrep×9

#### oe_test_pmrep_05

- 描述：(pcp-system-tools) (pmrep)
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

- 涉及命令：pmrep×9

#### oe_test_pmrep_06

- 描述：(pcp-system-tools) (pmrep)
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

- 涉及命令：pmrep×6

#### oe_test_pcp_collectl

- 描述：(pcp-system-tools) (pcp-collectl)
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

- 涉及命令：pcp-collectl×6, pmcollectl×1

#### oe_test_pcp_dmcache

- 描述：(pcp-system-tools) (pcp-dmcache,pcp-lvmcache)
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kill×1

#### oe_test_dstat_01

- 描述：(pcp-system-tools) (pcp-dstat)
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

- 涉及命令：kill×7

#### oe_test_dstat_02

- 描述：(pcp-system-tools) (pcp-dstat)
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

- 涉及命令：kill×9

#### oe_test_dstat_03

- 描述：(pcp-system-tools) (pcp-dstat)
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

- 涉及命令：kill×9

#### oe_test_pcp_free

- 描述：(pcp-system-tools) (pcp-free)
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

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
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：pcp-free×1

#### oe_test_pcp-pidstat_01

- 描述：(pcp-system-tools) (pcp-pidstat)
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

- 涉及命令：pcp-pidstat×7

#### oe_test_pcp-pidstat_02_pcp-ipcs

- 描述：(pcp-system-tools) (pcp-pidstat,pcp-ipcs)
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

- 涉及命令：pcp-pidstat×5, pcp-ipcs×2, pmlogger_check×1

#### oe_test_pcp-iostat

- 描述：(pcp-system-tools) (pcp-iostat)
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

- 涉及命令：pcp-iostat×11

#### oe_test_pcp-mpstat_pcp-numastat

- 描述：(pcp-system-tools) (pcp-mpstat,pcp-numastat)
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

- 涉及命令：pcp-mpstat×5, pcp-numastat×1

#### oe_test_pcp-uptime_pcp-verify

- 描述：(pcp-system-tools) (pcp-uptime,pcp-verify)
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

- 涉及命令：pcp-verify×5, mkdir×1, chown×1

#### oe_test_service_pcp-geolocate

- 描述：Test pcp-geolocate.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "There is an error for the status of pcp-geolocate.service"
  CHECK_RESULT $? 0 1 "There is an error message for the log of pcp-geolocate.service"
```

#### oe_test_service_pcp-reboot-init

- 描述：Test pcp-reboot-init.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_pmfind

- 描述：Test pmfind.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
  CHECK_RESULT $? 0 0 "readonly-root.service reload causes the service status to change"
```

#### oe_test_service_pmie_check

- 描述：Test pmie_check.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
  CHECK_RESULT $? 0 0 "readonly-root.service reload causes the service status to change"
```

#### oe_test_service_pmie_daily

- 描述：Test pmie_daily.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
  CHECK_RESULT $? 0 0 "readonly-root.service reload causes the service status to change"
```

#### oe_test_service_pmie_farm_check

- 描述：Test pmie_farm_check.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
  CHECK_RESULT $? 0 0 "readonly-root.service reload causes the service status to change"
```

#### oe_test_service_pmlogger_check

- 描述：Test pmlogger_check.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
  CHECK_RESULT $? 0 0 "readonly-root.service reload causes the service status to change"
```

#### oe_test_service_pmlogger_daily

- 描述：Test pmlogger_daily.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
  CHECK_RESULT $? 0 0 "readonly-root.service reload causes the service status to change"
```

#### oe_test_service_pmlogger_farm_check

- 描述：Test pmlogger_farm_check.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} restart failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} stop failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 0 "${service} start failed"
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
  CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
  CHECK_RESULT $? 0 0 "readonly-root.service reload causes the service status to change"
```
