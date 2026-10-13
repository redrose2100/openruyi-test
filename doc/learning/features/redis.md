# redis

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/redis` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_redis | Test redis.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_redis-sentinel | Test redis-sentinel.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_redis_01 | Test redis command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_redis_02 | Test redis command | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_redis

- 描述：Test redis.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_redis-sentinel

- 描述：Test redis-sentinel.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_redis_01

- 描述：Test redis command
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

- 涉及命令：redis-benchmark×4, redis-cli×2

#### oe_test_redis_02

- 描述：Test redis command
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
  CHECK_RESULT $? 1
  CHECK_RESULT $?
  CHECK_RESULT $?
```

- 涉及命令：redis-cli×4, expect×1, grep×1, test×1
