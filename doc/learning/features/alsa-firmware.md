# alsa-firmware

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/alsa-firmware` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_alsa_firmware_install | Test alsa-firmware package installation integrity | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_alsa_firmware_files | Test alsa-firmware file list and permissions | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_alsa_firmware_load | Test alsa-firmware load capability | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_alsa_firmware_install

- 描述：Test alsa-firmware package installation integrity
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "alsa-firmware package not installed"
  CHECK_RESULT $? 0 0 "Package integrity check failed (rpm -V)"
  CHECK_RESULT $? 0 0 "Package contains no files"
  CHECK_RESULT $? 0 0 "Documentation directory missing"
```

- 涉及命令：rpm×2

#### oe_test_alsa_firmware_files

- 描述：Test alsa-firmware file list and permissions
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Firmware directory /lib/firmware not found"
  CHECK_RESULT $? 0 0 "No regular files found in alsa-firmware package"
  CHECK_RESULT $fail 0 0 "Firmware file permission/size check failed"
```

#### oe_test_alsa_firmware_load

- 描述：Test alsa-firmware load capability
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Kernel firmware path /lib/firmware not available"
  CHECK_RESULT $missing 0 0 "alsa-firmware missing or not in standard search path"
  CHECK_RESULT $? 0 0 "Firmware loading errors detected in dmesg"
```
