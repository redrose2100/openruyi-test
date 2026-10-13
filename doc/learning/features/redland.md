# redland

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/redland` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_redland_rdfproc_01 | verify the uasge of redland command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_redland_rdfproc_02 | verify the uasge of redland command | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_redland_rdfproc_01

- 描述：verify the uasge of redland command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check rdfproc -h failed"
  CHECK_RESULT $? 0 0 "Check rdfproc --help failed"
  CHECK_RESULT $? 0 0 "Check rdfproc -c test serialize ntriples failed"
  CHECK_RESULT $? 0 0 "Check rdfproc --contexts test1 serialize ntriples failed"
  CHECK_RESULT $? 0 0 "Check rdfproc -n test2 add SUBJECT PREDICATE OBJECT failed"
  CHECK_RESULT $? 0 0 "Check rdfproc --new test3 add SUBJECT PREDICATE OBJECT failed"
  CHECK_RESULT $? 0 0 "Check rdfproc -o rdfxml test4 print failed"
  CHECK_RESULT $? 0 0 "Check rdfproc --output ntriples test5 print failed"
  CHECK_RESULT $? 0 0 "Check echo Huawei@123 | rdfproc -p test6 add SUBJECT PREDICATE OBJECT failed"
  CHECK_RESULT $? 0 0 "Check echo Huawei@123 | rdfproc --password test7 add SUBJECT PREDICATE OBJECT failed"
```

- 涉及命令：rdfproc×4

#### oe_test_redland_rdfproc_02

- 描述：verify the uasge of redland command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"
  CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"
  CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"
  CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"
  CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"
  CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"
  CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"
  CHECK_RESULT $? 0 0 "Check rdfproc -q test add SUBJECT PREDICATE OBJECT failed"
  CHECK_RESULT $? 0 0 "Check rdfproc -v failed"
  CHECK_RESULT $? 0 0 "Check rdfproc --version failed"
  CHECK_RESULT $? 0 0 "Check redland-db-upgrade test newtest failed"
```

- 涉及命令：rdfproc×5
