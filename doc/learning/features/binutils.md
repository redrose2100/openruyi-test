# binutils

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/binutils` |
| 注册用例数 | 10 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_binutils_objcopy | test binutils-objcopy | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_binutils_size | test binutils-size | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_binutils_strip | test binutils-strip | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_binutils_addr2line | test binutils-addr2line | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_binutils_ar | File system common command test-binutils--ar | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_binutils_nm | File system common command test-binutils--nm | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_binutils_objdump | test binutils-objdump | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_binutils_readelf | test binutils-readelf | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_binutils_dwp | Test chcpu basic functionality | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_binutils_ranlib | Test case for ranlib command | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_binutils_objcopy

- 描述：test binutils-objcopy
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT 0 0 0 "Compilation failure"
  CHECK_RESULT 1 0 1 "Compilation failure"
  CHECK_RESULT $? 0 0 "command failure"
  CHECK_RESULT $? 0 0 "command failure"
```

- 涉及命令：objcopy×1

#### oe_test_binutils_size

- 描述：test binutils-size
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT 0 0 0 "Compilation failure"
  CHECK_RESULT 1 0 1 "Compilation failure"
  CHECK_RESULT $? 0 0 "command2 failure"
```

#### oe_test_binutils_strip

- 描述：test binutils-strip
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT 0 0 0 "Compilation failure"
  CHECK_RESULT 1 0 1 "Compilation failure"
  CHECK_RESULT "$size1" "$size2" 1 "strip failture"
```

#### oe_test_binutils_addr2line

- 描述：test binutils-addr2line
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "addr2line not exist"
  CHECK_RESULT 0 0 0 "Compilation failure"
  CHECK_RESULT 0 0 1 "Compilation failure"
  CHECK_RESULT $? 0 0 "divide failure"
```

- 涉及命令：addr2line×1

#### oe_test_binutils_ar

- 描述：File system common command test-binutils--ar
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Compilation failure"
  CHECK_RESULT $out $file 0 "File generation failure"
  CHECK_RESULT $? 0 0 "Generation failure"
  CHECK_RESULT $? 0 0 "File does not exist"
```

- 涉及命令：gcc×1, grep×1, test×1

#### oe_test_binutils_nm

- 描述：File system common command test-binutils--nm
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT 0 0 0 "Compile failure"
  CHECK_RESULT 1 0 1 "Compile failure"
  CHECK_RESULT $? 0 0 "file is failed"
  CHECK_RESULT $? 0 0 "content is error"
```

- 涉及命令：test×1, grep×1

#### oe_test_binutils_objdump

- 描述：test binutils-objdump
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT 0 0 0 "Compilation failure"
  CHECK_RESULT 1 0 1 "Compilation failure"
  CHECK_RESULT $? 0 0 "file is failed"
  CHECK_RESULT $? 0 0 "command failure"
```

- 涉及命令：test×1, objdump×1

#### oe_test_binutils_readelf

- 描述：test binutils-readelf
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "$file file not found"
  CHECK_RESULT $? 0 0 "$file file view failed"
```

- 涉及命令：gcc×1, test×1, readelf×1

#### oe_test_binutils_dwp

- 描述：Test chcpu basic functionality
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "unable to generate main.dwo" 1
  CHECK_RESULT $? 0 0 "dwp -o main.dwp main.o failed" 1
  CHECK_RESULT $? 0 0 "package failed doesn't generated"
```

- 涉及命令：test×2, gcc×1, dwp×1

#### oe_test_binutils_ranlib

- 描述：Test case for ranlib command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "ranlib --help failed"
  CHECK_RESULT $? 0 0 "ranlib basic run failed"
  CHECK_RESULT $? 0 0 "ranlib did not create symbol index"
  CHECK_RESULT $? 0 0 "ranlib -D failed"
  CHECK_RESULT $? 0 0 "ranlib -U failed"
  CHECK_RESULT $? 0 0 "ranlib -t failed"
```

- 涉及命令：ranlib×3, gcc×1
