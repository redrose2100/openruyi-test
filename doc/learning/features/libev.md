# libev

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libev` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libev | Verify libev package installation and key files check | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_libev_watcher | Test libev core watcher functionality (timer, io, signal) | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libev

- 描述：Verify libev package installation and key files check
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "libev package is not installed"
  CHECK_RESULT $? 0 0 "libev-devel package is not installed"
  CHECK_RESULT $? 0 0 "ev.h header file does not exist"
  CHECK_RESULT $? 0 0 "ev++.h header file does not exist"
  CHECK_RESULT $? 0 0 "libev.so development symlink does not exist"
  CHECK_RESULT $? 0 0 "libev runtime library does not exist"
  CHECK_RESULT $? 0 0 "rpm query does not list ev.h in libev-devel"
  CHECK_RESULT $? 0 0 "rpm query does not list libev.so in libev"
  CHECK_RESULT $? 0 0 "libev linked program failed to run"
```

- 涉及命令：rpm×5, test×3, mkdir×1

#### oe_test_libev_watcher

- 描述：Test libev core watcher functionality (timer, io, signal)
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "timer watcher did not fire"
  CHECK_RESULT $? 0 0 "timer watcher loop did not end normally"
  CHECK_RESULT $? 0 0 "io watcher did not read the expected data"
  CHECK_RESULT $? 0 0 "io watcher loop did not end normally"
  CHECK_RESULT $? 0 0 "signal watcher did not catch SIGUSR1"
  CHECK_RESULT $? 0 0 "signal watcher loop did not end normally"
```

- 涉及命令：mkdir×1
