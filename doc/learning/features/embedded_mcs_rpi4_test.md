# embedded_mcs_rpi4_test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/mcs_qemu_test` |
| 注册用例数 | 1 |
| 环境约束 | machine num = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_mcs_rpi4_test_001 | check rpi4 mcs | pre_test/run_test/post_test | 1 |  |  |  |

### 断言与命令明细

#### oe_mcs_rpi4_test_001

- 描述：check rpi4 mcs
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "$?" 0 0 "mcs test failed"
```

- 涉及命令：screen×2, rpmsg_main×1, grep×1
