# ttmkfdir

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ttmkfdir` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ttmkfdir_base_01 | verify the uasge of ttmkfdir command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_ttmkfdir_base_02 | verify the uasge of ttmkfdir command | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ttmkfdir_base_01

- 描述：verify the uasge of ttmkfdir command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check ttmkfdir -e  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir -e  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir -o  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir --output  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir -d  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir --font-dir  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir -f  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir --default-foundry  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir -m  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir --max-missing  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir  -a failed"
```

- 涉及命令：ttmkfdir×6

#### oe_test_ttmkfdir_base_02

- 描述：verify the uasge of ttmkfdir command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check ttmkfdir --max-missing-percentage  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir -b  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir --additional-entries  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir  -x failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir  --additional-entries failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir -c  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir --completeness  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir -p  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir --panose  failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir  -h failed"
  CHECK_RESULT $? 0 0 "Check ttmkfdir  --help failed"
```

- 涉及命令：ttmkfdir×5
