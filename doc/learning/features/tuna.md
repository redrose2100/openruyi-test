# tuna

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/tuna` |
| 注册用例数 | 8 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_tuna_apply | Test "tuna" command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_tuna_include | Test "tuna" command | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_tuna_run | Test "tuna" command | pre_test/run_test/post_test | 12 | ✔ |  |  |
| oe_test_tuna | Test "tuna" command | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_tuna_show_irqs | Test "tuna" command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_tuna_show_threads_01 | Test "tuna" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_tuna_show_threads_02 | Test "tuna" command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_tuna_spread | Test "tuna" command | pre_test/run_test/post_test | 17 | ✔ |  |  |

### 断言与命令明细

#### oe_test_tuna_apply

- 描述：Test "tuna" command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "tuna apply -h No Pass"
  CHECK_RESULT $? 0 0 "tuna apply --help No Pass"
  CHECK_RESULT $? 0 0 "tuna what_is -h No Pass"
  CHECK_RESULT $? 0 0 "tuna what_is --help No Pass"
  CHECK_RESULT $? 0 0 "tuna what_is No Pass"
  CHECK_RESULT $? 0 0 "tuna gui -h No Pass"
  CHECK_RESULT $? 0 0 "tuna gui --help No Pass"
  CHECK_RESULT $? 0 0 "tuna isolate -h No Pass"
  CHECK_RESULT $? 0 0 "tuna isolate --help No Pass"
```

#### oe_test_tuna_include

- 描述：Test "tuna" command
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "tuna include -h No Pass"
  CHECK_RESULT $? 0 0 "tuna include --help No Pass"
  CHECK_RESULT $? 0 0 "tuna include -c No Pass"
  CHECK_RESULT $? 0 0 "tuna include --cpus No Pass"
  CHECK_RESULT $? 0 0 "tuna include -S No Pass"
  CHECK_RESULT $? 0 0 "tuna include --sockets No Pass"
  CHECK_RESULT $? 0 0 "tuna move -h No Pass"
  CHECK_RESULT $? 0 0 "tuna move --help No Pass"
  CHECK_RESULT $? 0 0 "tuna move -c -q No Pass"
  CHECK_RESULT $? 0 0 "tuna show_irqs -q No Pass"
  CHECK_RESULT $? 0 0 "Restore irqs_id_cpu_affinity to default value"
  CHECK_RESULT $? 0 0 "tuna move -S --irqs No Pass"
  ... 共 17 条（其余见源脚本）
```

#### oe_test_tuna_run

- 描述：Test "tuna" command
- 函数：`pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "tuna run -h No Pass"
  CHECK_RESULT $? 0 0 "tuna run --help No Pass"
  CHECK_RESULT $? 0 0 "tuna run -c -p No Pass"
  CHECK_RESULT $? 0 0 "tuna run -S -b No Pass"
  CHECK_RESULT $? 0 0 "tuna run --cpus --priority No Pass"
  CHECK_RESULT $? 0 0 "tuna run --sockets --background No Pass"
  CHECK_RESULT $? 0 0 "tuna save -h No Pass"
  CHECK_RESULT $? 0 0 "tuna save --help No Pass"
  CHECK_RESULT $? 0 0 "tuna save -c -t No Pass"
  CHECK_RESULT $? 0 0 "tuna save -S -t No Pass"
  CHECK_RESULT $? 0 0 "tuna save --cpus -t No Pass"
  CHECK_RESULT $? 0 0 "tuna save -sockets --threads No Pass"
```

#### oe_test_tuna

- 描述：Test "tuna" command
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "tuna -h No Pass"
  CHECK_RESULT $? 0 0 "tuna --help No Pass"
  CHECK_RESULT $? 0 0 "tuna -v No Pass"
  CHECK_RESULT $? 0 0 "tuna --version No Pass"
  CHECK_RESULT $? 0 0 "tuna -D No Pass"
  CHECK_RESULT $? 0 0 "tuna -L No Pass"
  CHECK_RESULT $? 0 0 "tuna --debug No Pass"
  CHECK_RESULT $? 0 0 "tuna --logging No Pass"
```

- 涉及命令：tuna×5

#### oe_test_tuna_show_irqs

- 描述：Test "tuna" command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "tuna show_irqs -h No Pass"
  CHECK_RESULT $? 0 0 "tuna show_irqs --help No Pass"
  CHECK_RESULT $? 0 0 "tuna show_irqs -c No Pass"
  CHECK_RESULT $? 0 0 "tuna show_irqs --cpus No Pass"
  CHECK_RESULT $? 0 0 "tuna show_irqs -S No Pass"
  CHECK_RESULT $? 0 0 "tuna show_irqs --sockets No Pass"
  CHECK_RESULT $? 0 0 "tuna show_irqs -q No Pass"
  CHECK_RESULT $? 0 0 "tuna show_irqs --irqs No Pass"
  CHECK_RESULT $? 0 0 "tuna show_configs No Pass"
  CHECK_RESULT $? 0 0 "tuna show_configs -h No Pass"
  CHECK_RESULT $? 0 0 "tuna show_configs --help No Pass"
```

#### oe_test_tuna_show_threads_01

- 描述：Test "tuna" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "tuna show_threads -h No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads --help No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads -c No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads --cpus No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads -S No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads --sockets No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads -t No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads --threads No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads -q No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads --irqs No Pass"
```

#### oe_test_tuna_show_threads_02

- 描述：Test "tuna" command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "tuna show_threads No Pass"
  CHECK_RESULT $? 0 1 "tuna show_threads -U No Pass"
  CHECK_RESULT $? 0 1 "tuna show_threads --no_uthreads No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads No Pass"
  CHECK_RESULT $? 0 1 "tuna show_threads -K No Pass"
  CHECK_RESULT $? 0 1 "tuna show_threads --no_kthreads No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads -G No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads --cgroups No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads -z No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads --spaced No Pass"
```

#### oe_test_tuna_spread

- 描述：Test "tuna" command
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "tuna spread -h No Pass"
  CHECK_RESULT $? 0 0 "tuna spread --help No Pass"
  CHECK_RESULT $? 0 0 "tuna spread -c -q No Pass"
  CHECK_RESULT $? 0 0 "tuna show_irqs -q No Pass"
  CHECK_RESULT $? 0 0 "Restore irqs_id_cpu_affinity to default value"
  CHECK_RESULT $? 0 0 "tuna spread -S --irqs No Pass"
  CHECK_RESULT $? 0 0 "tuna show_irqs -q No Pass"
  CHECK_RESULT $? 0 0 "tuna spread -cpus -t No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads -t No Pass"
  CHECK_RESULT $? 0 0 "tuna spread --sockets --threads No Pass"
  CHECK_RESULT $? 0 0 "tuna show_threads -t No Pass"
  CHECK_RESULT $? 0 0 "tuna priority -h No Pass"
  ... 共 17 条（其余见源脚本）
```
