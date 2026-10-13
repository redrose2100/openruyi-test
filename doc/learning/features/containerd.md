# containerd

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/containerd` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_containerd | containerd command validation | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_service_containerd | Test containerd.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_containerd

- 描述：containerd command validation
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "Image removal failed"
  CHECK_RESULT $? 0 0 "Container creation failed"
  CHECK_RESULT $? 0 0 "Container startup failed"
  CHECK_RESULT $? 0 0 "Container not running"
```

- 涉及命令：umount×1

#### oe_test_service_containerd

- 描述：Test containerd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of containerd.service"
```

- 涉及命令：mkdir×1
