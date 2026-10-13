# genders

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/genders` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_genders | Test genders | pre_test/run_test/post_test | 18 | ✔ |  |  |

### 断言与命令明细

#### oe_test_genders

- 描述：Test genders
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Check nodeattr failed"
  CHECK_RESULT $? 0 0 "Check nodeattr -f failed"
  CHECK_RESULT $? 0 0 "Check nodeattr -s failed"
  CHECK_RESULT $? 0 0 "Check nodeattr -n failed"
  CHECK_RESULT $? 0 0 "Check nodeattr -c failed"
  CHECK_RESULT $? 0 0 "Check nodeattr -q failed"
  CHECK_RESULT $? 0 0 "Check nodeattr -A failed"
  CHECK_RESULT $? 0 0 "Check nodeattr -X failed"
  CHECK_RESULT $? 0 0 "Check nodeattr -v failed"
  CHECK_RESULT $? 0 0 "Check nodeattr -Q failed"
  CHECK_RESULT $? 0 0 "Check nodeattr -l failed"
  CHECK_RESULT $? 0 0 "Check nodeattr -d failed"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：nodeattr×16, tar×1
