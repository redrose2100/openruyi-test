# tboot_1.10.2-3

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/tboot` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_tboot_1.10.2-3_lcp2_crtpol | verify the uasge of tboot command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_tboot_1.10.2-3_lcp2_crtpollist | verify the uasge of tboot command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_tboot_1.10.2-3_lcp2_mlehash | verify the uasge of tboot command | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_tboot_1.10.2-3_lcp2_crtpol

- 描述：verify the uasge of tboot command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check lcp2_crtpol --help  failed"
  CHECK_RESULT $? 0 0 "Check lcp2_crtpol --version failed"
```

- 涉及命令：grep×1

#### oe_test_tboot_1.10.2-3_lcp2_crtpollist

- 描述：verify the uasge of tboot command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --create --listver --out failed"
  CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --create ==listver --sigalg --out failed"
  CHECK_RESULT $? 0 0 "Check lcp2_crtpollist -sign --sigalg --pub --priv --out failed"
  CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --addsig --sig --out failed"
  CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --show  failed"
  CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --version  failed"
  CHECK_RESULT $? 0 0 "Check lcp2_crtpollist --help  failed"
```

- 涉及命令：grep×1

#### oe_test_tboot_1.10.2-3_lcp2_mlehash

- 描述：verify the uasge of tboot command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check lcp2_mlehash -create --cmdline --alg --verbose failed"
  CHECK_RESULT $? 0 0 "Check lcp2_mlehash --help failed"
  CHECK_RESULT $? 0 0 "Check lcp2_mlehash --version failed"
```

- 涉及命令：grep×1
