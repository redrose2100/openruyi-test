# SDL

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/SDL` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libsdl1.2 | libsdl1.2 formatting test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_sdl-config | test  sdl-config | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libsdl1.2

- 描述：libsdl1.2 formatting test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Return value error"
  CHECK_RESULT $? 0 0 "compile test_sdl.c fail"
  CHECK_RESULT $? 0 0 "execute test_sdl fail"
```

- 涉及命令：rpm×1, test×1

#### oe_test_sdl-config

- 描述：test  sdl-config
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Display incorrect SDL version currently installed"
  CHECK_RESULT $? 0 0 "The compiler flags required for compiling SDL programs are incorrect"
  CHECK_RESULT $? 0 0 "The compiler flags required for compiling SDL programs are incorrect"
  CHECK_RESULT $? 0 0 "The compiler flags required for compiling SDL programs are incorrect"
  CHECK_RESULT $? 0 0 "SDL prefix path is invalid"
  CHECK_RESULT $? 0 0 "SDL exec-prefix path is invalid"
  CHECK_RESULT $? 0 0 "Help message missing"
```
