# jpegoptim

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/jpegoptim` |
| 注册用例数 | 10 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_jpegoptim_01 | Test jpegoptim | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_jpegoptim_02 | package jpegoptim test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_jpegoptim_03 | package jpegoptim test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_jpegoptim_04 | package jpegoptim test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_jpegoptim_05 | package jpegoptim test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_jpegoptim_06 | package jpegoptim test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_jpegoptim_07 | package jpegoptim test | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_jpegoptim_08 | package jpegoptim test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_jpegoptim_09 | package jpegoptim test | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_jpegoptim_10 | package jpegoptim test | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_jpegoptim_01

- 描述：Test jpegoptim
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "jpegoptim use faild"
```

#### oe_test_jpegoptim_02

- 描述：package jpegoptim test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "jpegoptim use faild"
  CHECK_RESULT $? 0 0 "Failed to set maximum compression quality"
  CHECK_RESULT $? 0 0 "Jpegoptim lossless image beautification failed"
```

- 涉及命令：jpegoptim×1

#### oe_test_jpegoptim_03

- 描述：package jpegoptim test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "jpegoptim use faild"
  CHECK_RESULT $? 0 0 "Failed to optimize image file in place"
```

- 涉及命令：jpegoptim×1

#### oe_test_jpegoptim_04

- 描述：package jpegoptim test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "jpegoptim use faild"
  CHECK_RESULT $? 0 0 "Failed to optimize image file in place"
  CHECK_RESULT $? 0 0 "Recursive optimization of all image files in the directory failed"
```

- 涉及命令：jpegoptim×2

#### oe_test_jpegoptim_05

- 描述：package jpegoptim test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Mirror pull failed"
  CHECK_RESULT $? 0 0 "Container creation failed"
  CHECK_RESULT $? 0 0 "Container startup failed"
```

- 涉及命令：jpegoptim×3

#### oe_test_jpegoptim_06

- 描述：package jpegoptim test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Optimize graphic error reporting"
  CHECK_RESULT $? 0 0 "Jpegoptim - h execution failed"
  CHECK_RESULT $? 0 0 "View version error"
```

- 涉及命令：jpegoptim×3

#### oe_test_jpegoptim_07

- 描述：package jpegoptim test
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Optimize graphic error reporting"
  CHECK_RESULT $? 0 0 "View version error"
```

- 涉及命令：jpegoptim×2

#### oe_test_jpegoptim_08

- 描述：package jpegoptim test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Optimize graphic error reporting"
  CHECK_RESULT $? 0 0 "Jpegoptim - h execution failed"
  CHECK_RESULT $? 0 0 "View version error"
```

- 涉及命令：jpegoptim×3

#### oe_test_jpegoptim_09

- 描述：package jpegoptim test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Optimize graphic error reporting"
  CHECK_RESULT $? 0 0 "Jpegoptim - h execution failed"
  CHECK_RESULT $? 0 0 "View version error"
```

- 涉及命令：mkdir×1, jpegoptim×1

#### oe_test_jpegoptim_10

- 描述：package jpegoptim test
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "--csv execution failed"
  CHECK_RESULT $? 0 0 "--threshold execution failed"
  CHECK_RESULT $? 0 0 "--Quiet execution failed"
```
