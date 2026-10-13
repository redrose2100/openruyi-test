# gsl

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/gsl` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gsl_histogram_01 | Test gsl-histogram | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_gsl_randlist_01 | Test gsl-randlist | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_gsl_randlist_02 | Test gsl-randlist | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_gsl_randlist_03 | Test gsl-randlist | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_gsl_randlist_04 | Test gsl-randlist | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gsl_histogram_01

- 描述：Test gsl-histogram
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: gsl-histogram -u "
```

#### oe_test_gsl_randlist_01

- 描述：Test gsl-randlist
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: gsl-randist"
  CHECK_RESULT $? 0 0 "Failed option: beta "
  CHECK_RESULT $? 0 0 "Failed option: binomial "
  CHECK_RESULT $? 0 0 "Failed option: bivariate-gaussian "
  CHECK_RESULT $? 0 0 "Failed option: cauchy "
  CHECK_RESULT $? 0 0 "Failed option: chisq "
  CHECK_RESULT $? 0 0 "Failed option: dir-2d "
  CHECK_RESULT $? 0 0 "Failed option: dir-3d "
  CHECK_RESULT $? 0 0 "Failed option: dir-nd "
  CHECK_RESULT $? 0 0 "Failed option: erlang "
```

#### oe_test_gsl_randlist_02

- 描述：Test gsl-randlist
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: exponential "
  CHECK_RESULT $? 0 0 "Failed option: exppow "
  CHECK_RESULT $? 0 0 "Failed option: fdist "
  CHECK_RESULT $? 0 0 "Failed option: flat "
  CHECK_RESULT $? 0 0 "Failed option: gamma "
  CHECK_RESULT $? 0 0 "Failed option: gaussian-tail "
  CHECK_RESULT $? 0 0 "Failed option: gaussian "
  CHECK_RESULT $? 0 0 "Failed option: geometric "
  CHECK_RESULT $? 0 0 "Failed option: gumbel1 "
  CHECK_RESULT $? 0 0 "Failed option: gumbel2 "
```

#### oe_test_gsl_randlist_03

- 描述：Test gsl-randlist
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: hypergeometric "
  CHECK_RESULT $? 0 0 "Failed option: laplace "
  CHECK_RESULT $? 0 0 "Failed option: landau "
  CHECK_RESULT $? 0 0 "Failed option: levy "
  CHECK_RESULT $? 0 0 "Failed option: levy-skew "
  CHECK_RESULT $? 0 0 "Failed option: logarithmic "
  CHECK_RESULT $? 0 0 "Failed option: logistic "
  CHECK_RESULT $? 0 0 "Failed option: lognormal "
  CHECK_RESULT $? 0 0 "Failed option: negative-binomial "
  CHECK_RESULT $? 0 0 "Failed option: pareto "
```

- 涉及命令：gsl-randist×1

#### oe_test_gsl_randlist_04

- 描述：Test gsl-randlist
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Failed option: pascal "
  CHECK_RESULT $? 0 0 "Failed option: poisson "
  CHECK_RESULT $? 0 0 "Failed option: rayleigh-tail "
  CHECK_RESULT $? 0 0 "Failed option: rayleigh "
  CHECK_RESULT $? 0 0 "Failed option: tdist "
  CHECK_RESULT $? 0 0 "Failed option: ugaussian-tail "
  CHECK_RESULT $? 0 0 "Failed option: ugaussian "
  CHECK_RESULT $? 0 0 "Failed option: weibull "
```
