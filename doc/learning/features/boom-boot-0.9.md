# boom-boot-0.9

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/boom-boot` |
| 注册用例数 | 3 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_boom_boot_0.9_01 | Test "boom-boot" command | pre_test/run_test/post_test | 20 | ✔ |  |  |
| oe_test_boom_boot_0.9_02 | Test "boom-boot" command | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_boom_boot_0.9_03 | Test "boom-boot" command | pre_test/run_test/post_test | 27 | ✔ |  |  |

### 断言与命令明细

#### oe_test_boom_boot_0.9_01

- 描述：Test "boom-boot" command
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -help No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -b No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --boot-id No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --bootid No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --boot-dir No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -B No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --btrfs-subvolume No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --btrfssubvolume No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --btrfs-opts No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --btrfsopts No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -c No Pass"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：boom×7

#### oe_test_boom_boot_0.9_02

- 描述：Test "boom-boot" command
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --machine-id No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --machineid No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -n No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -name No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --name-prefixes No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO:  --nameprefixes No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --no-headings No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --noheadingsNo Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --no-dev No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --nodev  No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -o No Pass"
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：boom×9

#### oe_test_boom_boot_0.9_03

- 描述：Test "boom-boot" command
- 函数：`pre_test, run_test, post_test`
- 断言（27 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: --osrelease No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --os-release No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --profile No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -r No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -root-device No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -rootdevice No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: -R No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --initramfs-pattern No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --initramfspattern No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --rows No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: --separator No Pass"
  ... 共 27 条（其余见源脚本）
```

- 涉及命令：boom×12
