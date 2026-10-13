# perl-libwww-perl

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/perl-libwww-perl` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_perl-libwww-perl_GET_01 | verify the uasge of perl-libwww-perl command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_perl-libwww-perl_GET_02 | verify the uasge of perl-libwww-perl command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_perl-libwww-perl_HEAD_01 | verify the uasge of perl-libwww-perl command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_perl-libwww-perl_HEAD_02 | verify the uasge of perl-libwww-perl command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_perl-libwww-perl_lwp-dump | verify the uasge of perl-libwww-perl command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_perl-libwww-perl_lwp_request_01 | verify the uasge of perl-libwww-perl command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_perl-libwww-perl_lwp_request_02 | verify the uasge of perl-libwww-perl command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_perl-libwww-perl_POST_01 | verify the uasge of perl-libwww-perl command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_perl-libwww-perl_POST_02 | verify the uasge of perl-libwww-perl command | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_perl-libwww-perl_GET_01

- 描述：verify the uasge of perl-libwww-perl command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check GET -m  failed"
  CHECK_RESULT $? 0 0 "Check GET -f  failed"
  CHECK_RESULT $? 0 0 "Check GET -b  failed"
  CHECK_RESULT $? 0 0 "Check GET  -t failed"
  CHECK_RESULT $? 0 0 "Check GET -i failed"
  CHECK_RESULT $? 0 0 "Check GET  -a failed"
  CHECK_RESULT $? 0 0 "Check GET -p  failed"
  CHECK_RESULT $? 0 0 "Check GET -P  failed"
  CHECK_RESULT $? 0 0 "Check GET -H  failed"
  CHECK_RESULT $? 0 0 "Check GET -C failed"
  CHECK_RESULT $? 0 0 "Check GET -o failed"
```

- 涉及命令：GET×11, tar×1

#### oe_test_perl-libwww-perl_GET_02

- 描述：verify the uasge of perl-libwww-perl command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check GET -u failed"
  CHECK_RESULT $? 0 0 "Check GET -U failed"
  CHECK_RESULT $? 0 0 "Check GET -s failed"
  CHECK_RESULT $? 0 0 "Check GET -S failed"
  CHECK_RESULT $? 0 0 "Check GET -e failed"
  CHECK_RESULT $? 0 0 "Check GET -E failed"
  CHECK_RESULT $? 0 0 "Check GET -d failed"
  CHECK_RESULT $? 0 0 "Check GET -v failed"
  CHECK_RESULT $? 0 0 "Check GET -h failed"
```

- 涉及命令：GET×9

#### oe_test_perl-libwww-perl_HEAD_01

- 描述：verify the uasge of perl-libwww-perl command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check HEAD -m failed"
  CHECK_RESULT $? 0 0 "Check HEAD -f failed"
  CHECK_RESULT $? 0 0 "Check HEAD -b failed"
  CHECK_RESULT $? 0 0 "Check HEAD -t failed"
  CHECK_RESULT $? 0 0 "Check HEAD -i failed"
  CHECK_RESULT $? 0 0 "Check HEAD -a failed"
  CHECK_RESULT $? 0 0 "Check HEAD -p  failed"
  CHECK_RESULT $? 0 0 "Check HEAD -P failed"
  CHECK_RESULT $? 0 0 "Check HEAD -C failed"
```

- 涉及命令：HEAD×9

#### oe_test_perl-libwww-perl_HEAD_02

- 描述：verify the uasge of perl-libwww-perl command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check HEAD -u  failed"
  CHECK_RESULT $? 0 0 "Check HEAD -U  failed"
  CHECK_RESULT $? 0 0 "Check HEAD -s  failed"
  CHECK_RESULT $? 0 0 "Check HEAD -S  failed"
  CHECK_RESULT $? 0 0 "Check HEAD -e  failed"
  CHECK_RESULT $? 0 0 "Check HEAD -E  failed"
  CHECK_RESULT $? 0 0 "Check HEAD -d  failed"
  CHECK_RESULT $? 0 0 "Check HEAD -o  failed"
  CHECK_RESULT $? 0 0 "Check HEAD -v failed"
  CHECK_RESULT $? 0 0 "Check HEAD  -h failed"
```

- 涉及命令：HEAD×10

#### oe_test_perl-libwww-perl_lwp-dump

- 描述：verify the uasge of perl-libwww-perl command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check lwp-dump --agent failed"
  CHECK_RESULT $? 0 0 "Check lwp-dump --keep-client-headers failed"
  CHECK_RESULT $? 0 0 "Check lwp-dump --max-length failed"
  CHECK_RESULT $? 0 0 "Check lwp-dump --method failed"
  CHECK_RESULT $? 0 0 "Check lwp-dump --parse-head  failed"
  CHECK_RESULT $? 0 0 "Check lwp-dump --request failed"
  CHECK_RESULT $? 0 0 "Check lwp-download -a  failed"
  CHECK_RESULT $? 0 0 "Check lwp-download -s failed"
  CHECK_RESULT $? 0 0 "Check lwp-mirror -v failed"
  CHECK_RESULT $? 0 0 "Check lwp-mirror -t failed"
```

- 涉及命令：lwp-download×2, lwp-mirror×2, test×1

#### oe_test_perl-libwww-perl_lwp_request_01

- 描述：verify the uasge of perl-libwww-perl command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check lwp-request -m failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -f failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -b failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -t failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -i failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -a failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -p failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -P failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -C   failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -u failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -u failed"
```

- 涉及命令：lwp-request×11

#### oe_test_perl-libwww-perl_lwp_request_02

- 描述：verify the uasge of perl-libwww-perl command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check lwp-request -s failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -S failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -e failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -E failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -d failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -v failed"
  CHECK_RESULT $? 0 0 "Check lwp-request -h failed"
```

- 涉及命令：lwp-request×7

#### oe_test_perl-libwww-perl_POST_01

- 描述：verify the uasge of perl-libwww-perl command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check POST -m failed"
  CHECK_RESULT $? 0 0 "Check POST -f failed"
  CHECK_RESULT $? 0 0 "Check POST -b failed"
  CHECK_RESULT $? 0 0 "Check POST -a -t failed"
  CHECK_RESULT $? 0 0 "Check POST -p failed"
  CHECK_RESULT $? 0 0 "Check POST -P failed"
  CHECK_RESULT $? 0 0 "Check POST -H failed"
  CHECK_RESULT $? 0 0 "Check POST -C failed"
  CHECK_RESULT $? 0 0 "Check POST -i failed"
  CHECK_RESULT $? 0 0 "Check POST -i failed"
  CHECK_RESULT $? 0 0 "Check POST -o failed"
```

- 涉及命令：POST×10, tar×1

#### oe_test_perl-libwww-perl_POST_02

- 描述：verify the uasge of perl-libwww-perl command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check POST -u failed"
  CHECK_RESULT $? 0 0 "Check POST -U failed"
  CHECK_RESULT $? 0 0 "Check POST -s failed"
  CHECK_RESULT $? 0 0 "Check POST -S failed"
  CHECK_RESULT $? 0 0 "Check POST -e failed"
  CHECK_RESULT $? 0 0 "Check POST -d failed"
  CHECK_RESULT $? 0 0 "Check POST -v failed"
  CHECK_RESULT $? 0 0 "Check POST -h failed"
```

- 涉及命令：POST×8
