# kubeedge

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `${OET_PATH}/testcases/feature-test/kubeedge` |
| 注册用例数 | 1 |
| 环境约束 | machine num = 2 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_kubeedge_deployment_guide | KubeEdge Deployment Guide | pre_test/run_test/post_test | 19 | ✔ | ✔ |  |

### 断言与命令明细

#### oe_test_kubeedge_deployment_guide

- 描述：KubeEdge Deployment Guide
- 函数：`pre_test, run_test, post_test`
- 断言（19 条）：

```
  CHECK_RESULT $? 0 0 "Failed to switch the cloud.kubeedge ntp server"
  CHECK_RESULT $? 0 0 "Failed to initialize the cloud.kubeedge environment"
  CHECK_RESULT $? 0 0 "Failed to initialize your Kubernetes control-plane"
  CHECK_RESULT $? 0 0 "Failed to install the cloud.kubeedge container network"
  CHECK_RESULT $? 0 0 "Failed to deploy the cloud.kubeedge"
  CHECK_RESULT $? 0 0 "Not all k8s components run successfully"
  CHECK_RESULT $? 0 0 "Failed to initialize cluster"
  CHECK_RESULT $? 0 0 "Failed to adjust cloudcore cfg"
  CHECK_RESULT $? 0 0 "Failed to deploy cloudcore"
  CHECK_RESULT $? 0 0 "Failed to get the cloud.kubeedge token"
  CHECK_RESULT $? 0 0 "Failed to switch the edge.kubeedge ntp server"
  CHECK_RESULT $? 0 0 "Failed to initialize the edge.kubeedge environment"
  ... 共 19 条（其余见源脚本）
```

- 涉及命令：sed×2, wget×1, mkdir×1, swapon×1
