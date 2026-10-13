# psutils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/psutils` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_psselect | test psselect | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_psbook | test psbook | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_pstops | test pstops and includeres | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_epsffit | test epsffit and extractres | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_psnup_01 | test psnup | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_psnup_02 | test psnup | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_psjoin | test psjoin | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_psresize | test psresize | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_psselect

- 描述：test psselect
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "psselect -v execution failed."
  CHECK_RESULT $? 0 0 "psselect -o ./common/a4-11.ps execution failed."
  CHECK_RESULT $? 0 0 "psselect -e ./common/a4-11.ps execution failed."
  CHECK_RESULT $? 0 0 "psselect -p1 -p2 -p4 ./common/a4-11.ps execution failed."
  CHECK_RESULT $? 0 0 "psselect -r ./common/a4-2.ps execution failed."
  CHECK_RESULT $? 0 0 "psselect -r -q ./common/a4-11.ps execution failed."
```

- 涉及命令：psselect×5

#### oe_test_psbook

- 描述：test psbook
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "psbook -v execution failed."
  CHECK_RESULT $? 0 0 "psbook -s4 ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 1 "psbook -q -s8 ./common/a4-1.ps execution failed."
```

- 涉及命令：psbook×2

#### oe_test_pstops

- 描述：test pstops and includeres
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 1 "pstops '2:0L@.7(21cm,0)+1L@.7(21cm,14.85cm)' ./common/a4-11.ps execution failed."
  CHECK_RESULT $? 0 0 "pstops '2:-0' ./common/a4-11.ps execution failed."
  CHECK_RESULT $? 0 0 "pstops '4:-3L@.7(21cm,0)+0L@.7(21cm,14.85cm)' ./common/a4-11.ps execution failed."
  CHECK_RESULT $? 0 0 "includeres ./common/a4-1.ps execution failed."
```

- 涉及命令：pstops×3

#### oe_test_epsffit

- 描述：test epsffit and extractres
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "epsffit -v execution failed."
  CHECK_RESULT $? 0 0 "extractres -m ./common/a4-1.ps execution failed."
```

- 涉及命令：extractres×1

#### oe_test_psnup_01

- 描述：test psnup
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "psnup -v execution failed."
  CHECK_RESULT $? 0 0 "psnup -2 ./common/a4-1.ps  execution failed."
  CHECK_RESULT $? 0 0 "psnup -4 ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 1 "psnup -q ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 0 "psnup -l ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 0 "psnup -r ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 0 "psnup -f ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 0 "psnup -c ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 0 "psnup -m42 ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 0 "psnup -b20 ./common/a4-1.ps execution failed."
```

- 涉及命令：psnup×9

#### oe_test_psnup_02

- 描述：test psnup
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "psnup -d ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 0 "psnup -pA4 -Pletter ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 0 "psnup -w100 -h200 -W50 -H100 ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 1 0 "psselect -r -q ./common/a4-11.ps execution failed."
```

- 涉及命令：psnup×4

#### oe_test_psjoin

- 描述：test psjoin
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "psjoin -h execution failed."
  CHECK_RESULT $? 0 0 "psjoin -V execution failed."
  CHECK_RESULT $? 0 0 "psjoin ./common/a4-1.ps ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 0 "psjoin --strip execution failed."
  CHECK_RESULT $? 0 0 "psjoin --even ./common/a4-1.ps execution failed."
```

- 涉及命令：psjoin×1

#### oe_test_psresize

- 描述：test psresize
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "psresize -PA4 -pA5 ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 0 "psresize -W595 -H842 -w600 -h800 ./common/a4-1.ps execution failed."
  CHECK_RESULT $? 0 1 "psresize -PA4 -pA5 -q ./common/a4-1.ps execution failed."
```

- 涉及命令：psresize×3
