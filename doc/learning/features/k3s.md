# k3s

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/k3s` |
| 注册用例数 | 1 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_k3s_deployment_guide | k3s Deployment Guide | config_params/pre_test/run_test/post_test | 10 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_k3s_deployment_guide

- 描述：k3s Deployment Guide
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Failed to start the k3s-server"
  CHECK_RESULT $? 0 0 "Failed to deploy the k3s-server"
  CHECK_RESULT $? 0 0 "Failed to start the k3s-agent"
  CHECK_RESULT $? 0 0 "Failed to restart the k3s-server"
  CHECK_RESULT $? 0 0 "Failed to deploy the k3s-agent"
  CHECK_RESULT $? 0 0 "Failed to create the k3s-server nginx-deployment"
  CHECK_RESULT $? 0 0 "The status of the pods is not running"
  CHECK_RESULT $? 0 0 "Failed to create the k3s-server nginx-service"
  CHECK_RESULT $? 0 0 "The nginx-service information does not exist"
  CHECK_RESULT $? 0 0 "Failed to access nginx-service"
```

- 涉及命令：bash×1
