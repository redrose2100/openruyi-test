# hdparm

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/hdparm` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_hdparm | test hdparm | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_hdparm

- 描述：test hdparm
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "hdparm -h fail"
  CHECK_RESULT $? 0 0 "hdparm -a system fail"
  CHECK_RESULT $? 0 0 "hdparm -c system fail"
  CHECK_RESULT $? 0 0 "hdparm -m system fail"
  CHECK_RESULT $? 0 0 "hdparm -V system fail"
  CHECK_RESULT $? 0 0 "hdparm -r system fail"
  CHECK_RESULT $? 0 0 "hdparm -I system fail"
```

- 涉及命令：hdparm×8
