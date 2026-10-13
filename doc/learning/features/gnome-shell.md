# gnome-shell

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/gnome-shell` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gnome-shell | Take the test gnome-shell | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_gnome-shell_01 | Take the test gnome-shell | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gnome-shell

- 描述：Take the test gnome-shell
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check gnome-shell --list-mode failed."
  CHECK_RESULT $? 0 0 "Check gnome-shell --version failed."
  CHECK_RESULT $? 0 0 "Check gnome-shell -h failed."
  CHECK_RESULT $? 0 0 "Check gnome-shell --help-all failed."
  CHECK_RESULT $? 0 0 "Check gnome-shell-perf-tool --version failed."
  CHECK_RESULT $? 0 0 "Check gnome-shell-perf-tool -h failed."
  CHECK_RESULT $? 0 0 "Check gnome-shell-extension-tool -h failed."
```

- 涉及命令：gnome-shell×1, gnome-shell-perf-tool×1, gnome-shell-extension-tool×1

#### oe_test_gnome-shell_01

- 描述：Take the test gnome-shell
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check gnome-shell basic startup failed."
  CHECK_RESULT $? 0 0 "Check gnome-shell command existence failed."
  CHECK_RESULT $? 0 0 "Check gnome-shell modes count failed."
  CHECK_RESULT $? 0 0 "Check gnome-shell version output failed."
```

- 涉及命令：pkill×2, test×1
