# curl

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/curl` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_curl_curl-config_001 | Test curl command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_curl_curl-config_002 | Test curl command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_curl_curl_001 | Test curl command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_curl_curl_002 | Test curl command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_curl_curl_003 | Test curl command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_curl_curl_004 | Test curl command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_curl_curl_005 | Test curl command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_curl_curl_006 | Test curl command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_curl_curl_007 | Test curl command | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_curl_curl-config_001

- 描述：Test curl command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "check bnd curl-config --built-shared failed"
  CHECK_RESULT $? 0 0 "check curl-config --ca failed"
  CHECK_RESULT $? 0 0 "check curl-config --cc failed"
  CHECK_RESULT $? 0 0 "check curl-config --cflags failed"
  CHECK_RESULT $? 0 0 "check curl-config --checkfor failed"
  CHECK_RESULT $? 0 0 "check curl-config --configure failed"
  CHECK_RESULT $? 0 0 "check curl-config --features failed"
  CHECK_RESULT $? 0 0 "check curl-config -h failed"
  CHECK_RESULT $? 0 0 "check curl-config --libs failed"
  CHECK_RESULT $? 0 0 "check curl-config --prefix failed"
```

- 涉及命令：curl-config×1

#### oe_test_curl_curl-config_002

- 描述：Test curl command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check bcurl-config --protocols failed"
  CHECK_RESULT $? 0 0 "check curl-config --ssl-backends failed"
  CHECK_RESULT $? 0 0 "check curl-config --version failed"
  CHECK_RESULT $? 0 0 "check curl-config --vernum failed"
```

#### oe_test_curl_curl_001

- 描述：Test curl command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "check curl --anyauth  failed"
  CHECK_RESULT $? 0 0 "check curl -a failed"
  CHECK_RESULT $? 0 0 "check curl --basic failed"
  CHECK_RESULT $? 0 0 "check curl --cacert failed"
  CHECK_RESULT $? 0 0 "check curl --capath failed"
  CHECK_RESULT $? 0 0 "check curl --connect-timeoutfailed"
  CHECK_RESULT $? 0 0 "check curl -C failed"
  CHECK_RESULT $? 0 0 "check curl https://www.baidu.com failed"
  CHECK_RESULT $? 0 0 "check curl -c failed"
  CHECK_RESULT $? 0 0 "check curl --create-dirs failed"
```

- 涉及命令：curl×2

#### oe_test_curl_curl_002

- 描述：Test curl command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check curl -X failed"
  CHECK_RESULT $? 0 0 "check curl --dump-header failed"
  CHECK_RESULT $? 0 0 "check curl -f  failed"
  CHECK_RESULT $? 0 0 "check curl -F  failed"
  CHECK_RESULT $? 0 0 "check curl --form-string failed"
  CHECK_RESULT $? 0 0 "check curl --ftp-account failed"
  CHECK_RESULT $? 0 0 "check curl --ftp-alternative-to-user failed"
  CHECK_RESULT $? 0 0 "check curl --get failed"
  CHECK_RESULT $? 0 0 "check curl -g  failed"
```

- 涉及命令：curl×4

#### oe_test_curl_curl_003

- 描述：Test curl command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check curl --happy-eyeballs-timeout-ms failed"
  CHECK_RESULT $? 0 0 "check curl -I failed"
  CHECK_RESULT $? 0 0 "check curl -H failed"
  CHECK_RESULT $? 0 0 "check curl -h failed"
  CHECK_RESULT $? 0 0 "check curl --hostpubmd5 failed"
  CHECK_RESULT $? 0 0 "check curl --http0.9 failed"
  CHECK_RESULT $? 0 0 "check curl -0failed"
  CHECK_RESULT $? 0 0 "check curl --http1.1 failed"
  CHECK_RESULT $? 0 0 "check curl --http2 failed"
```

- 涉及命令：curl×4

#### oe_test_curl_curl_004

- 描述：Test curl command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check curl --http2-prior-knowledge failed"
  CHECK_RESULT $? 0 0 "check curl --ignore-content-length failed"
  CHECK_RESULT $? 0 0 "check curl -i failed"
  CHECK_RESULT $? 0 0 "check curl -k failed"
  CHECK_RESULT $? 0 0 "check curl --interfacefailed"
  CHECK_RESULT $? 0 0 "check curl -4 failed"
  CHECK_RESULT $? 0 0 "check curl --key failed"
  CHECK_RESULT $? 0 0 "check curl --key-type failed"
  CHECK_RESULT $? 0 0 "check curl --libcurl failed"
```

- 涉及命令：curl×3

#### oe_test_curl_curl_005

- 描述：Test curl command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "check curl --limit-rate failed"
  CHECK_RESULT $? 0 0 "check curl --list-only failed"
  CHECK_RESULT $? 0 0 "check curl --local-port failed"
  CHECK_RESULT $? 0 0 "check curl -L failed"
  CHECK_RESULT $? 0 0 "check curl --location-trusted failed"
  CHECK_RESULT $? 0 0 "check curl -j -b failed"
  CHECK_RESULT $? 0 0 "check curl --login-options failed"
  CHECK_RESULT $? 0 0 "check curl -M failed"
  CHECK_RESULT $? 0 0 "check curl --max-filesize failed"
  CHECK_RESULT $? 0 0 "check curl --max-redirs failed"
```

- 涉及命令：curl×3

#### oe_test_curl_curl_006

- 描述：Test curl command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check curl --metalink failed"
  CHECK_RESULT $? 0 0 "check curl --negotiate failed"
  CHECK_RESULT $? 0 0 "check curl -o failed"
  CHECK_RESULT $? 0 0 "check curl -# failed"
  CHECK_RESULT $? 0 0 "check curl --referer failed"
  CHECK_RESULT $? 0 0 "check curl --silent -O failed"
  CHECK_RESULT $? 0 0 "check curl -X failed"
  CHECK_RESULT $? 0 0 "check curl -1 failed"
  CHECK_RESULT $? 0 0 "check curl --tlsv1.0 failed"
```

- 涉及命令：curl×2

#### oe_test_curl_curl_007

- 描述：Test curl command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "check curl --tlsv1.1 failed"
  CHECK_RESULT $? 0 0 "check curl --tlsv1.2 failed"
  CHECK_RESULT $? 0 0 "check curl --tlsv1.3 failed"
  CHECK_RESULT $? 0 0 "check curl -A failed"
  CHECK_RESULT $? 0 0 "check curl -v failed"
  CHECK_RESULT $? 0 0 "check curl -V failed"
  CHECK_RESULT $? 0 0 "check curl -w failed"
  CHECK_RESULT $? 0 0 "check curl --trace failed"
  CHECK_RESULT $? 0 0 "check curl --trace-ascii failed"
  CHECK_RESULT $? 0 0 "check curl --trace-time --trace failed"
```

- 涉及命令：curl×3
