# fipscheck

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fipscheck` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fipscheck | Test fipscheck file integrity verification in FIPS and non-FIPS modes | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_fipshmac | Test fipshmac checksum generation options and error handling | pre_test/run_test/post_test | 18 | ✔ |  |  |

### 断言与命令明细

#### oe_test_fipscheck

- 描述：Test fipscheck file integrity verification in FIPS and non-FIPS modes
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

```
  CHECK_RESULT $? 0 0 "fipscheck package is not installed"
  CHECK_RESULT $? 0 0 "fipscheck package is missing required binaries or library"
  CHECK_RESULT $? 1 0 "fipscheck has unresolved runtime dependencies"
  CHECK_RESULT $? 0 0 "fipscheck package contains an invalid HMAC file"
  CHECK_RESULT $? 0 1 "fipscheck without arguments should fail"
  CHECK_RESULT $? 0 0 "fipscheck without arguments did not print usage"
  CHECK_RESULT $? 0 0 "fipshmac failed to prepare checksum files"
  CHECK_RESULT $? 0 0 "fipshmac did not create checksum files for verification"
  CHECK_RESULT $? 0 0 "fipshmac failed to prepare the custom checksum file"
  CHECK_RESULT $? 0 1 "fipscheck should fail when FIPS mode is unavailable"
  CHECK_RESULT $? 0 1 "fipscheck with a custom suffix should fail when FIPS mode is unavailable"
  CHECK_RESULT $? 0 1 "fipscheck with multiple files should fail when FIPS mode is unavailable"
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：grep×3, test×2, fipscheck×2, mkdir×1, rpm×1, fipshmac×1

#### oe_test_fipshmac

- 描述：Test fipshmac checksum generation options and error handling
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "fipscheck package is not installed"
  CHECK_RESULT $? 0 1 "fipshmac without arguments should fail"
  CHECK_RESULT $? 0 0 "fipshmac without arguments did not print usage"
  CHECK_RESULT $? 0 0 "fipshmac failed to create the default checksum file"
  CHECK_RESULT $? 0 0 "fipshmac did not create .file.hmac"
  CHECK_RESULT $? 0 0 "fipshmac created an invalid default checksum"
  CHECK_RESULT $? 0 0 "fipshmac failed to regenerate the checksum"
  CHECK_RESULT $? 0 0 "fipshmac checksum did not change after file modification"
  CHECK_RESULT $? 0 0 "fipshmac -d failed to create the checksum file"
  CHECK_RESULT $? 0 0 "fipshmac -d did not create file.hmac in the target directory"
  CHECK_RESULT $? 0 0 "fipshmac -d created an invalid checksum"
  CHECK_RESULT $? 0 0 "fipshmac -s failed to create the checksum file"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：grep×5, test×4, fipshmac×2, mkdir×1, rpm×1
