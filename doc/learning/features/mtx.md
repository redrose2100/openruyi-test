# mtx

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/mtx` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_mtx_loaderinfo | TEST loaderinfo | config_params/pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_mtx_tapeinfo | TEST tapeinfo | config_params/pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_mtx_mtx | TEST mtx | config_params/pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_mtx_scsieject | TEST scsieject | config_params/pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_mtx_scsitape | TEST scsitape | config_params/pre_test/run_test/post_test | 10 |  |  |  |

### 断言与命令明细

#### oe_test_mtx_loaderinfo

- 描述：TEST loaderinfo
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "option: -f error at ${device}"
```

- 涉及命令：loaderinfo×1

#### oe_test_mtx_tapeinfo

- 描述：TEST tapeinfo
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "option: -f error at ${device}"
```

- 涉及命令：tapeinfo×1

#### oe_test_mtx_mtx

- 描述：TEST mtx
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "option: --version error"
  CHECK_RESULT $? 0 0 "option: -f noattach error"
  CHECK_RESULT $? 0 0 "option: -f inquiry error"
  CHECK_RESULT $? 0 0 "option: -f inventory error"
  CHECK_RESULT $? 0 0 "option: -f status error"
  CHECK_RESULT $? 0 0 "option: -f first error"
  CHECK_RESULT $? 0 0 "option: -f last error"
  CHECK_RESULT $? 0 0 "option: -f previous error"
  CHECK_RESULT $? 0 0 "option: -f next error"
  CHECK_RESULT $? 0 0 "option: -f unload 40 0 error"
  CHECK_RESULT $? 0 0 "option: -f load 1 0 error"
  CHECK_RESULT $? 0 0 "option: -f transfer 40 41 error"
```

- 涉及命令：mtx×11

#### oe_test_mtx_scsieject

- 描述：TEST scsieject
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "option: -f load error"
  CHECK_RESULT $? 0 0 "option: -f start error"
  CHECK_RESULT $? 0 0 "option: -f lock error"
  CHECK_RESULT $? 0 0 "option: -f unlock error"
```

- 涉及命令：scsieject×4

#### oe_test_mtx_scsitape

- 描述：TEST scsitape
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "option: -f setblk error"
  CHECK_RESULT $? 0 0 "option: -f fsf error"
  CHECK_RESULT $? 0 0 "option: -f bsf error"
  CHECK_RESULT $? 0 0 "option: -f eod error"
  CHECK_RESULT $? 0 0 "option: -f rewind error"
  CHECK_RESULT $? 0 0 "option: -f mark error"
  CHECK_RESULT $? 0 0 "option: -f seek  error"
  CHECK_RESULT $? 0 0 "option: -f write  error"
  CHECK_RESULT $? 0 0 "option: -f read  error"
  CHECK_RESULT $? 0 0 "option: -f eject  error"
```

- 涉及命令：scsitape×9
