# zswap

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/zswap/` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_zswap01 | For testing kernel zswap feature, by detecting swap cache | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_zswap01

- 描述：For testing kernel zswap feature, by detecting swap cache
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 1 "no available swap." 1
  CHECK_RESULT $? "$expect" 0 "zswap not work as expected."
```
