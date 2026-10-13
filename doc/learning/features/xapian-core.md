# xapian-core

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/xapian-core` |
| 注册用例数 | 17 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_xapian-core_copydatabase | Take the test copydatabase command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_xapian-core_quest_01 | Take the test quest command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_xapian-core_quest_02 | Take the test quest command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_xapian-core_quest_03 | Take the test xapian-quest command and xapian-compact command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_xapian-core_simpleindex | Take the test simpleindex/simplesearch/simpleexpand command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_xapian-core_xapian-check | Take the test xapian-check command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_xapian-core_xapian-compact | Take the test xapian-compact command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_xapian-core_xapian-config | Take the test xapian-config command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_xapian-core_xapian-delve_01 | Take the test xapian-delve command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_xapian-core_xapian-delve_02 | Take the test copydatabase command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_xapian-core_xapian-metadata | Take the test xapian-metadata command and xapian-replicate --help,xapian-replicate --version | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_xapian-core_xapian-pos | Take the test xapian-pos command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_xapian-core_xapian-progsrv | Take the test xapian-progsrv command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_xapian-core_xapian-replicate_01 | Take the test xapian-replicate command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_xapian-core_xapian-replicate_02 | Take the test xapian-replicate command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_xapian-core_xapian-replicate-server | Take the test xapian-replicate-server command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_xapian-core_xapian-tcpsrv | Take the test xapian-tcpsrv command | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_xapian-core_copydatabase

- 描述：Take the test copydatabase command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "option --no-renumber error"
  CHECK_RESULT $? 0 0 "Directory does not exist."
  CHECK_RESULT $? 0 0 "option --help error"
  CHECK_RESULT $? 0 0 "option --version error"
```

- 涉及命令：test×1

#### oe_test_xapian-core_quest_01

- 描述：Take the test quest command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option -d error"
  CHECK_RESULT $? 0 0 "option --db= error"
  CHECK_RESULT $? 0 0 "option -m error"
  CHECK_RESULT $? 0 0 "option --msize= error"
  CHECK_RESULT $? 0 0 "option -c error"
  CHECK_RESULT $? 0 0 "option --check-at-least= error"
  CHECK_RESULT $? 0 0 "option -s error"
  CHECK_RESULT $? 0 0 "option --stemmer= error"
  CHECK_RESULT $? 0 0 "option -p error"
  CHECK_RESULT $? 0 0 "option --prefix= error"
```

- 涉及命令：quest×9

#### oe_test_xapian-core_quest_02

- 描述：Take the test quest command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option -b error"
  CHECK_RESULT $? 0 0 "option --boolean-prefix= error"
  CHECK_RESULT $? 0 0 "option -f error"
  CHECK_RESULT $? 0 0 "option --flags= error"
  CHECK_RESULT $? 0 0 "option -o error"
  CHECK_RESULT $? 0 0 "option --default-op= error"
  CHECK_RESULT $? 0 0 "option -w error"
  CHECK_RESULT $? 0 0 "option --weight= error"
  CHECK_RESULT $? 0 0 "option --help error"
  CHECK_RESULT $? 0 0 "option -h error"
```

- 涉及命令：quest×9

#### oe_test_xapian-core_quest_03

- 描述：Take the test xapian-quest command and xapian-compact command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "option --version error"
  CHECK_RESULT $? 0 0 "option -v error"
  CHECK_RESULT $? 0 0 "option --single-flie is error"
  CHECK_RESULT $? 0 0 "option--help is error"
  CHECK_RESULT $? 0 0 "option--version is error"
```

- 涉及命令：quest×1

#### oe_test_xapian-core_simpleindex

- 描述：Take the test simpleindex/simplesearch/simpleexpand command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "option simpleindex error"
  CHECK_RESULT $? 0 0 "option simplesearch error"
  CHECK_RESULT $? 0 0 "option simpleexpand error"
```

#### oe_test_xapian-core_xapian-check

- 描述：Take the test xapian-check command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "option F error"
  CHECK_RESULT $? 0 0 "option t error"
  CHECK_RESULT $? 0 0 "option f error"
  CHECK_RESULT $? 0 0 "option b error"
  CHECK_RESULT $? 0 0 "option v error"
  CHECK_RESULT $? 0 0 "option + error"
```

#### oe_test_xapian-core_xapian-compact

- 描述：Take the test xapian-compact command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option-b is error"
  CHECK_RESULT $? 0 0 "option-blocksize is error"
  CHECK_RESULT $? 0 0 "option-F is error"
  CHECK_RESULT $? 0 0 "option--fuller is error"
  CHECK_RESULT $? 0 0 "option-n is error"
  CHECK_RESULT $? 0 0 "option--no-full is error"
  CHECK_RESULT $? 0 0 "option--m is error"
  CHECK_RESULT $? 0 0 "option--multipass is error"
  CHECK_RESULT $? 0 0 "option--no-renumber is error"
  CHECK_RESULT $? 0 0 "option-s is error"
```

- 涉及命令：xapian-compact×5

#### oe_test_xapian-core_xapian-config

