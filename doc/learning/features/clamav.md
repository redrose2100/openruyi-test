# clamav

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/clamav` |
| 注册用例数 | 18 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_clamav-clamonacc | Test clamav-clamonacc.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_clamonacc | Test clamonacc.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_clamav-milter | Test clamav-milter.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_clamav-freshclam | Test clamav-freshclam.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_clamav_clamav-milter | Take the test clamav-milter | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_clamav_clambc | Take the test clambc execution | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_clamav_clamconf | Take the test clamconf generate config | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_clamav_clamdscan_scan | Take the test clamdscan service | pre_test/run_test/post_test | 9 | ✔ |  | 120m |
| oe_test_clamav_clamdscan_service | Take the test clamdscan service | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_clamav_clamdtop | Take the test clamdtop info | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_clamav_clamonacc | Take the test clamonacc(only for clamav version ≥ 0.103.2) | pre_test/run_test/post_test | 13 | ✔ | ✔ |  |
| oe_test_clamav_clamscan_1 | Take the test clamscan | pre_test/run_test/post_test | 11 | ✔ |  | 90m |
| oe_test_clamav_clamscan_2 | Take the test clamscan | pre_test/run_test/post_test | 28 | ✔ |  | 600m |
| oe_test_clamav_clamscan_3 | Take the test clamscan | pre_test/run_test/post_test | 14 | ✔ |  | 180m |
| oe_test_clamav_clamsubmit | Take the test clamsubmit & clamav-config | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_clamav_freshclam | Take the test freshclam | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_clamav_sigtool_1 | Take the test sigtool info cmd | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_clamav_sigtool_2 | Take the test sigtool normalise | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_clamav-clamonacc

- 描述：Test clamav-clamonacc.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：pgrep×1

#### oe_test_service_clamonacc

- 描述：Test clamonacc.service restart
- 函数：`pre_test, run_test, post_test`
- 涉及命令：pgrep×1

#### oe_test_service_clamav-milter

- 描述：Test clamav-milter.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_clamav-freshclam

- 描述：Test clamav-freshclam.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_clamav_clamav-milter

- 描述：Take the test clamav-milter
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Start clamav-milter.server failed."
  CHECK_RESULT $? 0 0 "Check clamav-milter.server active failed."
  CHECK_RESULT $? 0 0 "Stop clamav-milter.server failed."
  CHECK_RESULT $? 0 0 "Start clamav-milter.server inactive failed."
  CHECK_RESULT $? 0 0 "Check clamav-milter version failed."
  CHECK_RESULT $? 0 0 "Check clamav-milter help message failed."
  CHECK_RESULT $? 0 0 "Check /etc/mail/clamav-milter.conf config failed."
```

- 涉及命令：clamav-milter×1

#### oe_test_clamav_clambc

- 描述：Take the test clambc execution
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check clambc -f failed."
  CHECK_RESULT $? 0 0 "Check clambc -t failed."
  CHECK_RESULT $? 0 0 "Check clambc -i failed."
  CHECK_RESULT $? 0 0 "Check clambc -p failed."
  CHECK_RESULT $? 0 0 "Check clambc -c failed."
  CHECK_RESULT $? 0 0 "Check clambc -T failed."
  CHECK_RESULT $? 0 0 "Check clambc -s failed."
  CHECK_RESULT $? 0 0 "Check clambc --statistics failed."
  CHECK_RESULT $? 0 0 "Check clambc failed."
  CHECK_RESULT $? 0 0 "Check clambc --debug failed."
  CHECK_RESULT $? 0 0 "Check clambc version failed."
  CHECK_RESULT $? 0 0 "Check clambc help message failed."
```

- 涉及命令：clambc×9, sigtool×1

#### oe_test_clamav_clamconf

- 描述：Take the test clamconf generate config
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Execute clamconf -g clamd.d/scan.conf failed."
  CHECK_RESULT $? 0 0 "Execute clamconf -g freshclam.conf failed."
  CHECK_RESULT $? 0 0 "Execute clamconf -g mail/clamav-milter.conf failed."
  CHECK_RESULT $? 0 0 "Execute clamconf -g clamd.d/scan.conf failed."
  CHECK_RESULT $? 0 0 "Execute clamconf -g freshclam.conf failed."
  CHECK_RESULT $? 0 0 "Execute clamconf -g mail/clamav-milter.conf failed."
  CHECK_RESULT $? 0 0 "Check clamconf version failed."
  CHECK_RESULT $? 0 0 "Check clamconf help message failed."
  CHECK_RESULT $? 0 0 "Check clamconf non-default config failed."
```

