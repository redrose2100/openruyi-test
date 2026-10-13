# ninja-build

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ninja-build` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ninja-build_ninja | verify the uasge of ninja-build command | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ninja-build_ninja

- 描述：verify the uasge of ninja-build command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check ninja --help failed"
  CHECK_RESULT $? 0 0 "Check ninja -h failed"
  CHECK_RESULT $? 0 0 "Check ninja --version failed"
  CHECK_RESULT $? 0 0 "ninja -C -v failed"
  CHECK_RESULT $? 0 0 "ninja -f build.ninja -j -k -l failed"
  CHECK_RESULT $? 0 0 "Check ninja -n -f build.ninja failed"
  CHECK_RESULT $? 0 0 "Check ninja -d list failed"
  CHECK_RESULT $? 0 0 "Check ninja -t list failed"
  CHECK_RESULT $? 0 0 "Check ninja -w list failed"
```

- 涉及命令：ninja×7
