# netlabel_tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/netlabel_tools` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_netlabel | Test netlabel.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_netlabel_tools_netlabelctl_01 | verify the uasge of nasm command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_netlabel_tools_netlabelctl_02 | verify the uasge of nasm command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_netlabel_tools_netlabelctl_03 | verify the uasge of nasm command | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_netlabel

- 描述：Test netlabel.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_netlabel_tools_netlabelctl_01

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check netlabelctl -h failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl -V failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl -p map list failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl add pass doi failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl -p unlbl accept on failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl unlbl accept off failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl unlbl list failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl -v mgmt version failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl -v mgmt protocols failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl mgmt version failed"
```

- 涉及命令：netlabelctl×6

#### oe_test_netlabel_tools_netlabelctl_02

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check netlabelctl cipsov4 add pass failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl cipsov4 del failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl cipsov4 add trans doi:8 tags:1 levels:0=0,1=1 categories:0=1,1=0 failed"
  CHECK_RESULT $? 0 0 "Check cipsov4 del failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl cipsov4 add local failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl cipsov4 del failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl -p cipsov4 list failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl cipso add failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl -p cipso -v -t failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl cipso del failed"
```

- 涉及命令：netlabelctl×2

#### oe_test_netlabel_tools_netlabelctl_03

- 描述：verify the uasge of nasm command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check netlabelctl mgmt protocols failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl calipso add pass failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl calipso del failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl calipso list failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl calipso unlbl add interface failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl calipso unlbl del interface failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl calipso map add default failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl map add failed"
  CHECK_RESULT $? 0 0 "Check netlabelctl calipso map add failed"
```
