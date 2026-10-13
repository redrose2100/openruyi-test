# fakechroot

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/fakechroot` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_fakechroot_env_01 | verify the uasge of fakechroot command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_fakechroot_env_02 | verify the uasge of fakechroot command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_fakechroot_base_01 | verify the uasge of fakechroot command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_fakechroot_base_02 | verify the uasge of fakechroot command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_fakechroot_chroot | verify the uasge of fakechroot command | pre_test/run_test/post_test | 4 | ✔ |  |  |

### 断言与命令明细

#### oe_test_fakechroot_env_01

- 描述：verify the uasge of fakechroot command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check env -i failed"
  CHECK_RESULT $? 0 0 "Check env --ignore-environment failed"
  CHECK_RESULT $? 0 0 "Check env.fakechroot -0 failed"
  CHECK_RESULT $? 0 0 "Check env.fakechroot --null failed"
  CHECK_RESULT $? 0 0 "Check env -u OLDPWD failed"
  CHECK_RESULT $? 0 0 "Check env --unset=OLDPWD failed"
  CHECK_RESULT $? 0 0 "Check env -C  failed"
  CHECK_RESULT $? 0 0 "Check env --chdir failed"
  CHECK_RESULT $? 0 0 "Check env -S failed"
  CHECK_RESULT $? 0 0 "Check env --split-string failed"
```

- 涉及命令：env×5

#### oe_test_fakechroot_env_02

- 描述：verify the uasge of fakechroot command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check env --block-signal failed"
  CHECK_RESULT $? 0 0 "Check env --default-signal failed"
  CHECK_RESULT $? 0 0 "Check env --ignore-signal failed"
  CHECK_RESULT $? 0 0 "Check env --list-signal failed"
  CHECK_RESULT $? 0 0 "Check env -v failed"
  CHECK_RESULT $? 0 0 "Check env --debug failed"
  CHECK_RESULT $? 0 0 "Check env --help failed"
  CHECK_RESULT $? 0 0 "Check env --version failed"
```

- 涉及命令：env×1

#### oe_test_fakechroot_base_01

- 描述：verify the uasge of fakechroot command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check fakechroot -h failed"
  CHECK_RESULT $? 0 0 "Check fakechroot --help failed"
  CHECK_RESULT $? 0 0 "Check fakechroot --version failed"
  CHECK_RESULT $? 0 0 "Check fakechroot -v failed"
  CHECK_RESULT $? 0 0 "Check fakechroot -l failed"
  CHECK_RESULT $? 0 0 "Check fakechroot --lib failed"
  CHECK_RESULT $? 0 0 "Check fakechroot -d failed"
  CHECK_RESULT $? 0 0 "Check fakechroot --elfloader failed"
  CHECK_RESULT $? 0 0 "Check fakechroot -l -s failed"
  CHECK_RESULT $? 0 0 "Check fakechroot -l --use-system-libs failed"
```

- 涉及命令：fakechroot×6

#### oe_test_fakechroot_base_02

- 描述：verify the uasge of fakechroot command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "Check fakechroot -l -e failed"
  CHECK_RESULT $? 0 0 "Check fakechroot -l --environment failed"
  CHECK_RESULT $? 0 0 "Check fakechroot -l -c failed"
  CHECK_RESULT $? 0 0 "Check fakechroot -l --config-dir failed"
  CHECK_RESULT $? 0 0 "Check fakechroot -b -l failed"
  CHECK_RESULT $? 0 0 "Check fakechroot --bindir -l  failed"
  CHECK_RESULT $? 0 0 "Check fakechroot -- failed"
  CHECK_RESULT $? 0 0 "Check ldd.fakechroot failed"
```

- 涉及命令：fakechroot×5

#### oe_test_fakechroot_chroot

- 描述：verify the uasge of fakechroot command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check chroot --groups= --skip-chdir failed"
  CHECK_RESULT $? 0 0 "Check chroot --userspec --skip-chdir failed"
  CHECK_RESULT $? 0 0 "Check chroot --help failed"
  CHECK_RESULT $? 0 0 "Check chroot --version failed"
```
