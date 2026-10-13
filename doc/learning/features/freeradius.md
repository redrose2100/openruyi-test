# freeradius

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/freeradius` |
| 注册用例数 | 18 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_freeradius_freeradius_raddebugAndCheckrad | freeradius command parameter automation use case | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_freeradius_freeradius_radiusd | freeradius command parameter automation use case | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_freeradius_freeradius_radiusdAndRadmin | freeradius command parameter automation use case | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radclient | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radclient2 | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_rad_counter | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radcryptAndRadeapclient | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radeapclient | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radlast | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radlastAndRadsniff | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radsniff | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radsniff2 | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radsqlrelay | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radtestAndRadwho | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radwho | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_radzap | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_freeradius_freeradius-utils_rlm_ippool_toolAndSmbencrypt | freeradius-utils command parameter automation use case | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_service_radiusd | Test radiusd.service restart | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_freeradius_freeradius_raddebugAndCheckrad

- 描述：freeradius command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "raddebug -c execution failed."
  CHECK_RESULT $? 0 0 "raddebug -d execution failed."
  CHECK_RESULT $? 0 0 "raddebug -n execution failed."
  CHECK_RESULT $? 0 0 "raddebug -D execution failed."
  CHECK_RESULT $? 0 0 "raddebug -i execution failed."
  CHECK_RESULT $? 0 0 "raddebug -I execution failed."
  CHECK_RESULT $? 0 0 "raddebug -f execution failed."
  CHECK_RESULT $? 0 0 "raddebug -t execution failed."
  CHECK_RESULT $? 0 0 "raddebug -u execution failed."
  CHECK_RESULT $? 0 0 "checkrad execution failed."
```

- 涉及命令：raddebug×9, sed×2

#### oe_test_freeradius_freeradius_radiusd

- 描述：freeradius command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "radiusd -d execution failed."
  CHECK_RESULT $? 0 0 "radiusd -D execution failed."
  CHECK_RESULT $? 0 0 "radiusd -f execution failed."
  CHECK_RESULT $? 0 0 "radiusd -h execution failed."
  CHECK_RESULT $? 0 0 "radiusd -i -p execution failed."
  CHECK_RESULT $? 0 0 "radiusd -l execution failed."
  CHECK_RESULT $? 0 0 "radiusd -n execution failed."
  CHECK_RESULT $? 0 0 "radiusd -P execution failed."
  CHECK_RESULT $? 0 0 "radiusd -s execution failed."
```

- 涉及命令：radiusd×9, kill×8, pgrep×6

#### oe_test_freeradius_freeradius_radiusdAndRadmin

- 描述：freeradius command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "radiusd -v execution failed."
  CHECK_RESULT $? 0 0 "radiusd -X execution failed."
  CHECK_RESULT $? 0 0 "radmin -d execution failed."
  CHECK_RESULT $? 0 0 "radmin -D execution failed."
  CHECK_RESULT $? 0 0 "radmin -e execution failed."
  CHECK_RESULT $? 0 0 "radmin -E execution failed."
  CHECK_RESULT $? 0 0 "radmin -f execution failed."
  CHECK_RESULT $? 0 0 "radmin -h execution failed."
  CHECK_RESULT $? 0 0 "radmin -i execution failed."
  CHECK_RESULT $? 0 0 "radmin -n execution failed."
  CHECK_RESULT $? 0 0 "radmin -q execution failed."
```

- 涉及命令：radmin×8, radiusd×2, kill×2

#### oe_test_freeradius_freeradius-utils_radclient

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "radclient -4 execution failed."
  CHECK_RESULT $? 0 0 "radclient -6 execution failed."
  CHECK_RESULT $? 0 0 "radclient -c execution failed."
  CHECK_RESULT $? 0 0 "radclient -d execution failed."
  CHECK_RESULT $? 0 0 "radclient -D execution failed."
  CHECK_RESULT $? 0 0 "radclient -f execution failed."
  CHECK_RESULT $? 0 0 "radclient -F execution failed."
  CHECK_RESULT $? 0 0 "radclient -h execution failed."
  CHECK_RESULT $? 0 0 "radclient -n execution failed."
