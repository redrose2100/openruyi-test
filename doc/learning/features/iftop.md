# iftop

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/iftop` |
| 注册用例数 | 3 |
| 环境约束 | machine num = 2；add network interface = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_iftop_text_mode | Test iftop text mode | pre_test/run_test/post_test | 19 | ✔ | ✔ | 60m |
| oe_test_iftop_gui | Test iftop GUI | pre_test/run_test/post_test | 29 | ✔ |  |  |
| oe_test_iftop_config | Test iftop config | pre_test/run_test/post_test | 19 | ✔ |  |  |

### 断言与命令明细

#### oe_test_iftop_text_mode

- 描述：Test iftop text mode
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: -h"
  CHECK_RESULT $? 0 0 "Failed to use option: -s and -t"
  CHECK_RESULT $? 0 1 "Failed to use option: -n"
  CHECK_RESULT $result 0 0 "Failed to use option: -P"
  CHECK_RESULT $result 0 0 "Failed to use option: -N"
  CHECK_RESULT $result 0 0 "Failed to use option: -p"
  CHECK_RESULT $result 0 0 "Failed to use option: -B"
  CHECK_RESULT $? 0 0 "Failed to use option: -i"
  CHECK_RESULT $result 0 0 "Failed to use option: -p"
  CHECK_RESULT $result 0 0 "Failed to use option: -B"
  CHECK_RESULT $? 0 0 "Failed to use option: -i"
  CHECK_RESULT $result 0 0 "Failed to use option: -f"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：pkill×12, ping×7, iftop×2

#### oe_test_iftop_gui

- 描述：Test iftop GUI
- 函数：`pre_test, run_test, post_test`
- 断言（29 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use option: -b"
  CHECK_RESULT $? 0 0 "Failed to use option: -F"
  CHECK_RESULT $? 0 0 "Failed to use option: -G"
  CHECK_RESULT $? 0 0 "Failed to use option: -l"
  CHECK_RESULT $? 0 0 "Failed to use GUI key: ?"
  CHECK_RESULT $? 0 0 "Failed to use option: -u"
  CHECK_RESULT $? 0 0 "Failed to use GUI key: h"
  CHECK_RESULT $? 0 0 "Failed to use GUI key: n"
  CHECK_RESULT $? 0 0 "Failed to use GUI key: s"
  CHECK_RESULT $? 0 0 "Failed to use GUI key: d"
  CHECK_RESULT $? 0 0 "Failed to use GUI key: t"
  CHECK_RESULT $? 0 0 "Failed to use GUI key: N"
  ... 共 29 条（其余见源脚本）
```

- 涉及命令：kill×3, iftop×2, pkill×2, ping×1

#### oe_test_iftop_config

- 描述：Test iftop config
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Failed to use config directive: interface"
  CHECK_RESULT $? 0 0 "Failed to use config directive: dns-resolution"
  CHECK_RESULT $result 0 0 "Failed to use config directive: port-resolution"
  CHECK_RESULT $result 0 0 "Failed to use config directive: filter-code"
  CHECK_RESULT $? 0 0 "Failed to use config directive: show-bars"
  CHECK_RESULT $result 0 0 "Failed to use config directive: promiscuous"
  CHECK_RESULT $result 0 0 "Failed to use config directive: port-display"
  CHECK_RESULT $? 0 0 "Failed to use config directive: link-local"
  CHECK_RESULT $? 0 0 "Failed to use config directive: hide-source"
  CHECK_RESULT $? 0 0 "Failed to use config directive: hide-destination"
  CHECK_RESULT $? 0 0 "Failed to use config directive: bandwidth-unit"
  CHECK_RESULT $? 0 0 "Failed to use config directive: use-bytes"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：iftop×10, pkill×7, ping×5, kill×1
