# redis5

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/redis5` |
| 注册用例数 | 4 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_redis5-sentinel | Test redis-sentinel.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_service_redis5 | Test redis.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_redis5_01 | Test redis5 command | pre_test/run_test/post_test | 15 | ✔ |  |  |
| oe_test_redis5_02 | Test redis5 command | pre_test/run_test/post_test | 14 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_redis5-sentinel

- 描述：Test redis-sentinel.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_redis5

- 描述：Test redis.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_redis5_01

- 描述：Test redis5 command
- 函数：`pre_test, run_test, post_test`
- 断言（15 条）：

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
  ... 共 15 条（其余见源脚本）
```

- 涉及命令：redis-benchmark×7, redis-cli×4

#### oe_test_redis5_02

- 描述：Test redis5 command
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
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
  CHECK_RESULT $?
  CHECK_RESULT $?
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：redis-cli×2, expect×1, grep×1, test×1, sed×1, kill×1
