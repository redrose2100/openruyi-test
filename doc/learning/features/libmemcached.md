# libmemcached

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libmemcached` |
| 注册用例数 | 12 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_memaslap | verify the uasge of memaslap command | pre_test/run_test/post_test | 17 |  |  |  |
| oe_test_memcapable | verify the uasge of memcapable command | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_memcat | verify the uasge of memcat command | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_memcp | verify the uasge of memcp command | pre_test/run_test/post_test | 19 |  |  |  |
| oe_test_memdump-memerror | verify the uasge of memdump and memerror command | pre_test/run_test/post_test | 11 |  |  |  |
| oe_test_memexist | verify the uasge of memexist command | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_memflush | verify the uasge of memflush command | pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_memping | verify the uasge of memping command | pre_test/run_test/post_test | 6 |  |  |  |
| oe_test_memrm | verify the uasge of memrm command | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_memslap | verify the uasge of memslap command | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_memstat | verify the uasge of memstat command | pre_test/run_test/post_test | 9 |  |  |  |
| oe_test_memtouch | verify the uasge of memtouch command | pre_test/run_test/post_test | 7 |  |  |  |

### 断言与命令明细

#### oe_test_memaslap

- 描述：verify the uasge of memaslap command
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

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
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：memaslap×8, grep×7, memcached×1

#### oe_test_memcapable

- 描述：verify the uasge of memcapable command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```

- 涉及命令：memcapable×8

#### oe_test_memcat

- 描述：verify the uasge of memcat command
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

- 涉及命令：test×1

#### oe_test_memcp

- 描述：verify the uasge of memcp command
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：test×2

#### oe_test_memdump-memerror

- 描述：verify the uasge of memdump and memerror command
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

- 涉及命令：test×1

#### oe_test_memexist

- 描述：verify the uasge of memexist command
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

#### oe_test_memflush

- 描述：verify the uasge of memflush command
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
  CHECK_RESULT $? 1
```

#### oe_test_memping

- 描述：verify the uasge of memping command
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

- 涉及命令：memcached×1

#### oe_test_memrm

- 描述：verify the uasge of memrm command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
```

#### oe_test_memslap

- 描述：verify the uasge of memslap command
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

#### oe_test_memstat

- 描述：verify the uasge of memstat command
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

#### oe_test_memtouch

- 描述：verify the uasge of memtouch command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
```
