# cgdcbxd

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/cgdcbxd` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_cgdcbxd | Test cgdcbxd.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_cgdcbxd_001 | continue using the utshell test command | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_cgdcbxd

- 描述：Test cgdcbxd.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_cgdcbxd_001

- 描述：continue using the utshell test command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "The help parameter is incorrectly displayed"
  CHECK_RESULT $? 0 0 "Service startup exception"
  CHECK_RESULT $? 0 0 "cgdcbxd process is not running"
```

- 涉及命令：cgdcbxd×1
