# aqute-bnd

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/aqute-bnd` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_aqute_bnd_01 | Test aqute-bnd | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_aqute_bnd_02 | Test aqute-bnd | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_aqute_bnd_03 | Test aqute-bnd | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_aqute_bnd_04 | Test aqute-bnd | pre_test/run_test/post_test | 14 | ✔ |  |  |
| oe_test_aqute_bnd_05 | Test aqute-bnd | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_aqute_bnd_01

- 描述：Test aqute-bnd
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "check bnd action failed"
  CHECK_RESULT $? 0 0 "check bnd add failed"
  CHECK_RESULT $? 0 0 "check bnd baseline failed"
  CHECK_RESULT $? 0 0 "check bnd bash failed"
  CHECK_RESULT $? 0 0 "check bnd bnd failed"
  CHECK_RESULT $? 0 0 "check bnd plugin failed"
  CHECK_RESULT $? 0 0 "check bnd build failed"
  CHECK_RESULT $? 0 0 "check bnd buildx failed"
  CHECK_RESULT $? 0 0 "check bnd bump failed"
  CHECK_RESULT $? 0 0 "check bnd changes failed"
```

- 涉及命令：test×1

#### oe_test_aqute_bnd_02

- 描述：Test aqute-bnd
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "check bnd convert failed"
  CHECK_RESULT $? 0 0 "check bnd copy failed"
  CHECK_RESULT $? 0 0 "check bnd create failed"
  CHECK_RESULT $? 0 0 "check bnd debug failed"
  CHECK_RESULT $? 0 0 "check bnd defaults failed"
  CHECK_RESULT $? 0 0 "check bnd deliverables failed"
  CHECK_RESULT $? 0 0 "check bnd diff failed"
  CHECK_RESULT $? 0 0 "check bnd digest failed"
  CHECK_RESULT $? 0 0 "check bnd do failed"
  CHECK_RESULT $? 0 0 "check bnd eclipse failed"
  CHECK_RESULT $? 0 0 "check bnd ees failed"
```

- 涉及命令：test×3

#### oe_test_aqute_bnd_03

- 描述：Test aqute-bnd
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "check bnd enroute failed"
  CHECK_RESULT $? 0 0 "check bnd export failed"
  CHECK_RESULT $? 0 0 "check bnd extract failed"
  CHECK_RESULT $? 0 0 "check bnd flatten failed"
  CHECK_RESULT $? 0 0 "check bnd grep failed"
  CHECK_RESULT $? 0 0 "check bnd info failed"
  CHECK_RESULT $? 0 0 "check bnd junit failed"
  CHECK_RESULT $? 0 0 "check bnd macro failed"
  CHECK_RESULT $? 0 0 "check bnd maven failed"
```

- 涉及命令：test×2, mkdir×1

#### oe_test_aqute_bnd_04

- 描述：Test aqute-bnd
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "check bnd plugins failed"
  CHECK_RESULT $? 0 0 "check bnd print failed"
  CHECK_RESULT $? 0 0 "check bnd profile failed"
  CHECK_RESULT $? 0 0 "check bnd project failed"
  CHECK_RESULT $? 0 0 "check bnd remove failed"
  CHECK_RESULT $? 0 0 "check bnd repo failed"
  CHECK_RESULT $? 0 0 "check bnd schema failed"
  CHECK_RESULT $? 0 0 "check bnd select failed"
  CHECK_RESULT $? 0 0 "check bnd settings failed"
  CHECK_RESULT $? 0 0 "check bnd source failed"
  CHECK_RESULT $? 0 0 "check bnd syntax failed"
  CHECK_RESULT $? 0 0 "check bnd type failed"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：test×2

#### oe_test_aqute_bnd_05

- 描述：Test aqute-bnd
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "check bnd view failed"
  CHECK_RESULT $? 0 0 "check bnd wrap failed"
  CHECK_RESULT $? 0 0 "check bnd xref failed"
  CHECK_RESULT $? 0 0 "check bnd run failed"
  CHECK_RESULT $? 0 0 "check bnd runtests failed"
  CHECK_RESULT $? 0 0 "check bnd test failed"
  CHECK_RESULT $? 0 0 "check bnd bsn2url failed"
```

- 涉及命令：test×4
