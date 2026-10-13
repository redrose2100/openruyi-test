# python-wheel

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/python-wheel` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_python-wheel_python3-wheel_command | python3-wheel command parameter automation use case | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_python3-wheel_01 | test python-wheel | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_python-wheel_python3-wheel_command

- 描述：python3-wheel command parameter automation use case
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "wheel-3 -h execution failed."
  CHECK_RESULT $? 0 0 "wheel-3 --help execution failed."
  CHECK_RESULT $? 0 0 "wheel-3 help execution failed."
  CHECK_RESULT $? 0 0 "wheel-3 version execution failed."
```

- 涉及命令：mkdir×1, wheel-3×1

#### oe_test_python3-wheel_01

- 描述：test python-wheel
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "command success"
  CHECK_RESULT $? 0 0 "Mypackage-0.1-py3-none-any.whl not exist"
```

- 涉及命令：test×1
