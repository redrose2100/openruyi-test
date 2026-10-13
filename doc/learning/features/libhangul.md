# libhangul

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/libhangul/` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libhangul_hangul | TEST hangul | config_params/pre_test/run_test/post_test | 14 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libhangul_hangul

- 描述：TEST hangul
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "options: --help error"
  CHECK_RESULT $? 0 0 "options: --version error"
  CHECK_RESULT $? 0 0 "options: -l error"
  CHECK_RESULT $? 0 0 "options: --list error"
  CHECK_RESULT $? 0 0 "hangul STDIN error"
  CHECK_RESULT $? 0 0 "hangul FILEIN error"
  CHECK_RESULT $? 0 0 "options: -i error"
  CHECK_RESULT $? 0 0 "options: --input=STRING error"
  CHECK_RESULT $? 0 0 "options: -o error"
  CHECK_RESULT $? 0 0 "options: --output=FILE error"
  CHECK_RESULT $? 0 0 "options: -k error"
  CHECK_RESULT $? 0 0 "options: --keyboard error"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：hangul×5, grep×2, test×1
