# embedded_tiny_image_test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/tiny_image_test` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_check_aarch_tiny_image_001 | check embedded tiny image | run_test | 2 |  |  |  |

### 断言与命令明细

#### oe_test_check_aarch_tiny_image_001

- 描述：check embedded tiny image
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "qemu-system-aarch64 not install please run '${OET_PATH}/dep_install.sh -e' first"
  CHECK_RESULT $? 0 0 "aarch64 tiny image test fail"
```
