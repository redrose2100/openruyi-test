# openmpi

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/openmpi` |
| 注册用例数 | 3 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_openmpi_cluster | command test openmpi cluster | pre_test/run_test/post_test | 20 | ✔ | ✔ |  |
| oe_test_openmpi_single_01 | command test openmpi single | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_openmpi_single_02 | command test openmpi single | pre_test/run_test/post_test | 5 | ✔ |  |  |

### 断言与命令明细

#### oe_test_openmpi_cluster

- 描述：command test openmpi cluster
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

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
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：grep×10, test×2, ompi-clean×2, ompi-server×2, sed×2, ping×1, ssh-keygen×1, expect×1, exportfs×1, iptables×1, mount×1, pkill×1

#### oe_test_openmpi_single_01

- 描述：command test openmpi single
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

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
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：grep×3, test×1, ompi-clean×1, ompi-server×1, ompi_info×1, sed×1

#### oe_test_openmpi_single_02

- 描述：command test openmpi single
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：orte-clean×1, orte-server×1, orted×1, grep×1, sed×1
