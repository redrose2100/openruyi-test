# httpry

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/httpry` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_httpry_01 | Test fetch-crl | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_httpry_02 | Test fetch-crl | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_httpry_01

- 描述：Test fetch-crl
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check httpry -h failed"
  CHECK_RESULT $? 0 0 "Check httpry -b failed"
  CHECK_RESULT $? 0 0 "Check httpry -i failed"
  CHECK_RESULT $? 0 0 "Check httpry -r failed"
  CHECK_RESULT $? 0 0 "Check httpry -o failed"
  CHECK_RESULT $? 0 0 "Check httpry -m failed"
  CHECK_RESULT $? 0 0 "Check httpry -d failed"
  CHECK_RESULT $? 0 0 "Check httpry -t failed"
```

- 涉及命令：httpry×9, pkill×7, test×2

#### oe_test_httpry_02

- 描述：Test fetch-crl
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check httpry -f failed"
  CHECK_RESULT $? 0 0 "Check httpry -F failed"
  CHECK_RESULT $? 0 0 "Check httpry -n failed"
  CHECK_RESULT $? 0 0 "Check httpry -p failed"
  CHECK_RESULT $? 0 0 "Check httpry -q failed"
  CHECK_RESULT $? 0 0 "Check httpry -s failed"
  CHECK_RESULT $? 0 0 "Check httpry -l failed"
  CHECK_RESULT $? 0 0 "Check httpry -P failed"
  CHECK_RESULT $? 0 0 "Check httpry -u failed"
```

- 涉及命令：httpry×10, pkill×9
