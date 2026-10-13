# gazelle

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/gazelle` |
| 注册用例数 | 3 |
| 环境约束 | add network interface = 1 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_gazelle_helloworld | gazelle 加载 hello world 测试 | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_gazelle_redis | gazelle 加速 redis-server 测试 | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_gazelle_gazellectl | gazellectl 命令测试 | pre_test/run_test/post_test | 8 | ✔ |  |  |

### 断言与命令明细

#### oe_test_gazelle_helloworld

- 描述：gazelle 加载 hello world 测试
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "gcc hello.c -o hello failed"
  CHECK_RESULT $? 0 0 "run hello failed"
  CHECK_RESULT $? 0 0 "test LSTACK_CONF_PATH failed"
  CHECK_RESULT $? 1 0 "run hello success"
```

- 涉及命令：sed×3, dpdk-devbind×2, mkdir×1, chmod×1, mount×1

#### oe_test_gazelle_redis

- 描述：gazelle 加速 redis-server 测试
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "run redis-server failed"
```

- 涉及命令：sed×3, dpdk-devbind×2, mkdir×1, chmod×1, mount×1, redis-benchmark×1

#### oe_test_gazelle_gazellectl

- 描述：gazellectl 命令测试
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "gazellectl lstack show 192.168.1.10 -c failed"
  CHECK_RESULT $? 0 0 "gazellectl lstack show 192.168.1.10 -x failed"
  CHECK_RESULT $? 0 0 "gazellectl lstack show 192.168.1.10 -k failed"
  CHECK_RESULT $? 0 0 "gazellectl lstack show 192.168.1.10 -p UDP failed"
  CHECK_RESULT $? 0 0 "gazellectl lstack show 192.168.1.10 -p TCP failed"
  CHECK_RESULT $? 0 0 "gazellectl lstack show 192.168.1.10 -p ICMP failed"
  CHECK_RESULT $? 0 0 "gazellectl lstack show 192.168.1.10 -p IP failed"
  CHECK_RESULT $? 0 0 "gazellectl lstack show 192.168.1.10 -p ETHARP failed"
```

- 涉及命令：sed×3, dpdk-devbind×2, mapfile×1, mkdir×1, chmod×1, mount×1
