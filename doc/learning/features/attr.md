# attr

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/attr` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_attr | command test attr | ver/pre_test/run_test/post_test | 14 | ✔ |  |  |

### 断言与命令明细

#### oe_test_attr

- 描述：command test attr
- 函数：`ver, pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "add attr failed"
  CHECK_RESULT $? 0 0 "get attr failed"
  CHECK_RESULT $? 0 0 "list attr failed"
  CHECK_RESULT $? 0 0 "remove attr failed"
  CHECK_RESULT $? 0 0 "add attr by link failed"
  CHECK_RESULT $? 0 0 "add attr by root failed"
  CHECK_RESULT $? 0 0 "add attr by securty failed"
  CHECK_RESULT $? 0 0 "set attr failed"
  CHECK_RESULT $? 0 0 "get attr failed"
  CHECK_RESULT $? 0 0 "remove attr failed"
  CHECK_RESULT $? 0 0 "add persistent attr failed"
  CHECK_RESULT $? 0 0 "persistent attr not preserved"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：attr×12, setfattr×2, getfattr×1
