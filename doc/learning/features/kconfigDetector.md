# kconfigDetector

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/kconfigDetector` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_kconfigDetector | Test kconfigDetector | pre_test/run_test/post_test | 17 | ✔ |  | 240m |

### 断言与命令明细

#### oe_test_kconfigDetector

- 描述：Test kconfigDetector
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "check_kconfig_dep -h failed"
  CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile01.x86_64 failed"
  CHECK_RESULT $? 0 0 "check_kconfig_dep output x86 failed"
  CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 failed"
  CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 [depends error] failed"
  CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 [range error] failed"
  CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 [lack config] failed"
  CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 [unmet dependences] failed"
  CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.x86_64 [restrict warning] failed"
  CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile01.aarch64 failed"
  CHECK_RESULT $? 0 0 "check_kconfig_dep output aarch64 failed"
  CHECK_RESULT $? 0 0 "check_kconfig_dep check testfile02.aarch64 failed"
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：check_kconfig_dep×5, mkdir×3
