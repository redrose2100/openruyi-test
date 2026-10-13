# hdf5

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/hdf5` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_hdf5_01 | Test hdf5 function | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_hdf5_02 | Test hdf5 function | pre_test/run_test/post_test | 11 | ✔ |  |  |

### 断言与命令明细

#### oe_test_hdf5_01

- 描述：Test hdf5 function
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Create hdf5_example.c file fail"
  CHECK_RESULT $? 0 0 "Compile fail"
  CHECK_RESULT $? 0 0 "Execute fail"
  CHECK_RESULT $? 0 0 "Create example.h5 file fail"
```

#### oe_test_hdf5_02

- 描述：Test hdf5 function
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Create hdf5_example.c file fail"
  CHECK_RESULT $? 0 0 "Compile hdf5_example fail"
  CHECK_RESULT $? 0 0 "Execute hdf5_example fail"
  CHECK_RESULT $? 0 0 "Create example.h5 file fail"
  CHECK_RESULT $? 0 0 "Create hdf5_read.c file fail"
  CHECK_RESULT $? 0 0 "Compile hdf5_read fail"
  CHECK_RESULT $? 0 0 "Read HDF5 file fail"
  CHECK_RESULT $? 0 0 "h5dump command not found"
  CHECK_RESULT $? 0 0 "h5dump execute fail"
  CHECK_RESULT $? 0 0 "h5ls command not found"
  CHECK_RESULT $? 0 0 "h5ls execute fail"
```

- 涉及命令：grep×1
