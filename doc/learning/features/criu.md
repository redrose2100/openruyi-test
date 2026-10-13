# criu

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/criu` |
| 注册用例数 | 20 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_criu_base | Test "criu" command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_criu_base_dump_01 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_dump_02 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_dump_03 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_dump_04 | Test "criu" command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_criu_base_dump_05 | Test "criu" command | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_criu_base_pre-dump_01 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_pre-dump_02 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_pre-dump_03 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_pre-dump_04 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_pre-dump_05 | Test "criu" command | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_criu_base_restore_01 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_restore_02 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_restore_03 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_restore_04 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_restore_05 | Test "criu" command | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_criu_base_check_01 | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_check_02 | Test "criu" command | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_criu_base_page-server | Test "criu" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_criu_base_service | Test "criu" command | pre_test/run_test/post_test | 12 | ✔ |  |  |

### 断言与命令明细

#### oe_test_criu_base

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check --lazy-pages failed."
  CHECK_RESULT $? 0 0 "Check cpuinfo dump failed."
  CHECK_RESULT $? 0 0 "Check cpuinfo check failed."
  CHECK_RESULT $? 0 0 "Check -h failed."
  CHECK_RESULT $? 0 0 "Check --help failed."
  CHECK_RESULT $? 0 0 "Check -V failed."
  CHECK_RESULT $? 0 0 "Check --version failed."
```

- 涉及命令：criu×2, kill×1

#### oe_test_criu_base_dump_01

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu dump -j -t failed"
  CHECK_RESULT $? 0 0 "Check criu dump --shell-job failed"
  CHECK_RESULT $? 0 0 "Check criu dump --tree failed"
  CHECK_RESULT $? 0 0 "Check criu dump --pidfile failed"
  CHECK_RESULT $? 0 0 "Check criu dump -D failed"
  CHECK_RESULT $? 0 0 "Check criu dump --images-dir failed"
  CHECK_RESULT $? 0 0 "Check criu dump -s failed"
  CHECK_RESULT $? 0 0 "Check criu dump --leave-stopped failed"
  CHECK_RESULT $? 0 0 "Check criu dump -R failed"
  CHECK_RESULT $? 0 0 "Check criu dump --leave-running failed"
```

#### oe_test_criu_base_dump_02

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu dump -W failed"
  CHECK_RESULT $? 0 0 "Check criu dump --work-dir failed"
  CHECK_RESULT $? 0 0 "Check criu dump --cpu-cap failed"
  CHECK_RESULT $? 0 0 "Check criu dump --weak-sysctls failed"
  CHECK_RESULT $? 0 0 "Check criu dump --external failed"
  CHECK_RESULT $? 0 0 "Check criu dump --tcp-established failed"
  CHECK_RESULT $? 0 0 "Check criu dump --skip-in-flight failed"
  CHECK_RESULT $? 0 0 "Check criu dump --tcp-close failed"
  CHECK_RESULT $? 0 0 "Check criu dump -r failed"
  CHECK_RESULT $? 0 0 "Check criu dump --root failed"
```

#### oe_test_criu_base_dump_03

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu dump --evasive-devices failed"
  CHECK_RESULT $? 0 0 "Check criu dump --link-remap failed"
  CHECK_RESULT $? 0 0 "Check criu dump --ghost-limit failed"
  CHECK_RESULT $? 0 0 "Check criu dump -l failed"
  CHECK_RESULT $? 0 0 "Check criu dump --file-locks failed"
  CHECK_RESULT $? 0 0 "Check criu dump -L failed"
  CHECK_RESULT $? 0 0 "Check criu dump --libdir failed"
  CHECK_RESULT $? 0 0 "Check criu dump --force-irmap failed"
  CHECK_RESULT $? 0 0 "Check criu dump --irmap-scan-path failed"
  CHECK_RESULT $? 0 0 "Check criu dump --manage-cgroups failed"
```

#### oe_test_criu_base_dump_04

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check criu dump --cgroup-root failed"
  CHECK_RESULT $? 0 0 "Check criu dump --cgroup-dump-controller failed"
  CHECK_RESULT $? 0 0 "Check criu dump --cgroup-yard failed"
  CHECK_RESULT $? 0 0 "Check criu dump --skip-mnt failed"
  CHECK_RESULT $? 0 0 "Check criu dump --enable-fs failed"
  CHECK_RESULT $? 0 0 "Check criu dump --empty-ns net failed"
  CHECK_RESULT $? 0 0 "Check criu dump --file-validation failed"
  CHECK_RESULT $? 0 0 "Check criu dump --with-cpu-affinity failed"
  CHECK_RESULT $? 0 0 "Check criu dump --track-mem failed"
  CHECK_RESULT $? 0 0 "Check criu dump --track-mem failed"
  CHECK_RESULT $? 0 0 "Check criu dump --prev-images-dir failed"
```

#### oe_test_criu_base_dump_05

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Check criu dump --auto-dedup failed"
  CHECK_RESULT $? 0 0 "Check criu dump --pre-dump-mode failed"
```

#### oe_test_criu_base_pre-dump_01

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu pre-dump -j -t failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --shell-job failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump -j --tree failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --pidfile failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump -D failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --images-dir failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump -s failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --leave-stopped failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump -R failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --leave-running failed"
```

#### oe_test_criu_base_pre-dump_02

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu pre-dump -W failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --work-dir failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --cpu-cap failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --weak-sysctls failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --external failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --tcp-established failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --skip-in-flight failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --tcp-close failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump -r failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --root failed"
```

#### oe_test_criu_base_pre-dump_03

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu pre-dump --evasive-devices failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --link-remap failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --ghost-limit failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --action-script failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump -l failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --file-locks failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump -L failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --libdir failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --force-irmap failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --irmap-scan-path failed"
```

