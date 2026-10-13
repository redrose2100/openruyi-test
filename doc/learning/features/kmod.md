# kmod

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/kmod` |
| 注册用例数 | 7 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_depmod | verify the uasge of depmod command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_insmod-lsmod | verify the uasge of insmod and lsmod command | run_test | 10 |  |  |  |
| oe_test_kmod | verify the uasge of kmod command | run_test | 5 |  |  |  |
| oe_test_modinfo | verify the uasge of modinfo command | pre_test/run_test | 9 |  |  |  |
| oe_test_modprobe | verify the uasge of modprobe command | run_test | 21 |  |  |  |
| oe_test_rmmod | verify the uasge of rmmod command | run_test | 10 |  |  |  |
| oe_test_weak-modules | verify the uasge of weak-modules command | run_test | 7 |  |  |  |

### 断言与命令明细

#### oe_test_depmod

- 描述：verify the uasge of depmod command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

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
```

- 涉及命令：depmod×8

#### oe_test_insmod-lsmod

- 描述：verify the uasge of insmod and lsmod command
- 函数：`run_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
```

- 涉及命令：insmod×4

#### oe_test_kmod

- 描述：verify the uasge of kmod command
- 函数：`run_test`
- 断言（5 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：kmod×2

#### oe_test_modinfo

- 描述：verify the uasge of modinfo command
- 函数：`pre_test, run_test`
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

- 涉及命令：modinfo×7

#### oe_test_modprobe

- 描述：verify the uasge of modprobe command
- 函数：`run_test`
- 断言（21 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：modprobe×7

#### oe_test_rmmod

- 描述：verify the uasge of rmmod command
- 函数：`run_test`
- 断言（10 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $? 1
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：rmmod×5, modprobe×1

#### oe_test_weak-modules

- 描述：verify the uasge of weak-modules command
- 函数：`run_test`
- 断言（7 条）：

```
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
  CHECK_RESULT $?
```
