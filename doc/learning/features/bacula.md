# bacula

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/bacula` |
| 注册用例数 | 31 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_bacula-dir | Test bacula-dir.service restart | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_service_bacula-fd | Test bacula-fd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_bacula-sd | Test bacula-sd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_bacula_bconsole_01 | Test bconsole | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_bacula_bconsole_02 | Test bconsole | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_bacula_bcopy_01 | Test bcopy | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_bacula_bdirjson_01 | Test bdirjson | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_bacula_bdirjson_02 | Test bdirjson | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_bacula_bsdjson_01 | Test bsdjson | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_bacula_bfdjson_01 | Test bfdjson | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_bacula_bscan_01 | Test bscan | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_bacula_bscan_02 | Test bscan | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_bacula_bregex_01 | Test bregex | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_bacula_bextract_01 | Test bextract | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_bacula_bextract_02 | Test bextract | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_bacula_bwild_01 | Test bwild | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_bacula_dbcheck_01 | Test dbcheck | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_bacula_bls_01 | Test bls | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_bacula_bls_02 | Test bls | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_bacula_btape_01 | Test btape | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_bacula_btape_02 | Test btape | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_bacula_btape_03 | Test btape | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_bacula_btape_04 | Test btape | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_bacula_bacula_fd_01 | Test bacula-fd | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_bacula_bacula_sd_01 | Test bacula-sd | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_bacula_bacula_sd_02 | Test bacula-sd | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_bacula_bacula_dir_01 | Test bacula-dir | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_bacula_bacula_dir_02 | Test bacula-dir | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_bacula_bbconsjson_01 | Test bconsjson | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_bacula_bsmtp_01 | Test bsmtp & btraceback | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_bacula_client | test bacula-client | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_bacula-dir

- 描述：Test bacula-dir.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit bacula-dir.service"
  CHECK_RESULT $? 0 0 "bacula-dir.service reload causes the service status to change"
```

- 涉及命令：chown×1

#### oe_test_service_bacula-fd

- 描述：Test bacula-fd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_bacula-sd

- 描述：Test bacula-sd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_bacula_bconsole_01

- 描述：Test bconsole
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "test bconsole -D failed"
  CHECK_RESULT $? 0 0 "test bconsole -l failed"
  CHECK_RESULT $? 0 0 "test bconsole -L failed"
  CHECK_RESULT $? 0 0 "test bconsole -C failed"
  CHECK_RESULT $? 0 0 "test bconsole -c failed"
  CHECK_RESULT $? 0 0 "test bconsole -d failed"
  CHECK_RESULT $? 0 0 "test bconsole -dt failed"
  CHECK_RESULT $? 0 0 "test bconsole -n failed"
  CHECK_RESULT $? 0 0 "test bconsole -s failed"
```

- 涉及命令：bconsole×3, sed×2, tar×1

#### oe_test_bacula_bconsole_02

- 描述：Test bconsole
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test bconsole -u failed"
  CHECK_RESULT $? 0 0 "test bconsole -t failed"
  CHECK_RESULT $? 0 0 "test bconsole -? failed"
```

- 涉及命令：sed×2, tar×1, bconsole×1

#### oe_test_bacula_bcopy_01

- 描述：Test bcopy
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "test bcopy -b failed"
  CHECK_RESULT $? 0 0 "test bcopy -c failed"
  CHECK_RESULT $? 0 0 "test bcopy -i -o failed"
  CHECK_RESULT $? 0 0 "test bcopy -d failed"
  CHECK_RESULT $? 0 0 "test bcopy -dt failed"
  CHECK_RESULT $? 0 0 "test bcopy -p failed"
  CHECK_RESULT $? 0 0 "test bcopy -w failed"
  CHECK_RESULT $? 0 0 "test bcopy -v failed"
  CHECK_RESULT $? 0 0 "test bcopy -? failed"
```

- 涉及命令：bcopy×8, sed×2, tar×1

#### oe_test_bacula_bdirjson_01

- 描述：Test bdirjson
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "test bdirjson -v failed"
  CHECK_RESULT $? 0 0 "test bdirjson -t failed"
  CHECK_RESULT $? 0 0 "test bdirjson -r failed"
  CHECK_RESULT $? 0 0 "test bdirjson -l failed"
  CHECK_RESULT $? 0 0 "test bdirjson -n failed"
  CHECK_RESULT $? 0 0 "test bdirjson -D failed"
  CHECK_RESULT $? 0 0 "test bdirjson -c failed"
  CHECK_RESULT $? 0 0 "test bdirjson -d failed"
  CHECK_RESULT $? 0 0 "test bdirjson -? failed"
```

- 涉及命令：bdirjson×9, tar×1

#### oe_test_bacula_bdirjson_02