```

- 涉及命令：radclient×2

#### oe_test_freeradius_freeradius-utils_radclient2

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "radclient -p execution failed."
  CHECK_RESULT $? 0 0 "radclient -q execution failed."
  CHECK_RESULT $? 0 0 "radclient -t execution failed."
  CHECK_RESULT $? 0 0 "radclient -r execution failed."
  CHECK_RESULT $? 0 0 "radclient -s execution failed."
  CHECK_RESULT $? 0 0 "radclient -S execution failed."
  CHECK_RESULT $? 0 0 "radclient -v execution failed."
  CHECK_RESULT $? 0 0 "radclient -x execution failed."
  CHECK_RESULT $? 0 0 "radclient -P execution failed."
```

- 涉及命令：radclient×1

#### oe_test_freeradius_freeradius-utils_rad_counter

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "rad_counter --user execution failed."
  CHECK_RESULT $? 0 0 "rad_counter --match execution failed."
  CHECK_RESULT $? 0 0 "rad_counter --reset execution failed."
  CHECK_RESULT $? 0 0 "rad_counter --help execution failed."
  CHECK_RESULT $? 0 0 "rad_counter --hours execution failed."
  CHECK_RESULT $? 0 0 "rad_counter --minutes execution failed."
  CHECK_RESULT $? 0 0 "rad_counter --seconds execution failed."
```

#### oe_test_freeradius_freeradius-utils_radcryptAndRadeapclient

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "radcrypt --des execution failed."
  CHECK_RESULT $? 0 0 "radcrypt --md5 execution failed."
  CHECK_RESULT $? 0 0 "radcrypt --check execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -4 execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -6 execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -d execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -D execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -f execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -h execution failed."
```

- 涉及命令：radeapclient×2

#### oe_test_freeradius_freeradius-utils_radeapclient

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "radeapclient -p execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -q execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -t execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -r execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -s execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -S execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -v execution failed."
  CHECK_RESULT $? 0 0 "radeapclient -x execution failed."
```

- 涉及命令：radeapclient×1

#### oe_test_freeradius_freeradius-utils_radlast

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "radlast -num execution failed."
  CHECK_RESULT $? 0 0 "radlast -a execution failed."
  CHECK_RESULT $? 0 0 "radlast -d execution failed."
  CHECK_RESULT $? 0 0 "radlast --file execution failed."
  CHECK_RESULT $? 0 0 "radlast --fulltimes execution failed."
  CHECK_RESULT $? 0 0 "radlast -i execution failed."
  CHECK_RESULT $? 0 0 "radlast -n execution failed."
  CHECK_RESULT $? 0 0 "radlast -R execution failed."
  CHECK_RESULT $? 0 0 "radlast -s execution failed."
```

- 涉及命令：radlast×4, test×1

#### oe_test_freeradius_freeradius-utils_radlastAndRadsniff

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "radlast -t execution failed."
  CHECK_RESULT $? 0 0 "radlast -x execution failed."
  CHECK_RESULT $? 0 0 "radlast -h execution failed."
  CHECK_RESULT $? 0 0 "radlast -V execution failed."
  CHECK_RESULT $? 0 0 "radsniff -a execution failed."
  CHECK_RESULT $? 0 0 "radsniff -c execution failed."
  CHECK_RESULT $? 0 0 "radsniff -C execution failed."
  CHECK_RESULT $? 0 0 "radsniff -d execution failed."
  CHECK_RESULT $? 0 0 "radsniff -D execution failed."
```

- 涉及命令：radsniff×5, radlast×3, test×1

#### oe_test_freeradius_freeradius-utils_radsniff

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "radsniff -e execution failed."
  CHECK_RESULT $? 0 0 "radsniff -f execution failed."
  CHECK_RESULT $? 0 0 "radsniff -h execution failed."
  CHECK_RESULT $? 0 0 "radsniff -I execution failed."
  CHECK_RESULT $? 0 0 "radsniff -l execution failed."
  CHECK_RESULT $? 0 0 "radsniff -L execution failed."
  CHECK_RESULT $? 0 0 "radsniff -m execution failed."
  CHECK_RESULT $? 0 0 "radsniff -p execution failed."
  CHECK_RESULT $? 0 0 "radsniff -P execution failed."
```

- 涉及命令：radsniff×9, kill×1

#### oe_test_freeradius_freeradius-utils_radsniff2

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "radsniff -q execution failed."
  CHECK_RESULT $? 0 0 "radsniff -r execution failed."
  CHECK_RESULT $? 0 0 "radsniff -R execution failed."
  CHECK_RESULT $? 0 0 "radsniff -s execution failed."
  CHECK_RESULT $? 0 0 "radsniff -S execution failed."
  CHECK_RESULT $? 0 0 "radsniff -v execution failed."
  CHECK_RESULT $? 0 0 "radsniff -w execution failed."
  CHECK_RESULT $? 0 0 "radsniff -x execution failed."
  CHECK_RESULT $? 0 0 "radsniff -W execution failed."
  CHECK_RESULT $? 0 0 "radsniff -T execution failed."
