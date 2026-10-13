# embedded_third_party_packages_extra_test

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 嵌入式域（embedded-test） |
| 套件路径 | `$OET_PATH/testcases/embedded-test/third_party_packages_extra_test` |
| 注册用例数 | 15 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libcgroup_test_001 | Test libcgroup | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_libseccomp_test_001 | Run libseccomp testsuite | config_params/pre_test/run_test | 2 |  |  | 120m |
| oe_test_python3_test_001 | Test python3 | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_lua_test_001 | Run luatestsuite | pre_test/run_test | 1 |  |  |  |
| oe_test_libtiff_test_001 | Run libtiff testsuite | run_test | 1 |  |  |  |
| oe_test_libpng_test_001 | Run libpng testsuite | run_test | 1 |  |  |  |
| oe_test_bash_test_001 | Run bash testsuite | run_test | 1 |  |  |  |
| oe_test_libunistring_test_001 | Run libunistring testsuite | run_test | 1 |  |  |  |
| oe_test_gdb_test_001 | Test gdb | run_test/post_test | 1 |  |  |  |
| oe_test_tar_test_001 | Run tar testsuite | run_test | 1 |  |  | 1440m |
| oe_test_libgcrypt_test_001 | Test libgcrypt | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_libgpg-error_test_001 | Run libgpg-error testsuite | run_test | 2 |  |  |  |
| oe_test_zstd_test_001 | test zstd | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_pyparsing_test_001 | test pyparsing | run_test | 1 |  |  |  |
| oe_test_pyflakes_test_001 | test pyflakes | run_test | 1 |  |  |  |

### 断言与命令明细

#### oe_test_libcgroup_test_001

- 描述：Test libcgroup
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "${failed_num}" 0 0 "libcgroup gtest failed!!!"
```

- 涉及命令：sed×1, grep×1

#### oe_test_libseccomp_test_001

- 描述：Run libseccomp testsuite
- 函数：`config_params, pre_test, run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "run libseccomp test arch-syscall-check fail"
  CHECK_RESULT 1 0 0 "run libseccomp $resultTitle fail"
```

- 涉及命令：sed×3, declare×1

#### oe_test_python3_test_001

- 描述：Test python3
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "exec python3 test failed!!!"
```

#### oe_test_lua_test_001

- 描述：Run luatestsuite
- 函数：`pre_test, run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run lua test fail"
```

- 涉及命令：sed×1, lua×1

#### oe_test_libtiff_test_001

- 描述：Run libtiff testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run findutils testcase $line fail"
```

- 涉及命令：declare×1, sed×1

#### oe_test_libpng_test_001

- 描述：Run libpng testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run findutils testcase $line fail"
```

- 涉及命令：sed×1

#### oe_test_bash_test_001

- 描述：Run bash testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run bash testcase $testName fail"
```

- 涉及命令：sed×2, declare×1

#### oe_test_libunistring_test_001

- 描述：Run libunistring testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT 1 0 0 "run findutils testcase $line fail"
```

- 涉及命令：declare×1

#### oe_test_gdb_test_001

- 描述：Test gdb
- 函数：`run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "${failed_num}" "${unexpect_failures}" 0 "unexpected failures ${failed_num}!"
```

- 涉及命令：sed×1

#### oe_test_tar_test_001

- 描述：Run tar testsuite
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run tar testcase $line fail"
```

- 涉及命令：sed×2, declare×1

#### oe_test_libgcrypt_test_001

- 描述：Test libgcrypt
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT "${failed}" 0 0 "grep test failed ${failed}!!!"
```

#### oe_test_libgpg-error_test_001

- 描述：Run libgpg-error testsuite
- 函数：`run_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "run libgpg-error failed!"
  CHECK_RESULT $? 0 0 "run libgpg-error $onetest failed!"
```

#### oe_test_zstd_test_001

- 描述：test zstd
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $test_stat 0 0 "run zstd test fail"
```

- 涉及命令：sed×1

#### oe_test_pyparsing_test_001

- 描述：test pyparsing
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run pyparsing test fail"
```

#### oe_test_pyflakes_test_001

- 描述：test pyflakes
- 函数：`run_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run pyflakes test fail"
```

- 涉及命令：sed×1, python3×1
