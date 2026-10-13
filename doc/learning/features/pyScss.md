# pyScss

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pyScss` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_pyScss_01 | Test "pyScss" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pyScss_02 | Test "pyScss" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pyScss_03 | Test "pyScss" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pyScss_04 | Test "pyScss" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pyScss_05 | Test "pyScss" command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_python3-scss | File system common command python3-scss | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_pyScss_01

- 描述：Test "pyScss" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check less2scss -h failed"
  CHECK_RESULT $? 0 0 "Check less2scss --help failed"
  CHECK_RESULT $? 0 0 "Check less2scss -v failed"
  CHECK_RESULT $? 0 0 "Check less2scss --version failed"
  CHECK_RESULT $? 0 0 "Check less2scss [file] failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check less2scss [file] -f failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check less2scss [file] --force failed"
  CHECK_RESULT $? 0 0 "Check pyscss -h failed"
```

- 涉及命令：less2scss×2, pyscss×1

#### oe_test_pyScss_02

- 描述：Test "pyScss" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check pyscss --help failed"
  CHECK_RESULT $? 0 0 "Check pyscss [file] failed"
  CHECK_RESULT $? 0 0 "Check pyscss -i failed"
  CHECK_RESULT $? 0 0 "Check pyscss --interactive failed"
  CHECK_RESULT $? 0 0 "Check pyscss -r failed"
  CHECK_RESULT $? 0 0 "Check pyscss --recursive failed"
  CHECK_RESULT $? 0 0 "Check pyscss -o failed"
  CHECK_RESULT $? 0 0 "Check pyscss --output failed"
  CHECK_RESULT $? 0 0 "Check pyscss -s failed"
  CHECK_RESULT $? 0 0 "Check pyscss --suffix failed"
```

#### oe_test_pyScss_03

- 描述：Test "pyScss" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check pyscss --time failed"
  CHECK_RESULT $? 0 0 "Check pyscss --debug-info failed"
  CHECK_RESULT $? 0 0 "Check pyscss --no-debug-info failed"
  CHECK_RESULT $? 0 0 "Check pyscss -t failed"
  CHECK_RESULT $? 0 0 "Check pyscss --style failed"
  CHECK_RESULT $? 0 0 "Check pyscss -C failed"
  CHECK_RESULT $? 0 0 "Check pyscss --no-compress failed"
  CHECK_RESULT $? 0 0 "Check pyscss -v failed"
  CHECK_RESULT $? 0 0 "Check pyscss --version failed"
  CHECK_RESULT $? 0 0 "Check pyscss --sass failed"
```

- 涉及命令：pyscss×1

#### oe_test_pyScss_04

- 描述：Test "pyScss" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check pyscss -I failed"
  CHECK_RESULT $? 0 0 "Check pyscss --load-path failed"
  CHECK_RESULT $? 0 0 "Check pyscss -S failed"
  CHECK_RESULT $? 0 0 "Check pyscss --static-root failed"
  CHECK_RESULT $? 0 0 "Check pyscss -A failed"
  CHECK_RESULT $? 0 0 "Check pyscss --assets-root failed"
  CHECK_RESULT $? 0 0 "Check pyscss -A failed"
  CHECK_RESULT $? 0 0 "Check pyscss --assets-url failed"
  CHECK_RESULT $? 0 0 "Check pyscss -F failed"
  CHECK_RESULT $? 0 0 "Check pyscss --fonts-root failed"
```

#### oe_test_pyScss_05

- 描述：Test "pyScss" command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check pyscss -f failed"
  CHECK_RESULT $? 0 0 "Check pyscss --fonts-url failed"
  CHECK_RESULT $? 0 0 "Check pyscss --images-root failed"
  CHECK_RESULT $? 0 0 "Check pyscss --images-url failed"
  CHECK_RESULT $? 0 0 "Check pyscss --cache-root failed"
```

#### oe_test_python3-scss

- 描述：File system common command python3-scss
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "test python3-scss failure"
```
