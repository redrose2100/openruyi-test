# zip

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/zip` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_zip_001 | Encrypt and decrypt zip | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_zip_002 | Encrypt and decrypt zip | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_zip_003 | Encrypt and decrypt zip | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_zip_004 | Encrypt and decrypt zip | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_zip_005 | Encrypt and decrypt zip | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_zip_006 | Encrypt and decrypt zip | pre_test/run_test/post_test | 7 |  |  |  |
| oe_test_zipsplit | test zipsplit | pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_zipsplit_01 | test zipsplit | pre_test/run_test/post_test | 6 |  |  |  |

### 断言与命令明细

#### oe_test_zip_001

- 描述：Encrypt and decrypt zip
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "zip is failed!"
  CHECK_RESULT $? 0 0 "testdatabak.zip is failed!"
  CHECK_RESULT $? 0 0 "unzip is failed!"
  CHECK_RESULT $? 0 0 "testfile is not found!"
```

- 涉及命令：test×2, zip×1, unzip×1

#### oe_test_zip_002

- 描述：Encrypt and decrypt zip
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "zip is failed!"
  CHECK_RESULT $? 0 0 "testdatabak.zip update is failed!"
  CHECK_RESULT $? 0 0 "zip test integrity is failed!"
  CHECK_RESULT $? 0 0 "zip encryption is failed!"
  CHECK_RESULT $? 0 0 "unzip decryption is failed!"
  CHECK_RESULT $? 0 0 "unzip extract file check is failed!"
  CHECK_RESULT $? 0 0 "zip verbose mode is failed!"
```

- 涉及命令：zip×4, test×2, unzip×1

#### oe_test_zip_003

- 描述：Encrypt and decrypt zip
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "zip is failed!"
  CHECK_RESULT $? 0 0 "testdatabak.zip is failed!"
  CHECK_RESULT $? 0 0 "unzip is failed!"
```

- 涉及命令：zip×3, test×1

#### oe_test_zip_004

- 描述：Encrypt and decrypt zip
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "zip is failed!"
  CHECK_RESULT $? 0 0 "test.zip is failed!"
  CHECK_RESULT $? 0 0 "unzip is failed!"
```

- 涉及命令：test×1, zip×1, unzip×1

#### oe_test_zip_005

- 描述：Encrypt and decrypt zip
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "zip is failed!"
  CHECK_RESULT $? 0 0 "test.zip is failed!"
  CHECK_RESULT $? 0 0 "zip -m is failed!"
  CHECK_RESULT $? 0 0 "zip -h2 failed!"
```

- 涉及命令：zip×3, test×1

#### oe_test_zip_006

- 描述：Encrypt and decrypt zip
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "zip -0 is failed!"
  CHECK_RESULT $? 0 0 "zip -1 is failed!"
  CHECK_RESULT $? 0 0 "zip -6 is failed!"
  CHECK_RESULT $? 0 0 "zip -9 failed!"
  CHECK_RESULT $? 0 0 "zip -9 compression capacity error"
  CHECK_RESULT $? 0 0 "zip -0 compression capacity error"
  CHECK_RESULT $? 0 0 "zip -1 compression capacity error"
```

- 涉及命令：zip×4, test×4

#### oe_test_zipsplit

- 描述：test zipsplit
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Splitting the test.zip file in quiet mode failed"
  CHECK_RESULT $? 0 0 "Failed to check file list size"
  CHECK_RESULT $? 0 0 "Import file from compressed file for execution failed"
  CHECK_RESULT $? 0 0 "test1.zip not found"
  CHECK_RESULT $? 0 0 "size_test1_zip capacity display error"
```

- 涉及命令：zipsplit×4, test×1

#### oe_test_zipsplit_01

- 描述：test zipsplit
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "zipsplit execution failure"
  CHECK_RESULT $? 0 0 "zipsplit -b execution failure"
  CHECK_RESULT $? 0 0 "zipsplit -r execution failure"
  CHECK_RESULT $? 0 0 "zipsplit version check failed"
  CHECK_RESULT $? 0 0 "Non-zip file test failed"
  CHECK_RESULT $? 0 0 "Minimal zip test failed"
```

- 涉及命令：test×3, zipsplit×3, zip×1
