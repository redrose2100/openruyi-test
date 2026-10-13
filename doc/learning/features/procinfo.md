# procinfo

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/procinfo` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_procinfo_01 | Test Command procinfo | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_procinfo_02 | Test Command procinfo | pre_test/run_test/post_test | 14 | ✔ |  |  |

### 断言与命令明细

#### oe_test_procinfo_01

- 描述：Test Command procinfo
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Option test -f fails"
  CHECK_RESULT $? 0 0 "Interactive test key s fails"
  CHECK_RESULT $? 0 0 "Interactive test key m fails"
  CHECK_RESULT $? 0 0 "Interactive test key a fails"
  CHECK_RESULT $? 0 0 "Interactive test key r fails"
  CHECK_RESULT $? 0 0 "Interactive test key C fails"
  CHECK_RESULT $? 0 0 "Interactive test key R fails"
  CHECK_RESULT $? 0 0 "Interactive test key t fails"
  CHECK_RESULT $? 0 0 "Interactive test key d fails"
  CHECK_RESULT $? 0 0 "Interactive test key D fails"
  CHECK_RESULT $? 0 0 "Interactive test key S fails"
  CHECK_RESULT $? 0 0 "Interactive test key i fails"
  ... 共 18 条（其余见源脚本）
```

#### oe_test_procinfo_02

- 描述：Test Command procinfo
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "No option test fails"
  CHECK_RESULT $? 0 0 "Option test -b fails"
  CHECK_RESULT $? 0 0 "Option test -s fails"
  CHECK_RESULT $? 0 0 "Option test -m fails"
  CHECK_RESULT $? 0 0 "Option test -a fails"
  CHECK_RESULT $? 0 0 "Option test -i fails"
  CHECK_RESULT $? 0 0 "Option test -nN fails"
  CHECK_RESULT $? 0 0 "Option test -d fails"
  CHECK_RESULT $? 0 0 "Option test -D fails"
  CHECK_RESULT $? 0 0 "Option test -S fails"
  CHECK_RESULT $? 0 0 "Option test -r fails"
  CHECK_RESULT $? 0 0 "Option test -Ffile fails"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：procinfo×7
