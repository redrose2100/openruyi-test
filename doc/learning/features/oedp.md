# oedp

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 特性域（feature-test） |
| 套件路径 | `$OET_PATH/testcases/feature-test/oedp` |
| 注册用例数 | 14 |
| 环境约束 | machine num = 3 |

> ⚠️ 本套件声明环境约束，执行前由 `check_environment.py` 预检；不满足的用例自动 skipped(255)。

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_oedp_01 | Test oedp version and help | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_oedp_02 | Test oedp repo command | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_oedp_03 | Test oedp init command | pre_test/run_test/post_test | 13 | ✔ |  |  |
| oe_test_oedp_04 | Check for dependencies in software systems | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_oedp_05 | Deployment of AnythingLLM | pre_test/run_test/post_test | 2 | ✔ | ✔ |  |
| oe_test_oedp_06 | Deployment of AnythingLLM | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_oedp_07 | Deployment of openEuler-Intelligence | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_oedp_08 | Deployment of KubeRay and train MLP model based on FashionMNIST on KubeRay | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_oedp_09 | Deployment of KubeRay and train MLP model based on FashionMNIST on KubeRay | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_oedp_10 | Deployment of kubeflow-1.9.1 | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_oedp_11 | Deploying kubeflow when disk space is insufficient | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_oedp_12 | Multiple deployments of Kubeflow | pre_test/install_kubeflow/uninstall_kubeflow/run_test/post_test | 1 | ✔ |  |  |
| oe_test_oedp_13 | Kubeflow deployment with Serverless | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_oedp_14 | Support deployment of Kubernetes with 1 master and 2 works | pre_test/run_test/post_test | 6 | ✔ |  |  |

### 断言与命令明细

#### oe_test_oedp_01

- 描述：Test oedp version and help
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to get oedp version or version format incorrect"
  CHECK_RESULT $? 0 0 "Failed to get oedp version with short option or version format incorrect"
  CHECK_RESULT $? 0 0 "Failed to get oedp help"
  CHECK_RESULT $? 0 0 "Failed to get oedp help"
```

- 涉及命令：oedp×2

#### oe_test_oedp_02

- 描述：Test oedp repo command
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to list repositories"
  CHECK_RESULT $? 0 0 "Failed to update repository cache"
  CHECK_RESULT $? 0 0 "Failed to set repo"
  CHECK_RESULT $? 0 0 "Failed to enable repo"
  CHECK_RESULT $? 0 0 "Failed to disable repo"
  CHECK_RESULT $? 0 0 "Failed to delete repo"
```

#### oe_test_oedp_03

- 描述：Test oedp init command
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "Failed to execute oedp repo update command"
  CHECK_RESULT $? 0 0 "Failed to oedp init "$plugin""
  CHECK_RESULT $? 0 0 "Failed to check "$plugin""
  CHECK_RESULT $? 0 0 "Failed to delete "$plugin""
  CHECK_RESULT $? 0 0 "Failed to oedp init "$plugin" by url"
  CHECK_RESULT $? 0 0 "Failed to check "$plugin""
  CHECK_RESULT $? 0 0 "Failed to delete "$plugin""
  CHECK_RESULT $? 0 0 "Failed to oedp init "$plugin" to home directory"
  CHECK_RESULT $? 0 0 "Failed to check "$plugin""
  CHECK_RESULT $? 0 0 "Failed to delete "$plugin""
  CHECK_RESULT $? 0 0 "Forcefully initializing "$plugin" to /root directory failed "
  CHECK_RESULT $? 0 0 "Failed to check "$plugin""
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：test×4

#### oe_test_oedp_04

- 描述：Check for dependencies in software systems
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to check Python3 in the system"
  CHECK_RESULT $? 0 0 "Failed to check ansible in the system"
  CHECK_RESULT $? 0 0 "Failed to check python3-prettytable in the system"
```

#### oe_test_oedp_05

- 描述：Deployment of AnythingLLM
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to install anythingLLM"
  CHECK_RESULT $? 0 0 "Failed to uninstall anythingLLM"
```

