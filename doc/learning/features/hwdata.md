# hwdata

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/hwdata` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_hwdata | Test hwdata package installation completeness and hardware ID query | pre_test/run_test/post_test | 21 | ✔ |  |  |

### 断言与命令明细

#### oe_test_hwdata

- 描述：Test hwdata package installation completeness and hardware ID query
- 函数：`pre_test, run_test, post_test`
- 断言（21 条）：

```
  CHECK_RESULT $? 0 0 "hwdata package not installed"
  CHECK_RESULT $? 0 0 "hwdata version invalid"
  CHECK_RESULT $? 0 0 "hwdata release not found"
  CHECK_RESULT $? 0 0 "hwdata architecture not found"
  CHECK_RESULT $? 0 0 "hwdata license not found"
  CHECK_RESULT $? 0 0 "hwdata summary not found or invalid"
  CHECK_RESULT $? 0 0 "pci.ids file not found"
  CHECK_RESULT $? 0 0 "usb.ids file not found"
  CHECK_RESULT $? 0 0 "pnp.ids file not found"
  CHECK_RESULT $? 0 0 "iab.txt file not found"
  CHECK_RESULT $? 0 0 "oui.txt file not found"
  CHECK_RESULT $? 0 0 "dist-blacklist.conf file not found"
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：rpm×2
