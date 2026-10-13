# openjade

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/openjade` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_openjade_jade_01 | verify the uasge of openjade command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_openjade_jade_02 | verify the uasge of openjade command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_openjade_jade_03 | verify the uasge of openjade command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_openjade_openjade_01 | verify the uasge of openjade command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_openjade_openjade_02 | verify the uasge of openjade command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_openjade_openjade_03 | verify the uasge of openjade command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_openjade_openjade_04 | verify the uasge of openjade command | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_openjade_jade_01

- 描述：verify the uasge of openjade command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check jade -b failed"
  CHECK_RESULT $? 0 0 "Check jade --encoding failed"
  CHECK_RESULT $? 0 0 "Check jade -f failed"
  CHECK_RESULT $? 0 0 "Check jade --error-file failed"
  CHECK_RESULT $? 0 0 "Check jade -v failed"
  CHECK_RESULT $? 0 0 "Check jade --version failed"
  CHECK_RESULT $? 0 0 "Check jade -h failed"
  CHECK_RESULT $? 0 0 "Check jade -help failed"
```

- 涉及命令：jade×5

#### oe_test_openjade_jade_02

- 描述：verify the uasge of openjade command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check jade -D failed"
  CHECK_RESULT $? 0 0 "Check jade  --directory failed"
  CHECK_RESULT $? 0 0 "Check jade -R  failed"
  CHECK_RESULT $? 0 0 "Check jade --restricted failed"
  CHECK_RESULT $? 0 0 "Check jade -a failed"
  CHECK_RESULT $? 0 0 "Check jade --activate failed"
  CHECK_RESULT $? 0 0 "Check jade -A failed"
  CHECK_RESULT $? 0 0 "Check jade --architecture failed"
  CHECK_RESULT $? 0 0 "Check jade -E failed"
  CHECK_RESULT $? 0 0 "Check jade --max-errors failed"
```

- 涉及命令：jade×10

#### oe_test_openjade_jade_03

- 描述：verify the uasge of openjade command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check jade -e failed"
  CHECK_RESULT $? 0 0 "Check jade --open-entities failed"
  CHECK_RESULT $? 0 0 "Check jade -g failed"
  CHECK_RESULT $? 0 0 "Check jade --open-elements failed"
  CHECK_RESULT $? 0 0 "Check jade -n failed"
  CHECK_RESULT $? 0 0 "Check jade --error-numbers failed"
  CHECK_RESULT $? 0 0 "Check jade -x failed"
  CHECK_RESULT $? 0 0 "Check jade --references failed"
  CHECK_RESULT $? 0 0 "Check jade -i failed"
  CHECK_RESULT $? 0 0 "Check jade --include failed"
```

- 涉及命令：jade×10

#### oe_test_openjade_openjade_01

- 描述：verify the uasge of openjade command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check openjade -b failed"
  CHECK_RESULT $? 0 0 "Check openjade --encoding failed"
  CHECK_RESULT $? 0 0 "Check openjade -f failed"
  CHECK_RESULT $? 0 0 "Check openjade --error-file failed"
  CHECK_RESULT $? 0 0 "Check openjade -v failed"
  CHECK_RESULT $? 0 0 "Check openjade --version failed"
  CHECK_RESULT $? 0 0 "Check openjade -h failed"
  CHECK_RESULT $? 0 0 "Check openjade -help failed"
```

- 涉及命令：openjade×5

#### oe_test_openjade_openjade_02

- 描述：verify the uasge of openjade command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check openjade -D failed"
  CHECK_RESULT $? 0 0 "Check openjade  --directory failed"
  CHECK_RESULT $? 0 0 "Check openjade -R  failed"
  CHECK_RESULT $? 0 0 "Check openjade --restricted failed"
  CHECK_RESULT $? 0 0 "Check openjade -a failed"
  CHECK_RESULT $? 0 0 "Check openjade --activate failed"
  CHECK_RESULT $? 0 0 "Check openjade -A failed"
  CHECK_RESULT $? 0 0 "Check openjade --architecture failed"
  CHECK_RESULT $? 0 0 "Check openjade -E failed"
  CHECK_RESULT $? 0 0 "Check openjade --max-errors failed"
```

- 涉及命令：openjade×10

#### oe_test_openjade_openjade_03

- 描述：verify the uasge of openjade command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check openjade -e failed"
  CHECK_RESULT $? 0 0 "Check openjade --open-entities failed"
  CHECK_RESULT $? 0 0 "Check openjade -g failed"
  CHECK_RESULT $? 0 0 "Check openjade --open-elements failed"
  CHECK_RESULT $? 0 0 "Check openjade -n failed"
  CHECK_RESULT $? 0 0 "Check openjade --error-numbers failed"
  CHECK_RESULT $? 0 0 "Check openjade -x failed"
  CHECK_RESULT $? 0 0 "Check openjade --references failed"
  CHECK_RESULT $? 0 0 "Check openjade -i failed"
  CHECK_RESULT $? 0 0 "Check openjade --include failed"
```

- 涉及命令：openjade×10

#### oe_test_openjade_openjade_04

- 描述：verify the uasge of openjade command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check openjade -w failed"
  CHECK_RESULT $? 0 0 "Check openjade --warning failed"
  CHECK_RESULT $? 0 0 "Check jade -w failed"
  CHECK_RESULT $? 0 0 "Check jade --warning failed"
```

- 涉及命令：openjade×2, jade×2
