# mikmod

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/mikmod` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_mikmod_mikmod_02 | TEST mikmod options | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_mikmod_mikmod_01 | TEST mikmod options | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_mikmod_mikmod_03 | TEST mikmod options | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_mikmod_mikmod_04 | TEST mikmod options | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_mikmod_mikmod_05 | TEST mikmod options | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_mikmod_mikmod_06 | TEST mikmod options | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_mikmod_mikmod_07 | TEST mikmod options | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_mikmod_mikmod_02

- 描述：TEST mikmod options
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check mikmod -y failed"
  CHECK_RESULT $? 0 0 "Check mikmod -di[rectory] failed"
  CHECK_RESULT $? 0 0 "Check mikmod -q[uiet] failed"
  CHECK_RESULT $? 0 0 "Check mikmod -quiet failed"
  CHECK_RESULT $? 0 0 "Check mikmod -v 1 failed"
  CHECK_RESULT $? 0 0 "Check mikmod -volume 1 failed"
  CHECK_RESULT $? 0 0 "Check mikmod -o[utput] 8m failed"
  CHECK_RESULT $? 0 0 "Check mikmod -o[utput] 8s failed"
  CHECK_RESULT $? 0 0 "Check mikmod -o[utput] 16m failed"
  CHECK_RESULT $? 0 0 "Check mikmod -o[utput] 16s failed"
  CHECK_RESULT $? 0 0 "Check mikmod -output 8m failed"
```

- 涉及命令：mikmod×1, modprobe×1

#### oe_test_mikmod_mikmod_01

- 描述：TEST mikmod options
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check mikmod-h failed."
  CHECK_RESULT $? 0 0 "Check mikmod--help failed"
  CHECK_RESULT $? 0 0 "Check mikmod-V failed"
  CHECK_RESULT $? 0 0 "Check mikmod-version failed"
  CHECK_RESULT $? 0 0 "Check mikmod-n failed"
  CHECK_RESULT $? 0 0 "Check mikmod-in[formation] failed"
  CHECK_RESULT $? 0 0 "Check mikmod-N 1 failed"
  CHECK_RESULT $? 0 0 "Check mikmod-drvinfo 1 failed"
  CHECK_RESULT $? 0 0 "Check mikmod-d 1 failed"
  CHECK_RESULT $? 0 0 "Check mikmod-driver 2 failed"
```

- 涉及命令：mikmod×7, modprobe×1

#### oe_test_mikmod_mikmod_03

- 描述：TEST mikmod options
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check mikmod -c failed"
  CHECK_RESULT $? 0 0 "Check mikmod -noc failed"
  CHECK_RESULT $? 0 0 "Check mikmod -curious failed"
  CHECK_RESULT $? 0 0 "Check mikmod -nocurious failed"
  CHECK_RESULT $? 0 0 "Check mikmod -p 1 failed"
  CHECK_RESULT $? 0 0 "Check mikmod -p 2 failed"
  CHECK_RESULT $? 0 0 "Check mikmod -p 4 failed"
  CHECK_RESULT $? 0 0 "Check mikmod -p 8 failed"
  CHECK_RESULT $? 0 0 "Check mikmod -playmode 1 failed"
  CHECK_RESULT $? 0 0 "Check mikmod -t failed"
  CHECK_RESULT $? 0 0 "Check mikmod -not failed"
  CHECK_RESULT $? 0 0 "Check mikmod -tolerant failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：modprobe×1

#### oe_test_mikmod_mikmod_04

- 描述：TEST mikmod options
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check mikmod -f 11025 failed"
  CHECK_RESULT $? 0 0 "Check mikmod -frequency 11025 failed"
  CHECK_RESULT $? 0 0 "Check mikmod -r 0 failed"
  CHECK_RESULT $? 0 0 "Check mikmod -reverb 0 failed"
  CHECK_RESULT $? 0 0 "Check mikmod -F failed"
  CHECK_RESULT $? 0 0 "Check mikmod -nofa failed"
  CHECK_RESULT $? 0 0 "Check mikmod -fa failed"
  CHECK_RESULT $? 0 0 "Check mikmod -fadeout failed"
  CHECK_RESULT $? 0 0 "Check mikmod -nofadeout failed"
  CHECK_RESULT $? 0 0 "Check mikmod -l failed"
  CHECK_RESULT $? 0 0 "Check mikmod -nol failed"
  CHECK_RESULT $? 0 0 "Check mikmod -loops failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：modprobe×1

#### oe_test_mikmod_mikmod_05

- 描述：TEST mikmod options
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check mikmod -pa failed"
  CHECK_RESULT $? 0 0 "Check mikmod -nopa failed"
  CHECK_RESULT $? 0 0 "Check mikmod -a failed"
  CHECK_RESULT $? 0 0 "Check mikmod -panning failed"
  CHECK_RESULT $? 0 0 "Check mikmod -nopanning failed"
  CHECK_RESULT $? 0 0 "Check mikmod -pr failed"
  CHECK_RESULT $? 0 0 "Check mikmod -nopr failed"
  CHECK_RESULT $? 0 0 "Check mikmod -x failed"
  CHECK_RESULT $? 0 0 "Check mikmod -protracker failed"
  CHECK_RESULT $? 0 0 "Check mikmod -noprotracker failed"
```

- 涉及命令：modprobe×1

#### oe_test_mikmod_mikmod_06

- 描述：TEST mikmod options
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Check mikmod -ren failed"
  CHECK_RESULT $? 0 0 "Check mikmod -renice failed"
  CHECK_RESULT $? 0 0 "Check mikmod -norenice failed"
  CHECK_RESULT $? 0 0 "Check mikmod -s failed"
  CHECK_RESULT $? 0 0 "Check mikmod -rea failed"
  CHECK_RESULT $? 0 0 "Check mikmod -norea failed"
  CHECK_RESULT $? 0 0 "Check mikmod -realtime failed"
  CHECK_RESULT $? 0 0 "Check mikmod -norealtime failed"
  CHECK_RESULT $? 0 0 "Check mikmod -S failed"
  CHECK_RESULT $? 0 0 "Check mikmod -i failed"
  CHECK_RESULT $? 0 0 "Check mikmod -noi failed"
  CHECK_RESULT $? 0 0 "Check mikmod -interpolate failed"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：modprobe×1

#### oe_test_mikmod_mikmod_07

- 描述：TEST mikmod options
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check mikmod -hq failed"
  CHECK_RESULT $? 0 0 "Check mikmod -nohq failed"
  CHECK_RESULT $? 0 0 "Check mikmod -hqmixer failed"
  CHECK_RESULT $? 0 0 "Check mikmod -nohqmixer failed"
  CHECK_RESULT $? 0 0 "Check mikmod -su failed"
  CHECK_RESULT $? 0 0 "Check mikmod -nosu failed"
  CHECK_RESULT $? 0 0 "Check mikmod -surround failed"
  CHECK_RESULT $? 0 0 "Check mikmod -nosurround failed"
  CHECK_RESULT $? 0 0 "Check mikmod -norc failed"
```

- 涉及命令：modprobe×1