- 涉及命令：clamconf×9

#### oe_test_clamav_clamdscan_scan

- 描述：Take the test clamdscan service
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check clamdscan  -v -l clamdscan_log /var/lib/clamav failed."
  CHECK_RESULT $? 0 0 "Check clamdscan --quiet failed."
  CHECK_RESULT $? 0 0 "Check clamdscan --remove failed."
  CHECK_RESULT $? 0 0 "Check clamdscan --move failed."
  CHECK_RESULT $? 0 0 "Check clamdscan --copy failed."
  CHECK_RESULT $? 0 0 "Check clamdscan --config-file failed."
  CHECK_RESULT $? 0 0 "Check clamdscan -i failed."
  CHECK_RESULT $? 0 0 "Check clamdscan --no-summary failed."
  CHECK_RESULT $? 0 0 "Check clamdscan --file-list failed."
```

- 涉及命令：clamdscan×2, mkdir×1

#### oe_test_clamav_clamdscan_service

- 描述：Take the test clamdscan service
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Start clamd@scan.service failed."
  CHECK_RESULT $? 0 0 "Check clamd@scan.service status failed."
  CHECK_RESULT $? 0 0 "Stop clamd@scan.service failed."
  CHECK_RESULT $? 0 0 "Check clamd@scan.service status failed."
  CHECK_RESULT $? 0 0 "Check clamdscan version failed."
  CHECK_RESULT $? 0 0 "Check clamdscan help message failed."
```

- 涉及命令：mkdir×1

#### oe_test_clamav_clamdtop

- 描述：Take the test clamdtop info
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Connecting to localhost failed."
  CHECK_RESULT $? 0 0 "Connecting /run/clamd.scan/clamd.sock failed."
  CHECK_RESULT $? 0 0 "Check clamdtop version failed."
  CHECK_RESULT $? 0 0 "Check clamdtop help message failed."
  CHECK_RESULT $? 0 0 "Check clamdtop -c message failed."
  CHECK_RESULT $? 0 0 "Execute clamdtop -d failed."
```

- 涉及命令：mkdir×1

#### oe_test_clamav_clamonacc

- 描述：Take the test clamonacc(only for clamav version ≥ 0.103.2)
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Execute clamonacc -v failed."
  CHECK_RESULT $? 0 0 "Execute clamonacc -w failed."
  CHECK_RESULT $? 0 0 "Execute clamonacc -W testfile failed."
  CHECK_RESULT $? 0 0 "Execute clamonacc -l clamonacc_log /opt --fdpass failed."
  CHECK_RESULT $? 0 0 "Execute clamonacc --exclude-list=testlist failed."
  CHECK_RESULT $? 0 0 "Execute clamonacc --config-file=/etc/clamd.d/scan.conf failed."
  CHECK_RESULT $? 0 0 "Execute clamonacc -p 3:1  -w failed."
  CHECK_RESULT $? 0 0 "Execute clamonacc --remove failed."
  CHECK_RESULT $? 0 0 "Execute clamonacc --move testdir /opt failed."
  CHECK_RESULT $? 0 0 "Execute clamonacc --copy testdir /opt failed."
  CHECK_RESULT $? 0 0 "Execute clamonacc -z failed."
  CHECK_RESULT $? 0 0 "Execute clamonacc --stream failed."
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：clamonacc×7, mkdir×1, grep×1, pgrep×1

#### oe_test_clamav_clamscan_1

- 描述：Take the test clamscan
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check clamscan version failed."
  CHECK_RESULT $? 0 0 "Check clamscan help failed."
  CHECK_RESULT $? 0 0 "Check clamscan -a failed." >/dev/null
  CHECK_RESULT $? 0 0 "Check clamscan -v failed." >/dev/null
  CHECK_RESULT $? 0 0 "Check clamscan --debug failed." >/dev/null
  CHECK_RESULT $? 0 0 "Check clamscan --quiet --stdout failed." >/dev/null
  CHECK_RESULT $? 0 0 "Check clamscan --no-summary failed." >/dev/null
  CHECK_RESULT $? 0 0 "Check clamscan -i failed." >/dev/null
  CHECK_RESULT $? 0 0 "Check clamscan --bell failed." >/dev/null
  CHECK_RESULT $? 0 0 "Check clamscan -r failed." >/dev/null
  CHECK_RESULT $? 0 0 "Check clamscan -o failed." >/dev/null
```

