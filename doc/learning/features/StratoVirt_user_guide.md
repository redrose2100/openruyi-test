# StratoVirt_user_guide

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 文档域（doc-test） |
| 套件路径 | `${OET_PATH}/testcases/doc-test/virtualization/StratoVirt_user_guide` |
| 注册用例数 | 3 |
| 环境约束 | machine type = physical |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ready_environment | Installing StratoVirt & Ready environment | config_params/pre_test/run_test/post_test | 16 | ✔ |  | 60m |
| oe_test_manage_stratovirt_vm | Manage StratoVirt virtual machines | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_manage_stratovirt_vm_resources | Manage StratoVirt VM resources | pre_test/run_test/post_test | 2 |  |  |  |

### 断言与命令明细

#### oe_test_ready_environment

- 描述：Installing StratoVirt & Ready environment
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（16 条）：

```
  CHECK_RESULT $? 0 0 "Failed to install StratoVirt"
  CHECK_RESULT $? 0 0 "Failed to import device /dev/vhost-vsock"
  CHECK_RESULT $? 0 0 "The /dev/vhost-vsock device does not exist"
  CHECK_RESULT $? 0 0 "Failed to git clone kernel"
  CHECK_RESULT $? 0 0 "Failed to switch the kernel version to $openeulerversion"
  CHECK_RESULT $? 0 0 "Failed to git clone stratovirt"
  CHECK_RESULT $? 0 0 "Failed to configure and compile the Linux kernel"
  CHECK_RESULT $? 0 0 "Failed to convert the kernel image to PE format"
  CHECK_RESULT $? 0 0 "Failed to convert the kernel image to bzImzge format"
  CHECK_RESULT $? 0 0 "Failed to create a file with 10GiB of space"
  CHECK_RESULT $? 0 0 "Failed to create an empty ext4 file system"
  CHECK_RESULT $? 0 0 "Failed to mount a file image"
  ... 共 16 条（其余见源脚本）
```

- 涉及命令：mount×3, make×2, stratovirt×1, tar×1, poweroff×1

#### oe_test_manage_stratovirt_vm

- 描述：Manage StratoVirt virtual machines
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 'Failed to quit the stratovirt VM'
```

#### oe_test_manage_stratovirt_vm_resources

- 描述：Manage StratoVirt VM resources
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 'Failed to quit the stratovirt VM'
  CHECK_RESULT $? 0 0 'Failed to restore the stratovirt VM using a snapshot'
```
