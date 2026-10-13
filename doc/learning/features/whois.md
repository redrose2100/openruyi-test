# whois

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/whois` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_whois_01 | command test whois | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_whois_02 | command test whois | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_whois_03 | command test whois | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_whois_01

- 描述：command test whois
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "test whois basic failed"
  CHECK_RESULT $? 0 0 "test whois -h failed"
  CHECK_RESULT $? 0 0 "test whois --host failed"
  CHECK_RESULT $? 0 0 "test whois -p failed"
  CHECK_RESULT $? 0 0 "test whois --port failed"
  CHECK_RESULT $? 0 0 "test whois -I failed"
  CHECK_RESULT $? 1 0 "test whois -H failed"
  CHECK_RESULT $? 0 0 "test whois --verbose failed"
  CHECK_RESULT $? 0 0 "test whois --help failed"
  CHECK_RESULT $? 0 0 "test whois --version failed"
  CHECK_RESULT $? 0 0 "test whois -l failed"
  CHECK_RESULT $? 0 0 "test whois -L failed"
```

- 涉及命令：whois×5, kill×2

#### oe_test_whois_02

- 描述：command test whois
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "test whois -m failed"
  CHECK_RESULT $? 0 0 "test whois -M failed"
  CHECK_RESULT $? 0 0 "test whois -c failed"
  CHECK_RESULT $? 0 0 "test whois -x failed"
  CHECK_RESULT $? 0 0 "test whois -b failed"
  CHECK_RESULT $? 0 0 "test whois -B failed"
  CHECK_RESULT $? 0 0 "test whois -G failed"
  CHECK_RESULT $? 0 0 "test whois -d failed"
  CHECK_RESULT $? 0 0 "test whois -i failed"
```

- 涉及命令：whois×9

#### oe_test_whois_03

- 描述：command test whois
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "test whois -K failed"
  CHECK_RESULT $? 0 0 "test whois -r failed"
  CHECK_RESULT $? 0 0 "test whois -R failed"
  CHECK_RESULT $? 0 0 "test whois -a failed"
  CHECK_RESULT $? 0 0 "test whois -s failed"
  CHECK_RESULT $? 0 0 "test whois -g failed"
  CHECK_RESULT $? 0 0 "test whois -t failed"
  CHECK_RESULT $? 0 0 "test whois -v failed"
  CHECK_RESULT $? 0 0 "test whois -q failed"
```

- 涉及命令：whois×9
