# geos

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/geos` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_geos_commandAndbaseFun | Geos command line and basic function verification | pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_geos_commandAndbaseFun

- 描述：Geos command line and basic function verification
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "geos-config --prefix execution failed."
  CHECK_RESULT $? 0 0 "geos-config --version execution failed."
  CHECK_RESULT $? 0 0 "geos-config --libs execution failed."
  CHECK_RESULT $? 0 0 "geos-config --clibs execution failed."
  CHECK_RESULT $? 0 0 "geos-config --cclibs execution failed."
  CHECK_RESULT $? 0 0 "geos-config --static-clibs execution failed."
  CHECK_RESULT $? 0 0 "geos-config --static-cclibs execution failed."
  CHECK_RESULT $? 0 0 "geos-config --cflags execution failed."
  CHECK_RESULT $? 0 0 "geos-config --ldflags execution failed."
  CHECK_RESULT $? 0 0 "geos-config --includes execution failed."
  CHECK_RESULT $? 0 0 "geos-config base func execution failed."
  CHECK_RESULT $? 0 0 "geos-config --jtsport execution failed."
```