- 描述：Take the test xapian-config command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "option --cxxflags error"
  CHECK_RESULT $? 0 0 "option --libs error"
  CHECK_RESULT $? 0 0 "option --ltlibs error"
  CHECK_RESULT $? 0 0 "option --static error"
  CHECK_RESULT $? 0 0 "option --swigflags error"
  CHECK_RESULT $? 0 0 "option --help error"
  CHECK_RESULT $? 0 0 "option --version error"
```

#### oe_test_xapian-core_xapian-delve_01

- 描述：Take the test xapian-delve command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "option-a is error"
  CHECK_RESULT $? 0 0 "option-A is error"
  CHECK_RESULT $? 0 0 "option-r is error"
  CHECK_RESULT $? 0 0 "option-t is error"
  CHECK_RESULT $? 0 0 "option-t-r is error"
  CHECK_RESULT $? 0 0 "option-s is error"
  CHECK_RESULT $? 0 0 "option-l is error"
  CHECK_RESULT $? 0 0 "option-V is error"
  CHECK_RESULT $? 0 0 "option-d is error"
```

- 涉及命令：xapian-delve×9

#### oe_test_xapian-core_xapian-delve_02

- 描述：Take the test copydatabase command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "option-z is error"
  CHECK_RESULT $? 0 0 "option-v is error"
  CHECK_RESULT $? 0 0 "option-vv is error"
  CHECK_RESULT $? 0 0 "option--help is error"
  CHECK_RESULT $? 0 0 "option--version is error"
```

- 涉及命令：xapian-delve×3

#### oe_test_xapian-core_xapian-metadata

- 描述：Take the test xapian-metadata command and xapian-replicate --help,xapian-replicate --version
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "option set error"
  CHECK_RESULT $? 0 0 "option list error"
  CHECK_RESULT $? 0 0 "option get error"
  CHECK_RESULT $? 0 0 "option --help error"
  CHECK_RESULT $? 0 0 "option --version error"
```

#### oe_test_xapian-core_xapian-pos

- 描述：Take the test xapian-pos command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "option --help is error"
  CHECK_RESULT $? 0 0 "option --vresion is error "
  CHECK_RESULT $? 0 0 "option --doc is error"
  CHECK_RESULT $? 0 0 "option -d is error"
  CHECK_RESULT $? 0 0 "option --start is error"
  CHECK_RESULT $? 0 0 "option -s is error"
  CHECK_RESULT $? 0 0 "option -e is error"
  CHECK_RESULT $? 0 0 "option --end is error"
```

- 涉及命令：xapian-pos×3

#### oe_test_xapian-core_xapian-progsrv

- 描述：Take the test xapian-progsrv command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "option --timeout error"
  CHECK_RESULT $? 0 0 "option --writable error"
  CHECK_RESULT $? 0 0 "option --help error"
  CHECK_RESULT $? 0 0 "option --version error"
```

#### oe_test_xapian-core_xapian-replicate_01

- 描述：Take the test xapian-replicate command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "option -h,-p,-m error"
  CHECK_RESULT $? 0 0 "option -i error"
  CHECK_RESULT $? 0 0 "option -r error"
  CHECK_RESULT $? 0 0 "option -t error"
  CHECK_RESULT $? 0 0 "option -f error"
  CHECK_RESULT $? 0 0 "option -o error"
  CHECK_RESULT $? 0 0 "option -q error"
  CHECK_RESULT $? 0 0 "option -v error"
```

- 涉及命令：xapian-replicate×8, xapian-replicate-server×1, kill×1

#### oe_test_xapian-core_xapian-replicate_02

- 描述：Take the test xapian-replicate command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "option --host, --port,--master error"
  CHECK_RESULT $? 0 0 "option --interval error"
  CHECK_RESULT $? 0 0 "option --reader-time error"
  CHECK_RESULT $? 0 0 "option --timeout error"
  CHECK_RESULT $? 0 0 "option --force-copy error"
  CHECK_RESULT $? 0 0 "option --one-shot error"
  CHECK_RESULT $? 0 0 "option --quiet error"
  CHECK_RESULT $? 0 0 "option --verbose error"
```

- 涉及命令：xapian-replicate-server×1, kill×1

#### oe_test_xapian-core_xapian-replicate-server

- 描述：Take the test xapian-replicate-server command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "opiton I,p error"
  CHECK_RESULT $? 0 0 "opiton --interface,--port error"
  CHECK_RESULT $? 0 0 "opiton o error"
  CHECK_RESULT $? 0 0 "opiton --one-shot error"
  CHECK_RESULT $? 0 0 "option --help error"
  CHECK_RESULT $? 0 0 "option --version error"
```

- 涉及命令：xapian-replicate-server×2, kill×1

#### oe_test_xapian-core_xapian-tcpsrv

- 描述：Take the test xapian-tcpsrv command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option --port error"
  CHECK_RESULT $? 0 0 "option --interface error"
  CHECK_RESULT $? 0 0 "option --idle-timeout error"
  CHECK_RESULT $? 0 0 "option --active-timeout error"
  CHECK_RESULT $? 0 0 "option --timeout error"
  CHECK_RESULT $? 0 0 "option --one-shot error"
  CHECK_RESULT $? 0 0 "option --quiet error"
  CHECK_RESULT $? 0 0 "option --writable error"
  CHECK_RESULT $? 0 0 "option --help error"
  CHECK_RESULT $? 0 0 "option --version error"
```

- 涉及命令：kill×1
