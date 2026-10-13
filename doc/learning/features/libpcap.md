# libpcap

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libpcap` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libpcap_install | libpcap install verification and package check | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libpcap_cli | libpcap CLI tools (pcap-config) option validation | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_libpcap_api | libpcap API functionality test - compile and run test program | pre_test/run_test/post_test | 16 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libpcap_install

- 描述：libpcap install verification and package check
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "libpcap package not installed"
  CHECK_RESULT $? 0 0 "Failed to get libpcap package info"
  CHECK_RESULT $? 0 0 "libpcap shared library not found"
  CHECK_RESULT $? 0 0 "libpcap not found in ldconfig cache"
  CHECK_RESULT $? 0 0 "libpcap package has no files"
  CHECK_RESULT $? 0 0 "libpcap does not provide shared library"
  CHECK_RESULT $? 0 0 "Failed to check libpcap dependencies"
  CHECK_RESULT $? 0 0 "libpcap SONAME library not found"
  CHECK_RESULT $? 0 0 "libpcap package summary is empty"
  CHECK_RESULT $? 0 0 "libpcap package license is empty"
```

- 涉及命令：rpm×7, test×1, ldconfig×1

#### oe_test_libpcap_cli

- 描述：libpcap CLI tools (pcap-config) option validation
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "pcap-config binary not found"
  CHECK_RESULT $? 0 0 "pcap-config --help failed"
  CHECK_RESULT $? 0 0 "pcap-config --version did not output version"
  CHECK_RESULT $? 0 0 "pcap-config --libs did not output -lpcap"
  CHECK_RESULT $? 0 0 "pcap-config --additional-libs failed"
  CHECK_RESULT $? 0 0 "pcap-config --static --libs did not output -lpcap"
  CHECK_RESULT $? 0 0 "pcap-config --static-pcap-only --libs did not output -lpcap"
  CHECK_RESULT $? 0 0 "pcap-config without args failed"
  CHECK_RESULT $? 0 0 "pcap-config --static --additional-libs failed"
```

- 涉及命令：command×1

#### oe_test_libpcap_api

- 描述：libpcap API functionality test - compile and run test program
- 函数：`pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile pcap_test.c"
  CHECK_RESULT $? 0 0 "pcap_test binary not found"
  CHECK_RESULT $? 0 0 "pkg-config for libpcap failed"
  CHECK_RESULT 0 0 0 "libpcap header file found via pkg-config"
  CHECK_RESULT 0 0 0 "libpcap header file found at /usr/include/pcap/pcap.h"
  CHECK_RESULT 0 0 0 "libpcap header file found at /usr/include/pcap.h"
  CHECK_RESULT 1 0 0 "libpcap header file not found"
  CHECK_RESULT $ret_code 0 0 "pcap_test program failed"
  CHECK_RESULT $? 0 0 "pcap_lib_version() API test failed"
  CHECK_RESULT $? 0 0 "pcap_findalldevs() API test failed"
  CHECK_RESULT $? 0 0 "Interface discovery test failed"
  CHECK_RESULT $? 0 0 "pcap_open_live() API test failed"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：gcc×1, test×1
