# libfabric

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libfabric` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libfabric_fi_info_01 | verify the uasge of libfabric command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libfabric_fi_info_02 | verify the uasge of libfabric command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_libfabric_fi_info_03 | verify the uasge of libfabric command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_libfabric_pingpong_01 | verify the uasge of libfabric command | pre_test/run_test/post_test | 10 | ✔ | ✔ |  |
| oe_test_libfabric_pingpong_02 | verify the uasge of libfabric command | pre_test/run_test/post_test | 8 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_libfabric_fi_info_01

- 描述：verify the uasge of libfabric command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check fi_info -h failed"
  CHECK_RESULT $? 0 0 "Check fi_info --help failed"
  CHECK_RESULT $? 0 0 "Check fi_info -n failed"
  CHECK_RESULT $? 0 0 "Check fi_info --node failed"
  CHECK_RESULT $? 0 0 "Check fi_info -P failed"
  CHECK_RESULT $? 0 0 "Check fi_info --port failed"
  CHECK_RESULT $? 0 0 "Check fi_info -c failed"
  CHECK_RESULT $? 0 0 "Check fi_info --caps failed"
  CHECK_RESULT $? 0 0 "Check fi_info --mode failed"
  CHECK_RESULT $? 0 0 "Check fi_info -m failed"
```

- 涉及命令：fi_info×5

#### oe_test_libfabric_fi_info_02

- 描述：verify the uasge of libfabric command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check fi_info -t failed"
  CHECK_RESULT $? 0 0 "Check fi_info --ep_type failed"
  CHECK_RESULT $? 0 0 "Check fi_info -f failed"
  CHECK_RESULT $? 0 0 "Check fi_info --fabric failed"
  CHECK_RESULT $? 0 0 "Check fi_info -a failed"
  CHECK_RESULT $? 0 0 "Check fi_info --addr_format failed"
  CHECK_RESULT $? 0 0 "Check fi_info -e failed"
  CHECK_RESULT $? 0 0 "Check fi_info --env failed"
  CHECK_RESULT $? 0 0 "Check fi_info -l failed"
  CHECK_RESULT $? 0 0 "Check fi_info --list failed"
```

- 涉及命令：fi_info×5

#### oe_test_libfabric_fi_info_03

- 描述：verify the uasge of libfabric command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check fi_info -v failed"
  CHECK_RESULT $? 0 0 "Check fi_info -v failed"
  CHECK_RESULT $? 0 0 "Check fi_info --version failed"
  CHECK_RESULT $? 0 0 "Check fi_strerror 0 failed"
```

- 涉及命令：fi_info×1

#### oe_test_libfabric_pingpong_01

- 描述：verify the uasge of libfabric command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -p -e -v -m failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -P -p failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -p failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -p failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -e -v failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -p -e -v failed"
```

- 涉及命令：fi_pingpong×5

#### oe_test_libfabric_pingpong_02

- 描述：verify the uasge of libfabric command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -I -S failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -p -I -S failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -I -S failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -c -m failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -B -I -S -m failed"
  CHECK_RESULT $? 0 0 "Check fi_pingpong -h failed"
```

- 涉及命令：fi_pingpong×5
