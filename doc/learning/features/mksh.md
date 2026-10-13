# mksh

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/mksh` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_mksh | command test mksh | pre_test/run_test/post_test | 14 | ✔ |  |  |

### 断言与命令明细

#### oe_test_mksh

- 描述：command test mksh
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "log message: Failed to run command: mksh './test1.sh' | grep -v i"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: mksh -c 'echo \"Hello World\"' | grep \"Hello World\""
  CHECK_RESULT $? 0 0 "log message: Failed to run command: mksh -i './test1.sh' | grep i"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: mksh -l './test1.sh' | grep l"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: mksh -cp 'echo \"Hello World\"' | grep \"Hello World\""
  CHECK_RESULT $? 2 0 "log message: Failed to run command: mksh -r './test2.sh'"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: echo \"echo 'Hello World'\" | mksh -s"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: lksh './test1.sh' | grep -v i"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: lksh -c 'echo \"Hello World\"' | grep \"Hello World\""
  CHECK_RESULT $? 0 0 "log message: Failed to run command: lksh -i './test1.sh' | grep i"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: lksh -l './test1.sh' | grep l"
  CHECK_RESULT $? 0 0 "log message: Failed to run command: lksh -cp 'echo \"Hello World\"' | grep \"Hello World\""
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：mksh×5, lksh×5
