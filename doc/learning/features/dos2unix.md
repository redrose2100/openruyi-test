# dos2unix

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/dos2unix` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_dos2unix | command test-dos2unix test-unix2dos test-mac2unix test-unix2mac | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_dos2unix_basic_param | dos2unix -q -v -h -V | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_dos2unix_file_info | Test dos2unix -i -u -m file info parameters | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_dos2unix_newfile_keepdate | Test dos2unix -n -k parameter function | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_dos2unix_recursive | Test dos2unix -R -o -c recursive and mode related parameters | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_dos2unix

- 描述：command test-dos2unix test-unix2dos test-mac2unix test-unix2mac
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "The original file format is not unix"
  CHECK_RESULT $? 0 0 "unix2dos cmd exec failed"
  CHECK_RESULT $? 0 0 "unix2dos result error, please check..."
  CHECK_RESULT $? 0 0 "dos2unix cmd exec failed"
  CHECK_RESULT $? 0 0 "dos2unix result error, please check..."
  CHECK_RESULT $? 0 0 "unix2mac cmd exec failed"
  CHECK_RESULT $? 0 0 "unix2mac result error, please check..."
  CHECK_RESULT $? 0 0 "mac2unix cmd exec failed"
  CHECK_RESULT $? 0 0 "mac2unix result error, please check..."
```

#### oe_test_dos2unix_basic_param

- 描述：dos2unix -q -v -h -V
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "dos2unix -q execute failed"
  CHECK_RESULT $? 0 0 "dos2unix -q output not empty, quiet mode abnormal"
  CHECK_RESULT $? 0 0 "dos2unix -v execute failed"
  CHECK_RESULT $? 0 0 "dos2unix -v output empty, verbose mode abnormal"
  CHECK_RESULT $? 0 0 "dos2unix -h execute failed"
  CHECK_RESULT $? 0 0 "dos2unix -h output empty, help info abnormal"
  CHECK_RESULT $? 0 0 "dos2unix -V execute failed"
  CHECK_RESULT $? 0 0 "dos2unix -V output empty, version info abnormal"
```

- 涉及命令：dos2unix×4, test×3

#### oe_test_dos2unix_file_info

- 描述：Test dos2unix -i -u -m file info parameters
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "dos2unix -i execute failed"
  CHECK_RESULT $? 0 0 "dos2unix -i output empty"
  CHECK_RESULT $? 0 0 "dos2unix -u execute failed"
  CHECK_RESULT $? 0 0 "test file missing after -u convert"
  CHECK_RESULT $? 0 0 "dos2unix -m execute failed"
  CHECK_RESULT $? 0 0 "dos2unix -m output empty"
```

- 涉及命令：dos2unix×3, test×2

#### oe_test_dos2unix_newfile_keepdate

- 描述：Test dos2unix -n -k parameter function
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "dos2unix -n execute failed"
  CHECK_RESULT $? 0 0 "dos2unix -n new file not generated"
  CHECK_RESULT $? 0 0 "dos2unix -k execute failed"
  CHECK_RESULT $? 0 0 "dos2unix -k timestamp changed abnormally"
```

- 涉及命令：dos2unix×2, test×1

#### oe_test_dos2unix_recursive

- 描述：Test dos2unix -R -o -c recursive and mode related parameters
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "dos2unix -R execute failed"
  CHECK_RESULT $? 0 0 "file missing after recursive -R operation"
  CHECK_RESULT $? 0 0 "dos2unix -o execute failed"
  CHECK_RESULT $? 0 0 "dos2unix -o output empty"
  CHECK_RESULT $? 0 0 "dos2unix -c execute failed"
  CHECK_RESULT $? 0 0 "dos2unix -c output empty"
```

- 涉及命令：dos2unix×3, test×2, mkdir×1
