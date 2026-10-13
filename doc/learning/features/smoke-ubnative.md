# smoke-ubnative

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 冒烟域（smoke-test） |
| 套件路径 | `${OET_PATH}/testcases/smoke-test/smoke-ubnative` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ubnative_ping | Test ub vm ping | pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_ubnative_vmlife | Test ub vm life cycle | pre_test/run_test/post_test | 18 |  |  |  |

### 断言与命令明细

#### oe_test_ubnative_ping

- 描述：Test ub vm ping
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "check vm ub bus failed"
  CHECK_RESULT $? 0 0 "check vm ub dev failed"
```

#### oe_test_ubnative_vmlife

- 描述：Test ub vm life cycle
- 函数：`pre_test, run_test, post_test`
- 断言（18 条）：

```
  CHECK_RESULT $? 0 0 "create vm failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "check vm ub failed"
  CHECK_RESULT $? 0 0 "suspend vm failed"
  CHECK_RESULT $? 0 0 "resume vm failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "check vm ub failed"
  CHECK_RESULT $? 0 0 "reboot vm failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  CHECK_RESULT $? 0 0 "check vm ub failed"
  CHECK_RESULT $? 0 0 "internal reboot failed"
  CHECK_RESULT $? 0 0 "ping vm failed"
  ... 共 18 条（其余见源脚本）
```
