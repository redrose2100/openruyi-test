# fftw

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fftw` |
| 注册用例数 | 10 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fftw_fftw-wisdom-to-conf | Test wisdom-to-conf | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_fftw_fftw-wisdom_01 | Test fftw-wisdom | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_fftw_fftw-wisdom_02 | Test fftw-wisdom | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_fftw_fftw-wisdom_03 | Test fftw-wisdom | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_fftw_fftwf-wisdom_01 | Test fftwf-wisdom | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_fftw_fftwf-wisdom_02 | Test fftwf-wisdom | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_fftw_fftwf-wisdom_03 | Test fftwf-wisdom | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_fftw_fftwl-wisdom_01 | Test fftwl-wisdom | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_fftw_fftwl-wisdom_02 | Test fftwl-wisdom | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_fftw_fftwl-wisdom_03 | Test fftwl-wisdom | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_fftw_fftw-wisdom-to-conf

- 描述：Test wisdom-to-conf
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check fftw-wisdom-to-conf -h failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom-to-conf --help failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom-to-conf -V failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom-to-conf --version failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom-to-conf output failed."
```

- 涉及命令：fftw-wisdom-to-conf×2, mkdir×1

#### oe_test_fftw_fftw-wisdom_01

- 描述：Test fftw-wisdom
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -h failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom --help failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -V failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom --version failed."
  CHECK_RESULT $? 0 0 "fftw-wisdom output failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -v failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom --verbose failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -c failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom --canonical failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -t failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom --time-limit=<h> failed."
```

- 涉及命令：fftw-wisdom×7

#### oe_test_fftw_fftw-wisdom_02

- 描述：Test fftw-wisdom
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -o failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom --output-file=FILE failed."
  CHECK_RESULT $? 1 0 "Check fftw-wisdom -n failed."
  CHECK_RESULT $? 1 0 "Check fftw-wisdom --no-system-wisdom failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -w failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -w STDIN failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom --wisdom-file failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -T failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom --threads=N failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -m failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom --measure failed."
```

- 涉及命令：fftw-wisdom×6

#### oe_test_fftw_fftw-wisdom_03

- 描述：Test fftw-wisdom
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -e failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom --estimate failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom -e failed."
  CHECK_RESULT $? 0 0 "Check fftw-wisdom --exhaustive failed."
```

- 涉及命令：fftw-wisdom×2

#### oe_test_fftw_fftwf-wisdom_01

- 描述：Test fftwf-wisdom
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -h failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom --help failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -V failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom --version failed."
  CHECK_RESULT $? 0 0 "fftwf-wisdom output failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -v failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom --verbose failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -c failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom --canonical failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -t failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom --time-limit=<h> failed."
```

- 涉及命令：fftwf-wisdom×7

#### oe_test_fftw_fftwf-wisdom_02

- 描述：Test fftwf-wisdom
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -o failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom --output-file=FILE failed."
  CHECK_RESULT $? 1 0 "Check fftwf-wisdom -n failed."
  CHECK_RESULT $? 1 0 "Check fftwf-wisdom --no-system-wisdom failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -w failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -w STDIN failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom --wisdom-file failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -T failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom --threads=N failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -m failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom --measure failed."
```

- 涉及命令：fftwf-wisdom×6

#### oe_test_fftw_fftwf-wisdom_03

- 描述：Test fftwf-wisdom
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -e failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom --estimate failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom -e failed."
  CHECK_RESULT $? 0 0 "Check fftwf-wisdom --exhaustive failed."
```

- 涉及命令：fftwf-wisdom×2

#### oe_test_fftw_fftwl-wisdom_01

- 描述：Test fftwl-wisdom
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -h failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom --help failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -V failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom --version failed."
  CHECK_RESULT $? 0 0 "fftwl_wisdom output failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -v failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom --verbose failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -c failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom --canonical failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -t failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom --time-limit=<h> failed."
```

- 涉及命令：fftwl-wisdom×7

#### oe_test_fftw_fftwl-wisdom_02

- 描述：Test fftwl-wisdom
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -o failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom --output-file=FILE failed."
  CHECK_RESULT $? 1 0 "Check fftwl-wisdom -n failed."
  CHECK_RESULT $? 1 0 "Check fftwl-wisdom --no-system-wisdom failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -w failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -w STDIN failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom --wisdom-file failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -T failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom --threads=N failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -m failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom --measure failed."
```

- 涉及命令：fftwl-wisdom×6

#### oe_test_fftw_fftwl-wisdom_03

- 描述：Test fftwl-wisdom
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -e failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom --estimate failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom -e failed."
  CHECK_RESULT $? 0 0 "Check fftwl-wisdom --exhaustive failed."
```

- 涉及命令：fftwl-wisdom×2
