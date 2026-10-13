# ubackup

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/ubackup` |
| 注册用例数 | 1 |
| 环境约束 | add disk = 10 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ubackup_01 | ubackup data system 备份还原测试 | pre_test/run_test/post_test | 22 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ubackup_01

- 描述：ubackup data system 备份还原测试
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：mkdir×2, mkfs.ext4×1, test×1
