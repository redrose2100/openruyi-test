# smoke-libcap

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `$OET_PATH/testcases/smoke-test/smoke-libcap` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libcap_FUN.001 | command test | pre_test/run_test/post_test | 22 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libcap_FUN.001

- 描述：command test
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "Check capsh --help failed"
  CHECK_RESULT $? 0 0 "Check capsh --print failed"
  CHECK_RESULT $? 0 0 "Check capsh --decode failed"
  CHECK_RESULT $? 0 0 "Check capsh --decode failed"
  CHECK_RESULT $? 0 0 "Check capsh --caps failed"
  CHECK_RESULT $? 0 0 "Check capsh --inh failed"
  CHECK_RESULT $? 0 0 "Check capsh --secbits failed"
  CHECK_RESULT $? 0 0 "Check capsh --keep failed"
  CHECK_RESULT $? 0 0 "Check capsh --uid failed"
  CHECK_RESULT $? 0 0 "Check capsh --gid failed"
  CHECK_RESULT $? 0 0 "Check capsh --groups failed"
  CHECK_RESULT $? 0 0 "Check user and grep uid failed"
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：getcap×3, setcap×3, useradd×1, userdel×1