- 描述：Test bdirjson
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test bdirjson -R failed"
  CHECK_RESULT $? 0 0 "test bdirjson -dt failed"
  CHECK_RESULT $? 0 0 "test bdirjson -s failed"
```

- 涉及命令：bdirjson×3, tar×1

#### oe_test_bacula_bsdjson_01

- 描述：Test bsdjson
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test bsdjson -? failed"
  CHECK_RESULT $? 0 0 "test bsdjson -r failed"
  CHECK_RESULT $? 0 0 "test bsdjson -n failed"
  CHECK_RESULT $? 0 0 "test bsdjson -l failed"
  CHECK_RESULT $? 0 0 "test bsdjson -D failed"
  CHECK_RESULT $? 0 0 "test bsdjson -c failed"
  CHECK_RESULT $? 0 0 "test bsdjson -d failed"
  CHECK_RESULT $? 0 0 "test bsdjson -dt failed"
  CHECK_RESULT $? 0 0 "test bsdjson -t failed"
  CHECK_RESULT $? 0 0 "test bsdjson -v failed"
```

- 涉及命令：bsdjson×9, tar×1

#### oe_test_bacula_bfdjson_01

- 描述：Test bfdjson
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test bfdjson -? failed"
  CHECK_RESULT $? 0 0 "test bfdjson -r failed"
  CHECK_RESULT $? 0 0 "test bfdjson -n failed"
  CHECK_RESULT $? 0 0 "test bfdjson -l failed"
  CHECK_RESULT $? 0 0 "test bfdjson -D failed"
  CHECK_RESULT $? 0 0 "test bfdjson -C failed"
  CHECK_RESULT $? 0 0 "test bfdjson -d failed"
  CHECK_RESULT $? 0 0 "test bfdjson -dt failed"
  CHECK_RESULT $? 0 0 "test bfdjson -t failed"
  CHECK_RESULT $? 0 0 "test bfdjson -v failed"
```

- 涉及命令：bfdjson×9, tar×1

#### oe_test_bacula_bscan_01

- 描述：Test bscan
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "test bscan -? failed"
  CHECK_RESULT $? 0 0 "test bscan -V -n -u -P -h -t failed"
  CHECK_RESULT $? 0 0 "test bscan -r failed"
  CHECK_RESULT $? 0 0 "test bscan -s -v -S failed"
  CHECK_RESULT $? 0 0 "test bscan -w failed"
```

- 涉及命令：bscan×3, sed×2, tar×1

#### oe_test_bacula_bscan_02

- 描述：Test bscan
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "test bscan -m -n failed"
  CHECK_RESULT $? 0 0 "test bscan -d failed"
  CHECK_RESULT $? 0 0 "test bscan -dt failed"
  CHECK_RESULT $? 0 0 "test bscan -D failed"
  CHECK_RESULT $? 0 0 "test bscan -b failed"
  CHECK_RESULT $? 0 0 "test bscan -c failed"
```

- 涉及命令：bscan×6, sed×2, tar×1

#### oe_test_bacula_bregex_01

- 描述：Test bregex
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "test bregex -f failed"
  CHECK_RESULT $? 0 0 "test bregex -d failed"
  CHECK_RESULT $? 0 0 "test bregex -l failed"
  CHECK_RESULT $? 0 0 "test bregex -n failed"
  CHECK_RESULT $? 0 0 "test bregex -dt failed"
  CHECK_RESULT $? 0 0 "test bregex -? failed"
```

- 涉及命令：tar×1, grep×1

#### oe_test_bacula_bextract_01

- 描述：Test bextract
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "test bextract -? failed"
  CHECK_RESULT $? 0 0 "test bextract -c failed"
  CHECK_RESULT $? 0 0 "test bextract -b failed"
  CHECK_RESULT $? 0 0 "test bextract -v failed"
  CHECK_RESULT $? 0 0 "test bextract -d failed"
  CHECK_RESULT $? 0 0 "test bextract -dt failed"
  CHECK_RESULT $? 0 0 "test bextract -T failed"
  CHECK_RESULT $? 0 0 "test bextract -e failed"
```

- 涉及命令：bextract×7, sed×2, tar×1

#### oe_test_bacula_bextract_02

- 描述：Test bextract
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test bextract -V -t  failed"
  CHECK_RESULT $? 0 0 "test bextract -p failed"
  CHECK_RESULT $? 0 0 "test bextract -i failed"
```

- 涉及命令：bextract×3, sed×2, tar×1

#### oe_test_bacula_bwild_01

- 描述：Test bwild
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "test bwild -? failed"
  CHECK_RESULT $? 0 0 "test bwild -f failed"
  CHECK_RESULT $? 0 0 "test bwild -l failed"
  CHECK_RESULT $? 0 0 "test bwild -n failed"
  CHECK_RESULT $? 0 0 "test bwild -i failed"