```

- 涉及命令：radsniff×7, xxd×1

#### oe_test_freeradius_freeradius-utils_radsqlrelay

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "radsqlrelay -? execution failed."
  CHECK_RESULT $? 0 0 "radsqlrelay -1 -d -b -h -p -u execution failed."
  CHECK_RESULT $? 0 0 "radsqlrelay -f execution failed."
  CHECK_RESULT $? 0 0 "radsqlrelay -P execution failed."
  CHECK_RESULT $? 0 0 "radsqlrelay -x execution failed."
```

- 涉及命令：mysql×7, sed×6, radsqlrelay×4, mysqladmin×1

#### oe_test_freeradius_freeradius-utils_radtestAndRadwho

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "radtest -d execution failed."
  CHECK_RESULT $? 0 0 "radtest -t execution failed."
  CHECK_RESULT $? 0 0 "radtest -P execution failed."
  CHECK_RESULT $? 0 0 "radtest -x execution failed."
  CHECK_RESULT $? 0 0 "radtest -4 execution failed."
  CHECK_RESULT $? 0 0 "radtest -6 execution failed."
  CHECK_RESULT $? 0 0 "radwho -c execution failed."
  CHECK_RESULT $? 0 0 "radwho -d execution failed."
  CHECK_RESULT $? 0 0 "radwho -F execution failed."
```

- 涉及命令：radtest×6, radwho×3

#### oe_test_freeradius_freeradius-utils_radwho

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "radwho -i execution failed."
  CHECK_RESULT $? 0 0 "radwho -n execution failed."
  CHECK_RESULT $? 0 0 "radwho -N execution failed."
  CHECK_RESULT $? 0 0 "radwho -p execution failed."
  CHECK_RESULT $? 0 0 "radwho -P execution failed."
  CHECK_RESULT $? 0 0 "radwho -r execution failed."
  CHECK_RESULT $? 0 0 "radwho -RZ execution failed."
  CHECK_RESULT $? 0 0 "radwho -s execution failed."
  CHECK_RESULT $? 0 0 "radwho -S execution failed."
  CHECK_RESULT $? 0 0 "radwho -u execution failed."
  CHECK_RESULT $? 0 0 "radwho -U execution failed."
```

- 涉及命令：radwho×9, test×1

#### oe_test_freeradius_freeradius-utils_radzap

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "radzap -h execution failed."
  CHECK_RESULT $? 0 0 "radzap -d -N execution failed."
  CHECK_RESULT $? 0 0 "radzap -D -N execution failed."
  CHECK_RESULT $? 0 0 "touch radutmp failed."
  CHECK_RESULT $? 0 0 "radzap -P execution failed."
  CHECK_RESULT $? 0 0 "radzap -u execution failed."
  CHECK_RESULT $? 0 0 "radzap -U execution failed."
  CHECK_RESULT $? 0 0 "radzap -x -N execution failed."
```

- 涉及命令：radzap×7

#### oe_test_freeradius_freeradius-utils_rlm_ippool_toolAndSmbencrypt

- 描述：freeradius-utils command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "rlm_ippool_tool -n execution failed."
  CHECK_RESULT $? 0 0 "rlm_ippool_tool -a execution failed."
  CHECK_RESULT $? 0 0 "rlm_ippool_tool -c execution failed."
  CHECK_RESULT $? 0 0 "rlm_ippool_tool -r execution failed."
  CHECK_RESULT $? 0 0 "rlm_ippool_tool -v execution failed."
  CHECK_RESULT $? 0 0 "rlm_ippool_tool -o execution failed."
  CHECK_RESULT $? 0 0 "rlm_ippool_tool -u execution failed."
  CHECK_RESULT $? 0 0 "smbencrypt execution failed."
```

- 涉及命令：rlm_ippool_tool×6, sed×1

#### oe_test_service_radiusd

- 描述：Test radiusd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of radiusd.service"
  CHECK_RESULT $? 0 0 "radiusd.service reload failed"
  CHECK_RESULT $? 0 0 "radiusd.service reload causes the service status to change"
```

- 涉及命令：sed×2