- 涉及命令：clamscan×5

#### oe_test_clamav_clamscan_2

- 描述：Take the test clamscan
- 函数：`pre_test, run_test, post_test`
- 断言（28 条）：

```
  CHECK_RESULT $? 0 0 "Check clamscan --alert-macros=no failed."
  CHECK_RESULT $? 0 0 "Check clamscan --max-scansize=40 failed."
  CHECK_RESULT $? 0 0 "Check clamscan --exclude=REGEX failed."
  CHECK_RESULT $? 0 0 "Check clamscan --exclude-pua=CAT failed."
  CHECK_RESULT $? 0 0 "Check clamscan --pcre-max-filesize=50 failed."
  CHECK_RESULT $? 0 0 "Check clamscan --bell -i failed."
  CHECK_RESULT $? 0 0 "Check clamscan -i --remove --recursive /opt --max-dir-recursion=5 -l test_clamscan.log failed."
  CHECK_RESULT $? 0 0 "Check clamscan --no-summary -ri /opt failed."
  CHECK_RESULT $? 0 0 "Check clamscan  -r --move=test_virus_collection/ /opt/ failed."
  CHECK_RESULT $? 0 0 "Check clamscan  -r --copy=test_virus_collection/ /opt/ failed."
  CHECK_RESULT $? 0 0 "Check clamscan --max-dir-recursion=5 failed."
  CHECK_RESULT $? 0 0 "Check clamscan --official-db-only failed."
  ... 共 28 条（其余见源脚本）
```

- 涉及命令：clamscan×5

#### oe_test_clamav_clamscan_3

- 描述：Take the test clamscan
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Check clamscan --max-recursion 1024 --max-dir-recursion 10 --max-embeddedpe 10 --max-htmlnormalize 10 failed."
  CHECK_RESULT $? 0 0 "Check clamscan --allmatch test_virus_collection --include=REGEX --include-dir=REGEX --max-htmlnotags 5 --max-scriptnormalize 5 failed."
  CHECK_RESULT $? 0 0 "Check clamscan -z test_virus_collection --cross-fs /opt --max-filesize 1024 --max-ziptypercg 5 failed."
  CHECK_RESULT $? 0 0 "Check clamscan --follow-dir-symlinks 0 --max-scansize 1024 failed."
  CHECK_RESULT $? 0 0 "Check clamscan --follow-file-symlinks 0 --max-files 1024 --max-ziptypercg 5 failed."
  CHECK_RESULT $? 0 0 "Check clamscan --file-list /opt --exclude-dir=REGEX --max-partitions 5 --max-iconspe 5 failed."
  CHECK_RESULT $? 0 0 "Check clamscan --bytecode test_virus_collection --bytecode-timeout 50 --max-rechwp3 5 failed."
  CHECK_RESULT $? 0 0 "Check clamscan --bytecode-unsigned test_virus_collection --statistics bytecode --pcre-match-limit 5 failed."
  CHECK_RESULT $? 0 0 "Check clamscan --detect-pua test_virus_collection  --pcre-recmatch-limit 5 --phishing-sigs test_virus_collection --statistics pcre failed."
  CHECK_RESULT $? 0 0 "Check clamscan --include-pua=CAT --detect-structured test_virus_collection --structured-ssn-format=2 --pcre-max-filesize 5 --statistics none failed."
  CHECK_RESULT $? 0 0 "Check clamscan --structured-ssn-count 1 --structured-cc-count 1 --scan-mail test_virus_collection --disable-cache failed."
  CHECK_RESULT $? 0 0 "Check clamscan --phishing-scan-urls test_virus_collection --heuristic-alerts test_virus_collection --heuristic-scan-precedence test_virus_collection failed."
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：clamscan×1