- 涉及命令：sed×2, ssh-keyscan×1

#### oe_test_oedp_06

- 描述：Deployment of AnythingLLM
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to install RAGFlow"
  CHECK_RESULT $? 0 0 "Failed to check log of RAGFlow"
  CHECK_RESULT $? 0 0 "Failed to uninstall RAGFlow"
```

- 涉及命令：sed×7, ssh-keyscan×1

#### oe_test_oedp_07

- 描述：Deployment of openEuler-Intelligence
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to init RAGFlow"
  CHECK_RESULT $? 0 0 "Failed to uninstall openEuler-Intelligence"
```

- 涉及命令：sed×2, ssh-keyscan×1

#### oe_test_oedp_08

- 描述：Deployment of KubeRay and train MLP model based on FashionMNIST on KubeRay
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to install KubeRay"
  CHECK_RESULT $? 0 0 "Failed to view port"
  CHECK_RESULT $? 0 0 "Failed to train MLP model based on FashionMNIST on KubeRay"
  CHECK_RESULT $? 0 0 "Failed to uninstall RAGFlow"
```

- 涉及命令：sed×7, ssh-keyscan×1

#### oe_test_oedp_09

- 描述：Deployment of KubeRay and train MLP model based on FashionMNIST on KubeRay
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Failed to install KubeRay"
  CHECK_RESULT $? 0 0 "Failed to train MLP model based on FashionMNIST on KubeRay"
  CHECK_RESULT $? 0 0 "Failed to uninstall KubeRay"
  CHECK_RESULT $? 0 0 "Failed to install KubeRay"
  CHECK_RESULT $? 0 0 "Failed to train MLP model based on FashionMNIST on KubeRay"
  CHECK_RESULT $? 0 0 "Failed to verify that $singlepod_time is greater than $mulpod_time"
  CHECK_RESULT $? 0 0 "Failed to uninstall KubeRay"
```

- 涉及命令：sed×9, ssh-keyscan×1

#### oe_test_oedp_10

- 描述：Deployment of kubeflow-1.9.1
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "Failed to install kubeflow"
  CHECK_RESULT $? 0 0 "Failed to verify that the average deployment time of kubeflow is less than 10 minutes"
```

- 涉及命令：sed×4, ssh-keyscan×1

#### oe_test_oedp_11

- 描述：Deploying kubeflow when disk space is insufficient
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Failed to deploying kubeflow when disk space is insufficient"
  CHECK_RESULT $? 0 0 "Failed to uninstall kubeflow"
  CHECK_RESULT $? 0 0 "Failed to install kubeflow"
  CHECK_RESULT $? 0 0 "Failed to uninstall kubeflow"
```

- 涉及命令：fallocate×4, sed×2, ssh-keyscan×1

#### oe_test_oedp_12

- 描述：Multiple deployments of Kubeflow
- 函数：`pre_test, install_kubeflow, uninstall_kubeflow, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "Overall test passed with $total_success/$total_rounds successful rounds"
```

- 涉及命令：sed×2, ssh-keyscan×1

#### oe_test_oedp_13

- 描述：Kubeflow deployment with Serverless
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Failed to deployment with Kserve"
  CHECK_RESULT $? 0 0 "Failed to deployment sklearn-iris"
  CHECK_RESULT $? 0 0 "Failed to grep sklearn-iris info"
```

- 涉及命令：sed×2, ssh-keyscan×1, curl×1

#### oe_test_oedp_14

- 描述：Support deployment of Kubernetes with 1 master and 2 works
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "Failed to update repo!"
  CHECK_RESULT $? 0 0 "Failed to init kubernetes!"
  CHECK_RESULT $? 0 0 "Failed to view info of kubernetes!"
  CHECK_RESULT $? 0 0 "Failed to deployment kubernetes"
  CHECK_RESULT $? 1 0 "Failed to verify that the status all pods is running"
  CHECK_RESULT $? 0 0 "Failed to uninstall kubernetes"
```

- 涉及命令：sed×7
