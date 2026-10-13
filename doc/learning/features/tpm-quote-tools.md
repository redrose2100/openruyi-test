# tpm-quote-tools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/tpm-quote-tools` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_tpm-quote-tools | verify the uasge of tpm_mkuuid,tpm_mkaik,tpm_loadkey,tpm_getpcrhash,tpm_updatepcrhash,tpm_getquote,tpm_verifyquote and tpm_unloadkey command | pre_test/run_test/post_test | 34 | ✔ |  |  |

### 断言与命令明细

#### oe_test_tpm-quote-tools

- 描述：verify the uasge of tpm_mkuuid,tpm_mkaik,tpm_loadkey,tpm_getpcrhash,tpm_updatepcrhash,tpm_getquote,tpm_verifyquote and tpm_unloadkey command
- 函数：`pre_test, run_test, post_test`
- 断言（34 条）：

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
  ... 共 34 条（其余见源脚本）
```

- 涉及命令：grep×11, sed×6, kill×3, pgrep×2, tpm_mkuuid×2, tpm_mkaik×2, tpm_loadkey×2, tpm_getpcrhash×2, tpm_updatepcrhash×2, tpm_getquote×2, tpm_verifyquote×2, tpm_unloadkey×2