#### oe_test_clamav_clamsubmit

- 描述：Take the test clamsubmit & clamav-config
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Set clamsubmit name failed."
  CHECK_RESULT $? 0 0 "Set clamsubmit email failed."
  CHECK_RESULT $? 0 0 "Check virush failed."
  CHECK_RESULT $? 0 0 "Check clamsubmit version failed."
  CHECK_RESULT $? 0 0 "Check clamsubmit help message failed."
  CHECK_RESULT $? 0 0 "Check clambc help message failed."
  CHECK_RESULT $? 0 0 "Check clambc help message failed."
  CHECK_RESULT $? 0 0 "Check clambc help message failed."
  CHECK_RESULT $? 0 0 "Check clambc help message failed."
  CHECK_RESULT $? 0 0 "Check clambc help message failed."
```

- 涉及命令：clamsubmit×3

#### oe_test_clamav_freshclam

- 描述：Take the test freshclam
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Execute freshclam failed."
  CHECK_RESULT $? 0 0 "Execute freshclam --debug failed."
  CHECK_RESULT $? 0 0 "Execute freshclam --quiet failed."
  CHECK_RESULT $? 0 0 "Execute freshclam --no-warnings failed."
  CHECK_RESULT $? 0 0 "Execute freshclam --show-progress failed."
  CHECK_RESULT $? 0 0 "Execute freshclam -d -p pid_log failed."
  CHECK_RESULT $? 0 0 "Execute freshclam -u root failed."
  CHECK_RESULT $? 0 0 "Execute freshclam --no-dns failed."
  CHECK_RESULT $? 0 0 "Execute freshclam -c 3 failed."
  CHECK_RESULT $? 0 0 "Execute freshclam --datadir /opt failed."
  CHECK_RESULT $? 0 0 "Execute freshclam --daemon-notify failed."
  CHECK_RESULT $? 0 0 "Execute freshclam --update-db main -a localhost failed."
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：freshclam×3

#### oe_test_clamav_sigtool_1

- 描述：Take the test sigtool info cmd
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check hex-dump 2 failed."
  CHECK_RESULT $? 0 0 "Check hex-dump 100 failed."
  CHECK_RESULT $? 0 0 "Check md5 failed."
  CHECK_RESULT $? 0 0 "Check sha1 failed."
  CHECK_RESULT $? 0 0 "Check sha256 failed."
  CHECK_RESULT $? 0 0 "Checkinfo failed."
  CHECK_RESULT $? 0 0 "Check info with flevel,cvd-version,no-cdiff,unsigned,hybrid failed."
  CHECK_RESULT $? 0 0 "Check sigtool -i failed."
  CHECK_RESULT $? 0 0 "Check sigtool -i --debug failed."
  CHECK_RESULT $? 0 0 "Execute sigtool -u cmd failed."
  CHECK_RESULT $? 0 0 "Execute sigtool -unpack cmd failed."
```

- 涉及命令：sigtool×3

#### oe_test_clamav_sigtool_2

- 描述：Take the test sigtool normalise
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Set --html-normalise failed."
  CHECK_RESULT $? 0 0 "Set --ascii-normalise failed."
  CHECK_RESULT $? 0 0 "Set --utf16-decode failed."
  CHECK_RESULT $? 0 0 "Set --vba failed."
  CHECK_RESULT $? 0 0 "Set --vba-hex failed."
  CHECK_RESULT $? 0 0 "Check compare failed."
  CHECK_RESULT $? 0 0 "Check diff failed."
  CHECK_RESULT $? 0 0 "Set mdb failed."
  CHECK_RESULT $? 0 0 "Set imp failed."
  CHECK_RESULT $? 0 0 "Check sigtool --version failed."
  CHECK_RESULT $? 0 0 "Check sigtool -h failed."
```

- 涉及命令：sigtool×1
