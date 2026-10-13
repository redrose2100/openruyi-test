# fapolicyd

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fapolicyd` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fapolicyd-service | Start fapolicydb servive | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_fapolicyd-bugfix | fapolicyd  test bug fix | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_fapolicyd-service

- 描述：Start fapolicydb servive
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT "$(systemctl status fapolicyd |grep Active |awk '{print $2}')" "inactive" 0 "fapolicyd default status"
  CHECK_RESULT "$(systemctl is-enabled fapolicyd)" "disabled" 0 "fapolicyd default self-start status"
  CHECK_RESULT $? 0 0 "start fapolicyd"
  CHECK_RESULT "$(systemctl status fapolicyd |grep Active |awk '{print $2}')" "active" 0 "fapolicyd status after start"
  CHECK_RESULT "$(systemctl is-enabled fapolicyd)" "enabled" 0 "fapolicyd self-start status after enable"
  CHECK_RESULT $? 0 0 "stop fapolicyd"
  CHECK_RESULT "$(systemctl status fapolicyd |grep Active |awk '{print $2}')" "inactive" 0 "fapolicyd status after stop"
```

#### oe_test_fapolicyd-bugfix

- 描述：fapolicyd  test bug fix
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "start fapolicyd"
  CHECK_RESULT "$(systemctl status fapolicyd | grep Active | awk '{print $2}')" "active" 0 "fapolicyd status after start"
  CHECK_RESULT "$(systemctl is-enabled fapolicyd)" "enabled" 0 "fapolicyd self-start status after enable"
  CHECK_RESULT $? 0 0 "Failed to copy the ls file"
```

- 涉及命令：userdel×1
