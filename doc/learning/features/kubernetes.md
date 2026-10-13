# kubernetes

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/kubernetes` |
| 注册用例数 | 5 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_kube-controller-manager | Test kube-controller-manager.service restart | pre_test/run_test/post_test | 1 |  |  | 90m |
| oe_test_service_kube-scheduler | Test kube-scheduler.servicerestart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_kubelet | Test kubelet.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |
| oe_test_service_kube-proxy | Test kube-proxy.service restart | pre_test/run_test/post_test | 0 |  |  |  |
| oe_test_service_kube-apiserver | Test kube-apiserver.service restart | pre_test/run_test/post_test | 1 |  |  |  |

### 断言与命令明细

#### oe_test_service_kube-controller-manager

- 描述：Test kube-controller-manager.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

#### oe_test_service_kube-scheduler

- 描述：Test kube-scheduler.servicerestart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_kubelet

- 描述：Test kubelet.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

- 涉及命令：swapoff×1, swapon×1

#### oe_test_service_kube-proxy

- 描述：Test kube-proxy.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_service_kube-apiserver

- 描述：Test kube-apiserver.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```
