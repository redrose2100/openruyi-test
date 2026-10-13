# clevis

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/clevis` |
| 注册用例数 | 5 |
| 环境约束 | machine num = 2；add disk = 10 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_clevis-luks-askpass | Test clevis-luks-askpass.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_high_nbde | Deploying high-availability NBDE systems | config_params/pre_test/run_test/post_test | 10 | ✔ | ✔ |  |
| oe_test_install_clevis | Install clevis | config_params/pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_tang_encrypt | Rotate the Tang server key and update the binding | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_tang_nbde | Deploying an encryption client for an NBDE system with Tang | config_params/pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_clevis-luks-askpass

- 描述：Test clevis-luks-askpass.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_high_nbde

- 描述：Deploying high-availability NBDE systems
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Disk encryption failed"
  CHECK_RESULT $? 0 0 "Disk mapping failed"
  CHECK_RESULT $? 0 0 "Disk mount failed"
  CHECK_RESULT $? 0 0 "Backup luksHeader information failed"
  CHECK_RESULT $? 0 0 "Failed to enable tangd.socket service"
  CHECK_RESULT $? 0 0 "Failed to display the 'Listen' property of tangd.socket"
  CHECK_RESULT $? 0 0 "Failed to start tangd.socket service"
  CHECK_RESULT $? 0 0 "luksmeta init failed"
  CHECK_RESULT $? 0 0 "Disk binding failed"
  CHECK_RESULT $? 0 0 "Disk unbinding failed"
```

- 涉及命令：expect×3, read×1

#### oe_test_install_clevis

- 描述：Install clevis
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Failed to systemctl enable tangd.socket"
  CHECK_RESULT $? 0 0 "Failed to display the 'Listen' property of tangd.socket"
  CHECK_RESULT $? 0 0 "Failed to start tangd.socket service"
  CHECK_RESULT $? 0 0 "Failed to generate a new key using the /var/db/Tang d-keygen command on the Tang server"
  CHECK_RESULT $? 0 0 "Failed to check whether the Tang server advertises the signature key from the new key pair"
  CHECK_RESULT $? 0 0 "Failed to restart tangd.socket service"
  CHECK_RESULT $? 0 0 "Failed to transfer data to adv.jws file"
  CHECK_RESULT $? 0 0 "Failed to encrypt file"
  CHECK_RESULT $? 0 0 "Failed to decrypt file"
```

#### oe_test_tang_encrypt

- 描述：Rotate the Tang server key and update the binding
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to start tangd.socket service"
  CHECK_RESULT $? 0 0 "Failed to check whether the Tang server advertises the signature key from the new key pair"
  CHECK_RESULT $? 0 0 "Failed to restart tangd.socket service"
  CHECK_RESULT $? 0 0 "Failed to check whether the Tang server advertises the signature key from the new key pair"
```

#### oe_test_tang_nbde

- 描述：Deploying an encryption client for an NBDE system with Tang
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to enable tangd.socket service"
  CHECK_RESULT $? 0 0 "Failed to start tangd.socket service"
  CHECK_RESULT $? 0 0 "Failed to generate a new key using the /var/db/Tang d-keygen command on the Tang server"
  CHECK_RESULT $? 0 0 "Failed to restart tangd.socket service"
  CHECK_RESULT $? 0 0 "Failed to encrypt data"
  CHECK_RESULT $? 0 0 "Failed to decrypt data"
```
