# tinycdb

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/tinycdb` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_tinycdb_cdb_01 | Test tinycdb | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_tinycdb_cdb_02 | Test tinycdb | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_tinycdb_cdb_01

- 描述：Test tinycdb
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: cdb -h"
  CHECK_RESULT $? 0 0 "Failed option: cdb -c"
  CHECK_RESULT $? 0 0 "Failed option: -c -m"
  CHECK_RESULT $? 0 0 "Failed option: cdb -c -w "
  CHECK_RESULT $? 0 0 "Failed option: cdb -c -e"
  CHECK_RESULT $? 0 0 "Failed option: cdb -c -r"
  CHECK_RESULT $? 0 0 "Failed option: cdb -c -0"
  CHECK_RESULT $? 0 0 "Failed option: cdb -c -u"
  CHECK_RESULT $? 0 0 "Failed option: cdb -q"
  CHECK_RESULT $? 0 0 "Failed option: cdb -q -n"
```

- 涉及命令：cdb×9, tar×1

#### oe_test_tinycdb_cdb_02

- 描述：Test tinycdb
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: cdb -l"
  CHECK_RESULT $? 0 0 "Failed option: cdb -d"
  CHECK_RESULT $? 0 0 "Failed option: cdb -s"
  CHECK_RESULT $? 0 0 "Failed option: cdb -c -p "
  CHECK_RESULT $? 0 0 "Failed option: cdb -c -wrue0 "
  CHECK_RESULT $? 0 0 "Failed option: cdb -c -t "
  CHECK_RESULT $? 0 0 "Failed option: cdb -l -m"
  CHECK_RESULT $? 0 0 "Failed option: cdb -d -m"
```

- 涉及命令：cdb×8, tar×1
