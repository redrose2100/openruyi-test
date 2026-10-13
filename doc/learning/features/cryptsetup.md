# cryptsetup

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/cryptsetup` |
| 注册用例数 | 3 |
| 环境约束 | add disk = 10 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_encrypt_data | Encrypt data on unencrypted devices | config_params/pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_luks_encrypted | Configuring automated unlocking of a LUKS-encrypted removable storage device | config_params/pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_use_luks | Encrypting existing data on a block device using LUKS with a detached header | config_params/pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_encrypt_data

- 描述：Encrypt data on unencrypted devices
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Disk encryption failed"
  CHECK_RESULT $? 0 0 "Disk mapping failed"
  CHECK_RESULT $? 0 0 "Failed to format partition"
  CHECK_RESULT $? 0 0 "Disk mount failed"
```

- 涉及命令：test×1

#### oe_test_luks_encrypted

- 描述：Configuring automated unlocking of a LUKS-encrypted removable storage device
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Disk encryption failed"
  CHECK_RESULT $? 0 0 "Disk mapping failed"
  CHECK_RESULT $? 0 0 "Failed to format partition"
  CHECK_RESULT $? 0 0 "Disk mount failed"
  CHECK_RESULT $? 0 0 "Backup luksHeader information failed"
  CHECK_RESULT $? 0 0 "Failed to enable tangd.socket service"
  CHECK_RESULT $? 0 0 "Failed to display the 'Listen' property of tangd.socket"
  CHECK_RESULT $? 0 0 "Failed to start tangd.socket service"
  CHECK_RESULT $? 0 0 "Failed to transfer data to adv.jws file"
  CHECK_RESULT $? 0 0 "Failed to encrypt data"
  CHECK_RESULT $? 0 0 "Luksmeta init failed"
  CHECK_RESULT $? 0 0 "Failed to write data"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：expect×3, test×2

#### oe_test_use_luks

- 描述：Encrypting existing data on a block device using LUKS with a detached header
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Disk encryption failed"
  CHECK_RESULT $? 0 0 "Disk mapping failed"
  CHECK_RESULT $? 0 0 "Failed to format partition"
  CHECK_RESULT $? 0 0 "Disk mount failed"
```

- 涉及命令：test×1
