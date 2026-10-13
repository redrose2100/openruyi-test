# librabbitmq

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/librabbitmq` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_librabbitmq_amqp-declare-queue | verify the uasge of librabbitmq command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_librabbitmq_amqp-consume | verify the uasge of librabbitmq command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_librabbitmq_amqp-delete-queue | verify the uasge of librabbitmq command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_librabbitmq_amqp-get | verify the uasge of librabbitmq command | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_librabbitmq_amqp-publish | verify the uasge of librabbitmq command | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_librabbitmq_amqp-declare-queue

- 描述：verify the uasge of librabbitmq command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check amqp-declare-queue -q -d -s --port --vhost --username --password --heartbeat failed"
  CHECK_RESULT $? 0 0 "Check amqp-declare-queue -u -q -d --heartbeat failed"
  CHECK_RESULT $? 0 0 "Check amqp-declare-queue --usage failed"
  CHECK_RESULT $? 0 0 "Check amqp-declare-queue -?  failed"
  CHECK_RESULT $? 0 0 "Check amqp-declare-queue --help failed"
```

- 涉及命令：amqp-declare-queue×2

#### oe_test_librabbitmq_amqp-consume

- 描述：verify the uasge of librabbitmq command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check amqp-consume -r -b failed"
  CHECK_RESULT $? 0 0 "Check amqp-consume -r -b failed"
  CHECK_RESULT $? 0 0 "Check amqp-consume -e -x failed"
  CHECK_RESULT $? 0 0 "Check  amqp-consume --help failed"
  CHECK_RESULT $? 0 0 "Check amqp-consume --usage failed"
  CHECK_RESULT $? 0 0 "Check amqp-consume -? failed"
```

- 涉及命令：kill×3, amqp-publish×2, amqp-declare-queue×1

#### oe_test_librabbitmq_amqp-delete-queue

- 描述：verify the uasge of librabbitmq command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check amqp-delete-queue -s -q --port --vhost --username --password failed"
  CHECK_RESULT $? 0 0 "Check amqp-delete-queue -u -e -q -u --ssl --cacert --key --cert failed"
  CHECK_RESULT $? 0 0 "Check amqp-delete-queue --help  failed"
  CHECK_RESULT $? 0 0 "Check amqp-delete-queue -? failed"
  CHECK_RESULT $? 0 0 "Check amqp-delete-queue --usage failed"
```

- 涉及命令：amqp-declare-queue×2, amqp-publish×2, amqp-delete-queue×1

#### oe_test_librabbitmq_amqp-get

- 描述：verify the uasge of librabbitmq command
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "Check  amqp-get -q -u --ssl --cacert --key --cert failed"
  CHECK_RESULT $? 0 0 "Check  amqp-get -q -s --port --vost --username --password --heartbeat failed"
  CHECK_RESULT $? 0 0 "Check  amqp-get --help failed"
  CHECK_RESULT $? 0 0 "Check  amqp-get -? failed"
  CHECK_RESULT $? 0 0 "Check amqp-get --usage failed"
```

- 涉及命令：amqp-declare-queue×2, amqp-publish×2, amqp-get×2

#### oe_test_librabbitmq_amqp-publish

- 描述：verify the uasge of librabbitmq command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Check amqp-consume -e -l failed"
  CHECK_RESULT $? 0 0 "Check amqp-consume -r -b -C -t -p -E -H -s --port --vhost --username --password --heartbeat failed"
  CHECK_RESULT $? 0 0 "Check amqp-consume -r -b C -t -E -P -E -H -u --ssl --cacert --cert failed"
  CHECK_RESULT $? 0 0 "Check amqp-publish --help  failed"
  CHECK_RESULT $? 0 0 "Check amqp-publish --usage failed"
  CHECK_RESULT $? 0 0 "Check amqp-publish -? failed"
```

- 涉及命令：amqp-publish×2, kill×1
