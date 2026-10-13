# c-ares

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/c-ares` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_c-ares_01 | Test c-ares all subpackages installation integrity and version | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_c-ares_02 | Test c-ares async DNS query API via compiled C program | config_params/pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_c-ares_adig | Test adig command - c-ares asynchronous DNS query tool | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_c-ares_ahost | Test ahost command - c-ares asynchronous host resolution tool | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_c-ares_01

- 描述：Test c-ares all subpackages installation integrity and version
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "c-ares runtime library package is not installed"
  CHECK_RESULT $? 0 0 "c-ares-devel package is not installed"
  CHECK_RESULT $? 0 0 "failed to get c-ares rpm version"
  CHECK_RESULT $? 0 0 "pkg-config version does not match rpm version"
```

- 涉及命令：rpm×2

#### oe_test_c-ares_02

- 描述：Test c-ares async DNS query API via compiled C program
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "failed to compile c-ares test program"
  CHECK_RESULT $? 0 0 "c-ares async query for localhost failed"
  CHECK_RESULT $? 0 0 "async query did not return 127.0.0.1 for localhost"
  CHECK_RESULT $? 0 0 "c-ares async query for 127.0.0.1 failed"
  CHECK_RESULT $? 0 0 "async query did not return 127.0.0.1"
```

- 涉及命令：grep×2, mkdir×1, gcc×1

#### oe_test_c-ares_adig

- 描述：Test adig command - c-ares asynchronous DNS query tool
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "adig -h does not show usage"
  CHECK_RESULT $? 0 0 "adig failed to query openeuler.org"
  CHECK_RESULT $? 0 0 "adig basic query did not produce DNS response header"
  CHECK_RESULT $? 0 0 "adig -t A failed"
  CHECK_RESULT $? 0 0 "adig -t A did not return A record"
  CHECK_RESULT $? 0 0 "adig -t AAAA failed"
  CHECK_RESULT $? 0 0 "adig +tcp (TCP transport) failed"
  CHECK_RESULT $? 0 0 "adig +tcp did not produce DNS response header"
  CHECK_RESULT $? 0 0 "adig -s (specify DNS server) failed"
```

- 涉及命令：adig×4, grep×3, mkdir×1

#### oe_test_c-ares_ahost

- 描述：Test ahost command - c-ares asynchronous host resolution tool
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "ahost -h does not show usage"
  CHECK_RESULT $? 0 0 "ahost failed to resolve openeuler.org"
  CHECK_RESULT $? 0 0 "ahost basic resolution did not return an IP address"
  CHECK_RESULT $? 0 0 "ahost -t a failed"
  CHECK_RESULT $? 0 0 "ahost -t a did not return IPv4 address"
  CHECK_RESULT $? 0 0 "ahost -t aaaa failed"
```

- 涉及命令：ahost×3, grep×2, mkdir×1
