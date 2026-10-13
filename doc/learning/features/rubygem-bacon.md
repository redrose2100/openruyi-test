# rubygem-bacon

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rubygem-bacon` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_bacon_01 | Test bacon | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_bacon_02 | Test bacon | pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_bacon_01

- 描述：Test bacon
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "Check bacon -h failed"
  CHECK_RESULT $? 0 0 "Check bacon --help failed"
  CHECK_RESULT $? 0 0 "Check bacon --version failed"
  CHECK_RESULT $? 0 0 "Check bacon -s failed"
  CHECK_RESULT $? 0 0 "Check bacon --specdox failed"
  CHECK_RESULT $? 0 0 "Check bacon -q failed"
  CHECK_RESULT $? 0 0 "Check bacon --quite failed"
  CHECK_RESULT $? 0 0 "Check bacon -p failed"
  CHECK_RESULT $? 0 0 "Check bacon --tap failed"
  CHECK_RESULT $? 0 0 "Check bacon -k failed"
  CHECK_RESULT $? 0 0 "Check bacon --knock failed"
  CHECK_RESULT $? 0 0 "Check bacon -o failed"
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：bacon×8, tar×1

#### oe_test_bacon_02

- 描述：Test bacon
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "Check bacon -n failed"
  CHECK_RESULT $? 0 0 "Check bacon --name failed"
  CHECK_RESULT $? 0 0 "Check bacon -d failed"
  CHECK_RESULT $? 0 0 "Check bacon --debug failed"
  CHECK_RESULT $? 0 0 "Check bacon -w failed"
  CHECK_RESULT $? 0 0 "Check bacon --warn failed"
  CHECK_RESULT $? 0 0 "Check bacon -I failed"
  CHECK_RESULT $? 0 0 "Check bacon --include failed"
  CHECK_RESULT $? 0 0 "Check bacon -r failed"
  CHECK_RESULT $? 0 0 "Check bacon --require failed"
  CHECK_RESULT $? 0 0 "Check bacon -t failed"
  CHECK_RESULT $? 0 0 "Check bacon --testcase failed"
```

- 涉及命令：bacon×3, tar×1
