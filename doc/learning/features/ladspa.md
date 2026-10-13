# ladspa

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ladspa` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ladspa_analyseplugin | Test analyseplugin | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_ladspa_applyplugin | Test applyplugin and listplugins | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ladspa_analyseplugin

- 描述：Test analyseplugin
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "check -h failed"
  CHECK_RESULT $? 0 0 "check -l failed"
  CHECK_RESULT $? 0 0 "check plugin file failed"
  CHECK_RESULT $? 0 0 "check plugin label amp_mono failed"
  CHECK_RESULT $? 0 0 "check plugin label amp_stereo failed"
```

- 涉及命令：analyseplugin×2

#### oe_test_ladspa_applyplugin

- 描述：Test applyplugin and listplugins
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "applyplugin check failed"
  CHECK_RESULT $? 0 0 "applyplugin multiple parameters check failed"
  CHECK_RESULT $? 0 0 "applyplugin -s  check failed"
  CHECK_RESULT $? 0 0 "listplugins check failed"
```

- 涉及命令：applyplugin×1
