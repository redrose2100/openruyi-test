# socat

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/socat` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_socat_01 | verify the uasge of socat command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_socat_02 | verify the uasge of socat command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_socat_03 | verify the uasge of socat command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_socat_filan | verify the uasge of socat command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_socat_procan | verify the uasge of socat command | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_socat_01

- 描述：verify the uasge of socat command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check socat -V failed"
  CHECK_RESULT $? 0 0 "Check socat -h failed"
  CHECK_RESULT $? 0 0 "Check socat -hh failed"
  CHECK_RESULT $? 0 0 "Check socat -hhh failed"
  CHECK_RESULT $? 0 0 "Check socat -b failed"
  CHECK_RESULT $? 0 0 "Check socat -4 failed"
  CHECK_RESULT $? 0 0 "Check socat -6 failed"
  CHECK_RESULT $? 0 0 "Check socat -U failed"
  CHECK_RESULT $? 0 0 "Check socat -g failed"
```

- 涉及命令：socat×13

#### oe_test_socat_02

- 描述：verify the uasge of socat command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check socat -T failed"
  CHECK_RESULT $? 0 0 "Check socat -T failed"
  CHECK_RESULT $? 0 0 "Check socat -s failed"
  CHECK_RESULT $? 0 0 "Check socat -x failed"
  CHECK_RESULT $? 0 0 "Check socat -v failed"
  CHECK_RESULT $? 0 0 "Check socat -lh failed"
  CHECK_RESULT $? 0 0 "Check socat -lu failed"
  CHECK_RESULT $? 0 0 "Check socat -lp failed"
  CHECK_RESULT $? 0 0 "Check socat -lm failed"
  CHECK_RESULT $? 0 0 "Check socat -ls failed"
```

- 涉及命令：socat×20

#### oe_test_socat_03

- 描述：verify the uasge of socat command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check socat -lf failed"
  CHECK_RESULT $? 0 0 "Check socat -ly failed"
  CHECK_RESULT $? 0 0 "Check socat -D failed"
  CHECK_RESULT $? 0 0 "Check socat -d failed"
  CHECK_RESULT $? 0 0 "Check socat -L failed"
  CHECK_RESULT $? 0 0 "Check socat -W failed"
```

- 涉及命令：socat×12

#### oe_test_socat_filan

- 描述：verify the uasge of socat command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check filan -h failed"
  CHECK_RESULT $? 0 0 "Check filan -? failed"
  CHECK_RESULT $? 0 0 "Check filan -d failed"
  CHECK_RESULT $? 0 0 "Check filan -i failed"
  CHECK_RESULT $? 0 0 "Check filan -n failed"
  CHECK_RESULT $? 0 0 "Check filan -s failed"
  CHECK_RESULT $? 0 0 "Check filan -f failed"
  CHECK_RESULT $? 0 0 "Check filan -T failed"
  CHECK_RESULT $? 0 0 "Check filan -r failed"
  CHECK_RESULT $? 0 0 "Check filan -L failed"
  CHECK_RESULT $? 0 0 "Check filan -o failed"
```

- 涉及命令：filan×9

#### oe_test_socat_procan

- 描述：verify the uasge of socat command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check procan -h  failed"
  CHECK_RESULT $? 0 0 "Check procan -?  failed"
  CHECK_RESULT $? 0 0 "Check procan -c  failed"
```

- 涉及命令：procan×2
