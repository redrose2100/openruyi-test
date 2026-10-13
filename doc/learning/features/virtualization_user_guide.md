# virtualization_user_guide

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 文档域（doc-test） |
| 套件路径 | `${OET_PATH}/testcases/doc-test/virtualization/virtualization_user_guide` |
| 注册用例数 | 3 |
| 环境约束 | machine type = physical；add network interface = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_virtualization_user_guide | Installing virtualization, Ready environment, Manage virtual machines, Manage system resources, Management equipment | pre_test/run_test/post_test | 72 | ✔ |  | 60m |
| oe_test_manual_libcareplus_hot_patch | Manually create and apply a LibcarePlus hot patch | pre_test/run_test/post_test | 18 | ✔ |  |  |
| oe_test_libcareplus_hot_patch_by_script | Create and apply a LibcarePlus hot patch by script | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_virtualization_user_guide

- 描述：Installing virtualization, Ready environment, Manage virtual machines, Manage system resources, Management equipment
- 函数：`pre_test, run_test, post_test`
- 断言（72 条）：

```
  CHECK_RESULT $? 0 0 "Failed to start libvirtd.socket"
  CHECK_RESULT $? 0 0 "the kernel don't supports KVM virtualization"
  CHECK_RESULT $? 0 0 "the kernel don't supports KVM virtualization"
  CHECK_RESULT $? 0 0 "the kernel don't supports KVM virtualization"
  CHECK_RESULT $? 0 0 "Failed to install qemu"
  CHECK_RESULT $? 0 0 "Failed to install libvirt"
  CHECK_RESULT $? 0 0 "libvirtd.socket is not running"
  CHECK_RESULT $? 0 0 "Failed to create image file"
  CHECK_RESULT $? 0 0 "Failed to query the current VM image"
  CHECK_RESULT $? 0 0 "Failed to expand the VM image disk space"
  CHECK_RESULT $? 0 0 "Failed to query the adjusted VM image"
  CHECK_RESULT $? 0 0 "Failed to create bridge br0"
  ... 共 72 条（其余见源脚本）
```

- 涉及命令：rpm×4, sed×4, wget×3, test×2, usermod×1, userdel×1

#### oe_test_manual_libcareplus_hot_patch

- 描述：Manually create and apply a LibcarePlus hot patch
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "Failed to compile file: foo.c"
  CHECK_RESULT $? 0 0 "Failed to compile file: bar.c"
  CHECK_RESULT $? 0 0 "Failed to rename the patch assembly file"
  CHECK_RESULT $? 0 0 "Failed to compare using kpatch_gensrc"
  CHECK_RESULT $? 0 0 "Failed to generate the file: foobar.s"
  CHECK_RESULT $? 0 0 "Failed to generate the executable file: foo"
  CHECK_RESULT $? 0 0 "Failed to generate the executable file: foobar"
  CHECK_RESULT $? 0 0 "Failed to execute kpatch_strip --strip"
  CHECK_RESULT $? 0 0 "Failed to execute kpatch_strip --rel-fixup"
  CHECK_RESULT $? 0 0 "Failed to execute strip --strip-unneeded"
  CHECK_RESULT $? 0 0 "Failed to execute kpatch_strip --undo-link"
  CHECK_RESULT $? 0 0 "Failed to generate output file: foobar.stripped"
  ... 共 18 条（其余见源脚本）
```

- 涉及命令：gcc×4, test×3, sed×1, kpatch_make×1, libcare-ctl×1

#### oe_test_libcareplus_hot_patch_by_script

- 描述：Create and apply a LibcarePlus hot patch by script
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to generate comparison file"
  CHECK_RESULT $? 0 0 "Failed to make patches"
  CHECK_RESULT $? 0 0 "Failed to generate hot patches file: foo.kpatch"
  CHECK_RESULT $? 0 0 "Failed to run ./lpmake/foo"
  CHECK_RESULT $? 0 0 "Failed to query the LibcarePlus hot patches"
  CHECK_RESULT $? 0 0 "Failed to uninstall the LibcarePlus hot patches"
```

- 涉及命令：test×2, diff×1, libcare-ctl×1
