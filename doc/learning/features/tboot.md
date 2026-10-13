# tboot

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
| oe_test_tboot_lcp2_crtpolelt | verify the uasge of tboot command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_tboot_tb_polgen | verify the uasge of tboot command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_tboot_txt-stat | verify the uasge of tboot command | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_tboot_lcp2_crtpolelt

- 描述：verify the uasge of tboot command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check lcp2_mlehash -create --type --minver --ctrl --out failed"
  CHECK_RESULT $? 0 0 "Check lcp2_mlehash -create --type --minver --out failed"
  CHECK_RESULT $? 0 0 "Check lcp2_mlehash -create --type custom --uuid --out failed"
  CHECK_RESULT $? 0 0 "Check lcp2_mlehash -create --type sbios --alg --out failed"
  CHECK_RESULT $? 0 0 "Check lcp2_mlehash -create --type stm --out failed"
  CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --show failed"
  CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --verbose failed"
  CHECK_RESULT $? 0 0 "Check lcp2_crtpolelt --help failed"
```

- 涉及命令：grep×1

#### oe_test_tboot_tb_polgen

- 描述：verify the uasge of tboot command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check tb_polgen --create --type --alg failed"
  CHECK_RESULT $? 0 0 "Check tb_polgen --create --type --alg failed"
  CHECK_RESULT $? 0 0 "Check tb_polgen --create --type --alg failed"
  CHECK_RESULT $? 0 0 "Check tb_polgen --create --type --alg failed"
  CHECK_RESULT $? 0 0 "Check tb_polgen --add --num --pcr --hash --cmdline --image failed"
  CHECK_RESULT $? 0 0 "Check tb_polgen --add --num --pcr --hash --image failed"
  CHECK_RESULT $? 0 0 "Check tb_polgen --add --num --pcr --hash --image --verbose failed"
  CHECK_RESULT $? 0 0 "Check tb_polgen --del --num failed"
  CHECK_RESULT $? 0 0 "Check tb_polgen --show failed"
  CHECK_RESULT $? 0 0 "Check tb_polgen --help failed"
```

- 涉及命令：grep×1

#### oe_test_tboot_txt-stat

- 描述：verify the uasge of tboot command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check txt-stat --heap failed"
  CHECK_RESULT $? 0 0 "Check txt-stat --help failed"
  CHECK_RESULT $? 0 0 "Check txt-stat -h failed"
```

- 涉及命令：grep×1, txt-stat×1