#### oe_test_criu_base_pre-dump_04

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu pre-dump --manage-cgroups failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --cgroup-root failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --cgroup-props STRING failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --cgroup-props-file STRING failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --cgroup-dump-controller failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --cgroup-yard failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --skip-mnt failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --enable-fs failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --empty-ns net failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --file-validation failed"
```

#### oe_test_criu_base_pre-dump_05

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Check criu pre-dump --with-cpu-affinity failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --track-mem failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --auto-dedup failed"
  CHECK_RESULT $? 0 0 "Check criu pre-dump --pre-dump-mode failed"
```

#### oe_test_criu_base_restore_01

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu restore -j failed"
  CHECK_RESULT $? 0 0 "Check criu restore --shell-job failed"
  CHECK_RESULT $? 0 0 "Check criu restore -d failed"
  CHECK_RESULT $? 0 0 "Check criu restore --restore-detached failed"
  CHECK_RESULT $? 0 0 "Check criu restore -S failed"
  CHECK_RESULT $? 0 0 "Check criu restore --restore-sibling failed"
  CHECK_RESULT $? 0 0 "Check criu restore -D failed"
  CHECK_RESULT $? 0 0 "Check criu restore --images-dir failed"
  CHECK_RESULT $? 0 0 "Check criu restore --pidfile failed"
  CHECK_RESULT $? 0 0 "Check criu restore -W failed"
```

#### oe_test_criu_base_restore_02

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu restore --work-dir failed"
  CHECK_RESULT $? 0 0 "Check criu restore --exec-cmd failed"
  CHECK_RESULT $? 0 0 "Check criu restore --weak-sysctls failed"
  CHECK_RESULT $? 0 0 "Check criu restore --external failed"
  CHECK_RESULT $? 0 0 "Check criu restore --tcp-established failed"
  CHECK_RESULT $? 0 0 "Check criu restore --skip-in-flight failed"
  CHECK_RESULT $? 0 0 "Check criu restore --tcp-close failed"
  CHECK_RESULT $? 0 0 "Check criu restore -r failed"
  CHECK_RESULT $? 0 0 "Check criu restore --root failed"
  CHECK_RESULT $? 0 0 "Check criu restore --evasive-devices failed"
```

#### oe_test_criu_base_restore_03

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu restore --link-remap failed"
  CHECK_RESULT $? 0 0 "Check criu restore --ghost-limit failed"
  CHECK_RESULT $? 0 0 "Check criu restore -l failed"
  CHECK_RESULT $? 0 0 "Check criu restore --file-locks failed"
  CHECK_RESULT $? 0 0 "Check criu restore -L failed"
  CHECK_RESULT $? 0 0 "Check criu restore --libdir failed"
  CHECK_RESULT $? 0 0 "Check criu restore --irmap-scan-path failed"
  CHECK_RESULT $? 0 0 "Check criu restore --manage-cgroups failed"
  CHECK_RESULT $? 0 0 "Check criu restore --cgroup-root failed"
  CHECK_RESULT $? 0 0 "Check criu restore --cgroup-props failed"
```

#### oe_test_criu_base_restore_04

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu restore --cgroup-props-file failed"
  CHECK_RESULT $? 0 0 "Check criu restore --cgroup-dump-controller failed"
  CHECK_RESULT $? 0 0 "Check criu restore --cgroup-yard failed"
  CHECK_RESULT $? 0 0 "Check criu restore --skip-mnt failed"
  CHECK_RESULT $? 0 0 "Check criu restore --enable-fs failed"
  CHECK_RESULT $? 0 0 "Check criu restore --empty-ns net failed"
  CHECK_RESULT $? 0 0 "Check criu restore --file-validation failed"
  CHECK_RESULT $? 0 0 "Check criu restore --with-cpu-affinity failed"
  CHECK_RESULT $? 0 0 "Check criu restore --track-mem failed"
  CHECK_RESULT $? 0 0 "Check criu restore --page-server failed"
```

#### oe_test_criu_base_restore_05

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Check criu restore --auto-dedup failed"
```

#### oe_test_criu_base_check_01

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check criu check failed"
  CHECK_RESULT $? 0 0 "Check criu check --experimental failed"
  CHECK_RESULT $? 0 0 "Check criu check --feature failed"
  CHECK_RESULT $? 0 0 "Check criu check -o failed"
  CHECK_RESULT $? 0 0 "Check criu check --log-file failed"
  CHECK_RESULT $? 0 0 "Check criu check --log-pid failed"
  CHECK_RESULT $? 0 0 "Check criu check -v failed"
  CHECK_RESULT $? 0 0 "Check criu check --verbosity failed"
  CHECK_RESULT $? 0 0 "Check criu check --config failed."
  CHECK_RESULT $? 0 0 "Check criu check --no-default-config failed."
```

#### oe_test_criu_base_check_02

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Check criu check -vNUM failed"
  CHECK_RESULT $? 0 0 "Check criu check --verbosity=NUM failed"
  CHECK_RESULT $? 0 0 "Check criu check --display-stats failed"
```

#### oe_test_criu_base_page-server

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check criu page-server failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check criu page-server --address failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check criu page-server --port failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check criu page-server --status-fd failed"
```

- 涉及命令：kill×4

#### oe_test_criu_base_service

- 描述：Test "criu" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check criu service failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check criu service --address failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check criu service --port failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check criu service --ps-socket failed"
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0
  CHECK_RESULT $? 0 0 "Check criu service --status-fd failed"
```

- 涉及命令：kill×5
