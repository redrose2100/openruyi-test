# fetch-crl

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fetch-crl` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_clean-crl | Test fetch-crl | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_fetch_crl_service | Test fetch-crl | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_fetch_crl_01 | Test fetch-crl | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_fetch_crl_02 | Test fetch-crl | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_fetch_crl_03 | Test fetch-crl | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_clean-crl

- 描述：Test fetch-crl
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check clean-crl --help failed"
  CHECK_RESULT $? 0 0 "Check clean-crl -h failed"
  CHECK_RESULT $? 0 0 "Check clean-crl -V failed"
  CHECK_RESULT $? 0 0 "Check clean-crl --version failed"
  CHECK_RESULT $? 1 0 "Check clean-crl -l failed"
  CHECK_RESULT $? 1 0 "Check clean-crl --cadir failed"
  CHECK_RESULT $? 0 0 "Check clean-crl -v failed"
  CHECK_RESULT $? 0 0 "Check clean-crl --verbose failed"
  CHECK_RESULT $? 0 0 "Check clean-crl -n failed"
  CHECK_RESULT $? 0 0 "Check clean-crl --dryrun failed"
```

- 涉及命令：fetch-crl×6, clean-crl×2

#### oe_test_fetch_crl_service

- 描述：Test fetch-crl
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check fetch-crl service start failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl service status  failed"
```

- 涉及命令：sed×1

#### oe_test_fetch_crl_01

- 描述：Test fetch-crl
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check fetch-crl --help failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --help failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl -V failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --version failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl -l failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --infodir failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl -c failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --config failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl -v failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --verbose failed"
```

- 涉及命令：fetch-crl×6

#### oe_test_fetch_crl_02

- 描述：Test fetch-crl
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check fetch-crl -q failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --quiet failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --cadir failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl -s failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --statedir failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl -T failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --httptimeout failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --output failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl -o failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --format failed"
```

- 涉及命令：fetch-crl×5, mkdir×1

#### oe_test_fetch_crl_03

- 描述：Test fetch-crl
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check fetch-crl -p failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --parallelism failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --randomwait failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl -r failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --nosymlinks failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl --agingtolerance failed"
  CHECK_RESULT $? 0 0 "Check fetch-crl -a failed"
```

- 涉及命令：fetch-crl×1
