# libnetfilter_queue

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libnetfilter_queue` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libnetfilter_queue_install | libnetfilter_queue install verification and package check | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libnetfilter_queue_devel | libnetfilter_queue-devel header files and pkg-config verification | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libnetfilter_queue_api | libnetfilter_queue API functionality test - compile and run test program | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libnetfilter_queue_install

- 描述：libnetfilter_queue install verification and package check
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "libnetfilter_queue package not installed"
  CHECK_RESULT $? 0 0 "Failed to get libnetfilter_queue package info"
  CHECK_RESULT $? 0 0 "libnetfilter_queue shared library not found"
  CHECK_RESULT $? 0 0 "libnetfilter_queue not found in ldconfig cache"
  CHECK_RESULT $? 0 0 "libnetfilter_queue package has no files"
  CHECK_RESULT $? 0 0 "libnetfilter_queue does not provide shared library"
  CHECK_RESULT $? 0 0 "Failed to check libnetfilter_queue dependencies"
  CHECK_RESULT $? 0 0 "libnetfilter_queue SONAME library not found"
  CHECK_RESULT $? 0 0 "libnetfilter_queue package summary is empty"
  CHECK_RESULT $? 0 0 "libnetfilter_queue package license is empty"
```

- 涉及命令：rpm×7, test×1, ldconfig×1

#### oe_test_libnetfilter_queue_devel

- 描述：libnetfilter_queue-devel header files and pkg-config verification
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "libnetfilter_queue-devel package not installed"
  CHECK_RESULT $? 0 0 "libnetfilter_queue.h header not found"
  CHECK_RESULT $? 0 0 "linux_nfnetlink_queue.h header not found"
  CHECK_RESULT $? 0 0 "pktbuff.h header not found"
  CHECK_RESULT $? 0 0 "libnetfilter_queue_ipv4.h header not found"
  CHECK_RESULT $? 0 0 "libnetfilter_queue_tcp.h header not found"
  CHECK_RESULT $? 0 0 "libnetfilter_queue.pc pkg-config file not found"
  CHECK_RESULT $? 0 0 "pkg-config --modversion libnetfilter_queue failed"
  CHECK_RESULT $? 0 0 "pkg-config --cflags libnetfilter_queue failed"
  CHECK_RESULT $? 0 0 "pkg-config --libs libnetfilter_queue failed"
```

- 涉及命令：test×6, rpm×1

#### oe_test_libnetfilter_queue_api

- 描述：libnetfilter_queue API functionality test - compile and run test program
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile nfq_test.c"
  CHECK_RESULT $? 0 0 "nfq_test binary not found"
  CHECK_RESULT $ret_code 0 0 "nfq_test program failed"
  CHECK_RESULT $? 0 0 "nfq_open() API test failed"
  CHECK_RESULT $? 0 0 "nfq_unbind_pf() API test failed"
  CHECK_RESULT $? 0 0 "nfq_bind_pf() API test failed"
  CHECK_RESULT $? 0 0 "nfq_create_queue() API test failed"
  CHECK_RESULT $? 0 0 "nfq_set_mode() API test failed"
  CHECK_RESULT $? 0 0 "nfq_fd() API test failed"
  CHECK_RESULT $? 0 0 "nfq_destroy_queue() API test failed"
  CHECK_RESULT $? 0 0 "nfq_close() or overall test failed"
```

- 涉及命令：gcc×1, test×1
