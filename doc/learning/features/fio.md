# fio

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fio` |
| 注册用例数 | 4 |
| 环境约束 | add disk = 2,2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fio_001 | fio command test | pre_test/run_test/post_test | 10 | ✔ |  | 60m |
| oe_test_fio_002 | fio command test | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_fio_003 | fio command test | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_fio_004 | fio command test | pre_test/run_test/post_test | 10 | ✔ |  | 60m |

### 断言与命令明细

#### oe_test_fio_001

- 描述：fio command test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "fio-genzipf -t option failed"
  CHECK_RESULT $? 0 0 "Generating Zipf distribution option failed"
  CHECK_RESULT $? 0 0 "fio-genzipf -i zipf theta -o option failed"
  CHECK_RESULT $? 0 0 "fio-genzipf -i zipf theta -o 2 -c failed "
  CHECK_RESULT $? 0 0 "fio-genzipf -g option failed"
  CHECK_RESULT $? 0 0 "fio-genzipf -p option failed"
  CHECK_RESULT $? 0 0 "fio-genzipf -b option failed"
  CHECK_RESULT $? 0 0 " fio-verify-state option failed"
  CHECK_RESULT $? 0 0 "fio-dedupe option failed"
  CHECK_RESULT $? 0 0 "fio-dedupe option failed"
```

- 涉及命令：fio-genzipf×7, fio-dedupe×2, test×1

#### oe_test_fio_002

- 描述：fio command test
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "fio-dedupe -o option failed"
  CHECK_RESULT $? 0 0 "fio-dedupe -c option failed"
  CHECK_RESULT $? 0 0 "fio-dedupe -B option failed"
  CHECK_RESULT $? 0 0 "fio-dedupe -p option failed"
  CHECK_RESULT $? 0 0 "fio --filename=test_file option failed"
  CHECK_RESULT $? 0 0 "fio -filename=/dev option failed"
  CHECK_RESULT $? 0 0 "fio -filename=/dev option failed"
  CHECK_RESULT $? 0 0 "fio -filename=/dev option failed"
  CHECK_RESULT $? 0 0 "fio -filename=/dev option failed"
  CHECK_RESULT $? 0 0 "fio -filename=/dev option failed"
  CHECK_RESULT $? 0 0 "fio -filename=/dev option failed"
  CHECK_RESULT $? 0 0 "genfio -h option failed"
```

- 涉及命令：fio×5, fio-dedupe×4, test×3, genfio×2

#### oe_test_fio_003

- 描述：fio command test
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "check disk failed"
  CHECK_RESULT $? 0 0 "check disk failed"
  CHECK_RESULT $? 0 0 "check disk failed"
  CHECK_RESULT $? 0 0 "check disk failed"
  CHECK_RESULT $? 0 0 "fio --filename=test_file option failed"
  CHECK_RESULT $? 0 0 "fio --filename=test_file option failed"
  CHECK_RESULT $? 0 0 "fio --filename=test_file option failed"
  CHECK_RESULT $? 0 0 "fio --filename=test_file option failed"
  CHECK_RESULT $? 0 0 "fio --filename=test_file option failed"
  CHECK_RESULT $? 0 0 "fio --filename=test_file option failed"
  CHECK_RESULT $? 0 0 "fio --filename=test_file option failed"
```

- 涉及命令：fio×5, fio-dedupe×4, test×2, genfio×1

#### oe_test_fio_004

- 描述：fio command test
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "fio-genzipf -t option failed"
  CHECK_RESULT $? 0 0 "Generating Zipf distribution option failed"
  CHECK_RESULT $? 0 0 "fio-genzipf -i zipf theta -o option failed"
  CHECK_RESULT $? 0 0 "fio-genzipf -i zipf theta -o 2 -c failed "
  CHECK_RESULT $? 0 0 "fio-genzipf -g option failed"
  CHECK_RESULT $? 0 0 "fio-genzipf -p option failed"
  CHECK_RESULT $? 0 0 "fio-genzipf -b option failed"
  CHECK_RESULT $? 0 0 " fio-verify-state option failed"
  CHECK_RESULT $? 0 0 "fio-dedupe option failed"
  CHECK_RESULT $? 0 0 "fio-dedupe option failed"
```

- 涉及命令：fio-genzipf×7, fio-dedupe×2
