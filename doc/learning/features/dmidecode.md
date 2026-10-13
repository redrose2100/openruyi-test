# dmidecode

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/dmidecode` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_dmidecode | test dmidecode | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_biosdecode | Test biosdecode | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_dmidecode_extend | test dmidecode dump/handle/help/quiet/string/types | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_dmidecode

- 描述：test dmidecode
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "dmidecode -h fail"
  CHECK_RESULT $? 0 0 "dmidecode -t system fail"
  CHECK_RESULT $? 0 0 "dmidecode -t bios fail"
  CHECK_RESULT $? 0 0 "dmidecode -t baseboard fail"
  CHECK_RESULT $? 0 0 "dmidecode -t chassis fail"
  CHECK_RESULT $? 0 0 "dmidecode -t processor fail"
  CHECK_RESULT $? 0 0 "dmidecode -t memory fail"
  CHECK_RESULT $? 0 0 "dmidecode -t cache fail"
```

- 涉及命令：dmidecode×8

#### oe_test_biosdecode

- 描述：Test biosdecode
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "failed to get biosdecode version by -V"
  CHECK_RESULT $? 0 0 "failed to get usage by -h"
  CHECK_RESULT $? 0 0 "biosdecode failed OR get a different version"
  CHECK_RESULT $? 0 0 "biosdecode failed OR get a different version"
  CHECK_RESULT $? 0 0 "lack of -d option in usage"
```

- 涉及命令：biosdecode×1

#### oe_test_dmidecode_extend

- 描述：test dmidecode dump/handle/help/quiet/string/types
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "dmidecode help check failed"
  CHECK_RESULT $? 0 0 "dmidecode quiet mode failed"
  CHECK_RESULT $? 0 0 "quiet output is empty"
  CHECK_RESULT $? 0 0 "dmidecode string query failed"
  CHECK_RESULT $? 0 0 "dmidecode type query failed"
  CHECK_RESULT $? 0 0 "type output is empty"
  CHECK_RESULT $? 0 0 "dmidecode handle query failed"
  CHECK_RESULT $? 0 0 "dmidecode dump failed"
  CHECK_RESULT $? 0 0 "dump file not generated"
  CHECK_RESULT $? 0 0 "dump file is empty"
  CHECK_RESULT $? 0 1 "invalid string keyword should fail"
```

- 涉及命令：dmidecode×6
