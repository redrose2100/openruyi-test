# libaec

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/libaec` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libaec_aec | TEST aec | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libaec_aec

- 描述：TEST aec
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "aec help error"
  CHECK_RESULT $? 0 0 "options: -n 01 -j 16 -r 16 error"
  CHECK_RESULT $? 0 0 "options: -n 01 -j 16 -r 16 -t error"
  CHECK_RESULT $? 0 0 "options: -d -n 32 -j 16 -r 256 -p error"
  CHECK_RESULT $? 0 0 "options: -N error"
  CHECK_RESULT $? 0 0 "options: -s error"
  CHECK_RESULT $? 0 0 "options: -3 error"
  CHECK_RESULT $? 0 0 "options: -m error"
  CHECK_RESULT $? 0 0 "options: -b 02 error"
```

- 涉及命令：test×9, aec×8
