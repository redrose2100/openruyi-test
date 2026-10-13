# mm_uce

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/mm_uce` |
| 注册用例数 | 8 |
| 环境约束 | machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_mm_uce_copyfromuser | 内存UCE错误 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_mm_uce_getuser | 内存UCE错误 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_mm_uce_copyonwrite | 内存UCE错误 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_mm_uce_coredump_tmpfs | 内存UCE错误 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_mm_uce_coredump_ext4 | 内存UCE错误 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_mm_uce_coredump_pipefs | 内存UCE错误 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_mm_uce_copytouser | 内存UCE错误 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_mm_uce_putuser | 内存UCE错误 | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_mm_uce_copyfromuser

- 描述：内存UCE错误
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "mm_uce copy_from_user failed" 1
```

- 涉及命令：make×3, dmesg×1

#### oe_test_mm_uce_getuser

- 描述：内存UCE错误
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "mm_uce get_user failed" 1
```

- 涉及命令：make×3, dmesg×1

#### oe_test_mm_uce_copyonwrite

- 描述：内存UCE错误
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "mm_uce copy-on-write failed" 1
```

- 涉及命令：make×3, dmesg×1

#### oe_test_mm_uce_coredump_tmpfs

- 描述：内存UCE错误
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "mm_uce coredump tmpfs failed" 1
```

- 涉及命令：make×3, dmesg×1

#### oe_test_mm_uce_coredump_ext4

- 描述：内存UCE错误
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "mm_uce coredump ext4 failed" 1
```

- 涉及命令：make×3, dmesg×1

#### oe_test_mm_uce_coredump_pipefs

- 描述：内存UCE错误
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "mm_uce coredump pipefs failed" 1
```

- 涉及命令：make×3, dmesg×1

#### oe_test_mm_uce_copytouser

- 描述：内存UCE错误
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "mm_uce copy_to_user failed" 1
```

- 涉及命令：make×3, dmesg×1

#### oe_test_mm_uce_putuser

- 描述：内存UCE错误
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "mm_uce put_user failed" 1
```

- 涉及命令：make×3, dmesg×1
