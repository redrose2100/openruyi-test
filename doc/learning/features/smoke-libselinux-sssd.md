# smoke-libselinux-sssd

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `${OET_PATH}/testcases/smoke-test/smoke-basic-os` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libselinux | Command test-libselinux | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_sssd | Command test-sssd | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libselinux

- 描述：Command test-libselinux
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "check libselinux install"
  CHECK_RESULT $? 0 0 "check sefcontext_compile -o"
  CHECK_RESULT $? 0 0 "check sefcontext_compile -p"
  CHECK_RESULT $? 0 0 "check sefcontext_compile"
```

- 涉及命令：sefcontext_compile×2, test×2, rpm×1

#### oe_test_sssd

- 描述：Command test-sssd
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "check sssd-tools install"
  CHECK_RESULT $? 0 0 "check sssd service running"
  CHECK_RESULT "$i" 10 1 "check sssctl domain-list"
  CHECK_RESULT $? 0 0 "check sssctl domain-status"
  CHECK_RESULT $? 0 0 "check sssctl config-check"
  CHECK_RESULT $? 0 0 "check user add"
  CHECK_RESULT $? 0 0 "check sssctl logs-remove"
  CHECK_RESULT $? 0 0 "check sssctl logs-fetch"
```

- 涉及命令：rpm×1, sed×1, test×1, userdel×1