```

- 涉及命令：tar×1, grep×1

#### oe_test_bacula_dbcheck_01

- 描述：Test dbcheck
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "test dbcheck -v -B -C -d failed"
  CHECK_RESULT $? 0 0 "test dbcheck -dt failed"
  CHECK_RESULT $? 0 0 "test dbcheck -f failed"
  CHECK_RESULT $? 0 0 "test dbcheck -b failed"
  CHECK_RESULT $? 0 0 "test dbcheck -c failed"
```

- 涉及命令：sed×2, tar×1, dbcheck×1

#### oe_test_bacula_bls_01

- 描述：Test bls
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "test bls -V -j failed"
  CHECK_RESULT $? 0 0 "test bls -d failed"
  CHECK_RESULT $? 0 0 "test bls -dt failed"
  CHECK_RESULT $? 0 0 "test bls -i failed"
  CHECK_RESULT $? 0 0 "test bls -e failed"
  CHECK_RESULT $? 0 0 "test bls -k failed"
  CHECK_RESULT $? 0 0 "test bls -L failed"
  CHECK_RESULT $? 0 0 "test bls -p failed"
```

- 涉及命令：bls×8, sed×2, tar×1

#### oe_test_bacula_bls_02

- 描述：Test bls
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "test bls -b failed"
  CHECK_RESULT $? 0 0 "test bls -v failed"
  CHECK_RESULT $? 0 0 "test bls -? failed"
  CHECK_RESULT $? 0 0 "test bls -c failed"
```

- 涉及命令：bls×3, sed×2, tar×1

#### oe_test_bacula_btape_01

- 描述：Test btape
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test btape -c failed"
  CHECK_RESULT $? 0 0 "test btape -b failed"
  CHECK_RESULT $? 0 0 "test btape -d failed"
  CHECK_RESULT $? 0 0 "test btape -dt failed"
  CHECK_RESULT $? 0 0 "test btape -p failed"
  CHECK_RESULT $? 0 0 "test btape -s failed"
  CHECK_RESULT $? 0 0 "test btape -v failed"
  CHECK_RESULT $? 0 0 "test btape -? failed"
  CHECK_RESULT $? 0 0 "test btape weof failed"
  CHECK_RESULT $? 0 0 "test btape -w failed"
```

- 涉及命令：sed×2, tar×1

#### oe_test_bacula_btape_02

- 描述：Test btape
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test btape qfill failed"
  CHECK_RESULT $? 0 0 "test btape bsf failed"
  CHECK_RESULT $? 0 0 "test btape bsr failed"
  CHECK_RESULT $? 0 0 "test btape cap failed"
  CHECK_RESULT $? 0 0 "test btape rr failed"
  CHECK_RESULT $? 0 0 "test btape wr failed"
  CHECK_RESULT $? 0 0 "test btape rb failed"
  CHECK_RESULT $? 0 0 "test btape fsf failed"
  CHECK_RESULT $? 0 0 "test btape fsr failed"
  CHECK_RESULT $? 0 0 "test btape eod failed"
```

- 涉及命令：sed×2, tar×1

#### oe_test_bacula_btape_03

- 描述：Test btape
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test btape eom failed"
  CHECK_RESULT $? 0 0 "test btape fill failed"
  CHECK_RESULT $? 0 0 "test btape unfill failed"
  CHECK_RESULT $? 0 0 "test btape help failed"
  CHECK_RESULT $? 0 0 "test btape clear failed"
  CHECK_RESULT $? 0 0 "test btape label failed"
  CHECK_RESULT $? 0 0 "test btape quit failed"
  CHECK_RESULT $? 0 0 "test btape load failed"
  CHECK_RESULT $? 0 0 "test btape rawfill failed"
  CHECK_RESULT $? 0 0 "test btape readlabel failed"
```

- 涉及命令：sed×2, tar×1

#### oe_test_bacula_btape_04

- 描述：Test btape
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "test btape rectest failed"
  CHECK_RESULT $? 0 0 "test btape rewind failed"
  CHECK_RESULT $? 0 0 "test btape scan failed"
  CHECK_RESULT $? 0 0 "test btape scanblocks failed"
  CHECK_RESULT $? 0 0 "test btape speed failed"
  CHECK_RESULT $? 0 0 "test btape status failed"
  CHECK_RESULT $? 0 0 "test btape test failed"
  CHECK_RESULT $? 0 0 "test btape autochanger failed"
```

- 涉及命令：sed×2, tar×1

#### oe_test_bacula_bacula_fd_01

