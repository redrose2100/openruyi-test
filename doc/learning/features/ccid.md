# ccid

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ccid` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ccid | Test ccid driver files, metadata, dependencies and interfaces | config_params/pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ccid

- 描述：Test ccid driver files, metadata, dependencies and interfaces
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "ccid package is not installed"
  CHECK_RESULT $? 0 0 "ccid package is missing required driver or configuration files"
  CHECK_RESULT $? 0 0 "ccid Info.plist is not valid XML"
  CHECK_RESULT $? 0 0 "ccid Info.plist does not reference libccid.so"
  CHECK_RESULT $? 0 0 "ccid Info.plist does not contain the expected product description"
  CHECK_RESULT $? 1 0 "ccid driver library has unresolved runtime dependencies"
  CHECK_RESULT $? 0 0 "libccid.so does not export IFDHCreateChannel"
  CHECK_RESULT $? 0 0 "libccid.so does not export IFDHTransmitToICC"
  CHECK_RESULT $? 0 0 "libccidtwin configuration does not reference the serial driver"
```

- 涉及命令：grep×3, rpm×1, test×1
