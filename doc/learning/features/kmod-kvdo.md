# kmod-kvdo

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/kmod-kvdo` |
| 注册用例数 | 3 |
| 环境约束 | machine num = 2；add disk = 130 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_kvdo_fenqu | Partition on the LVM volume, write data to the partition, restart and check whether the data is lost | pre_test/run_test/post_test | 9 | ✔ | ✔ | 60m |
| oe_test_kvdo_vdo_cpu | View the CPU load of the indexw kernel thread when the VDO volume is not in use | pre_test/run_test/post_test | 4 | ✔ |  | 60m |
| oe_test_kvdo_vdo_iocopy | High load reads and writes on VOD volumes | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_kvdo_fenqu

- 描述：Partition on the LVM volume, write data to the partition, restart and check whether the data is lost
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：test×1, lvremove×1, vgremove×1, pvremove×1

#### oe_test_kvdo_vdo_cpu

- 描述：View the CPU load of the indexw kernel thread when the VDO volume is not in use
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 0 1
```

- 涉及命令：test×1, top×1, lvremove×1, vgremove×1

#### oe_test_kvdo_vdo_iocopy

- 描述：High load reads and writes on VOD volumes
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT "${num_tmp}" 0
```

- 涉及命令：test×1, kill×1, lvremove×1, vgremove×1