- 描述：Test bacula-fd
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test bacula-fd -c -d -v failed"
  CHECK_RESULT $? 0 0 "test bacula-fd -dt failed"
  CHECK_RESULT $? 0 0 "test bacula-fd -f -s failed"
  CHECK_RESULT $? 0 0 "test bacula-fd -g failed"
  CHECK_RESULT $? 0 0 "test bacula-fd -k -u failed"
  CHECK_RESULT $? 0 0 "test bacula-fd -m failed"
  CHECK_RESULT $? 0 0 "test bacula-fd -P failed"
  CHECK_RESULT $? 0 0 "test bacula-fd -t failed"
  CHECK_RESULT $? 0 0 "test bacula-fd -T failed"
  CHECK_RESULT $? 0 0 "test bacula-fd -? failed"
```

- 涉及命令：pkill×9, bacula-fd×7, sed×2

#### oe_test_bacula_bacula_sd_01

- 描述：Test bacula-sd
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "test bacula-sd -c -v -d -dt failed"
  CHECK_RESULT $? 0 0 "test bacula-sd -f -s failed"
  CHECK_RESULT $? 0 0 "test bacula-sd -g failed"
  CHECK_RESULT $? 0 0 "test bacula-sd -P failed"
  CHECK_RESULT $? 0 0 "test bacula-sd -u failed"
  CHECK_RESULT $? 0 0 "test bacula-sd -m failed"
  CHECK_RESULT $? 0 0 "test bacula-sd -T failed"
```

- 涉及命令：pkill×7, bacula-sd×5, sed×2

#### oe_test_bacula_bacula_sd_02

- 描述：Test bacula-sd
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "test bacula-sd -t failed"
  CHECK_RESULT $? 0 0 "test bacula-sd -p failed"
  CHECK_RESULT $? 0 0 "test bacula-sd -? failed"
```

- 涉及命令：sed×2, bacula-sd×2, pkill×2

#### oe_test_bacula_bacula_dir_01

- 描述：Test bacula-dir
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "test bacula-dir -c -d -v failed"
  CHECK_RESULT $? 0 0 "test bacula-dir -dt failed"
  CHECK_RESULT $? 0 0 "test bacula-dir -f -s failed"
  CHECK_RESULT $? 0 0 "test bacula-dir -g failed"
  CHECK_RESULT $? 0 0 "test bacula-dir -P failed"
  CHECK_RESULT $? 0 0 "test bacula-dir -u failed"
  CHECK_RESULT $? 0 0 "test bacula-dir -m failed"
```

- 涉及命令：pkill×7, bacula-dir×5, sed×2

#### oe_test_bacula_bacula_dir_02

- 描述：Test bacula-dir
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "test bacula-dir -T failed"
  CHECK_RESULT $? 0 0 "test bacula-dir -r failed"
  CHECK_RESULT $? 0 0 "test bacula-dir -t failed"
  CHECK_RESULT $? 0 0 "test bacula-dir -? failed"
```

- 涉及命令：bacula-dir×3, pkill×3, sed×2

#### oe_test_bacula_bbconsjson_01

- 描述：Test bconsjson
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test bbconsjson -? failed"
  CHECK_RESULT $? 0 0 "test bbconsjson -c failed"
  CHECK_RESULT $? 0 0 "test bbconsjson -d failed"
  CHECK_RESULT $? 0 0 "test bbconsjson -v failed"
  CHECK_RESULT $? 0 0 "test bbconsjson -r failed"
  CHECK_RESULT $? 0 0 "test bbconsjson -n failed"
  CHECK_RESULT $? 0 0 "test bbconsjson -l failed"
  CHECK_RESULT $? 0 0 "test bbconsjson -D failed"
  CHECK_RESULT $? 0 0 "test bbconsjson -dt failed"
  CHECK_RESULT $? 0 0 "test bbconsjson -t failed"
```

- 涉及命令：bbconsjson×9

#### oe_test_bacula_bsmtp_01

- 描述：Test bsmtp & btraceback
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "test bsmtp -f -c -h -s -4 failed"
  CHECK_RESULT $? 0 0 "test bsmtp -6 failed"
  CHECK_RESULT $? 0 0 "test bsmtp -a failed"
  CHECK_RESULT $? 0 0 "test bsmtp -d failed"
  CHECK_RESULT $? 0 0 "test bsmtp -dt failed"
  CHECK_RESULT $? 0 0 "test bsmtp -r failed"
  CHECK_RESULT $? 0 0 "test bsmtp -l failed"
  CHECK_RESULT $? 0 0 "test bsmtp -? failed"
  CHECK_RESULT $? 0 0 "test btraceback failed"
  CHECK_RESULT $? 0 0 "test bsmtp -6 failed"
```

- 涉及命令：sed×2

#### oe_test_bacula_client

- 描述：test bacula-client
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Executed successfully"
  CHECK_RESULT $? 0 0 "process exit"
  CHECK_RESULT $? 0 0 "pid not exist"
```

- 涉及命令：bacula-fd×1, lsof×1, test×1
