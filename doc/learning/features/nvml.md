# nvml

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nvml` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nvml_daxio | verify the uasge of nvml command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_nvml_pmempool | verify the uasge of nvml command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_nvml_rpmemd | verify the uasge of nvml command | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_nvml_daxio

- 描述：verify the uasge of nvml command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check daxio -h failed"
  CHECK_RESULT $? 0 0 "Check daxio --help failed"
  CHECK_RESULT $? 0 0 "Check daxio -V failed"
  CHECK_RESULT $? 0 0 "Check daxio --version failed"
```

- 涉及命令：daxio×2

#### oe_test_nvml_pmempool

- 描述：verify the uasge of nvml command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check pmempool create failed"
  CHECK_RESULT $? 0 0 "Check pmempool info failed"
  CHECK_RESULT $? 0 0 "Check pmempool -f failed"
  CHECK_RESULT $? 0 0 "Check pmempool check failed"
  CHECK_RESULT $? 0 0 "Check pmempool -V failed"
  CHECK_RESULT $? 0 0 "Check pmempool --version failed"
  CHECK_RESULT $? 0 0 "Check pmempool -h failed"
  CHECK_RESULT $? 0 0 "Check pmempool --help failed"
  CHECK_RESULT $? 0 0 "Check pmempool rm failed"
```

- 涉及命令：pmempool×2, test×1

#### oe_test_nvml_rpmemd

- 描述：verify the uasge of nvml command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check rpmemd -h failed"
  CHECK_RESULT $? 0 0 "Check rpmemd --help failed"
  CHECK_RESULT $? 0 0 "Check rpmemd -V failed"
  CHECK_RESULT $? 0 0 "Check rpmemd --version failed"
  CHECK_RESULT $? 0 0 "Check rpmemd -c failed"
```

- 涉及命令：rpmemd×3, pkill×1
