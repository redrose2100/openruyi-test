# galera

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/galera` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_galera_garbd | A plug-in shared library file | pre_test/run_test/post_test | 10 |  |  |  |
| oe_test_service_garbd | Test garbd.service restart | pre_test/run_test/post_test | 1 | ✔ |  |  |

### 断言与命令明细

#### oe_test_galera_garbd

- 描述：A plug-in shared library file
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "The 'garbd -d --group grabd_name' process doesn't exist"
  CHECK_RESULT $? 0 0 "The help message is printed incorrectly"
  CHECK_RESULT $? 0 0 "The 'garbd -d -g garbd_name' process does not exist"
  CHECK_RESULT $? 0 0 "The 'garbd -d -n node_name -g grabd_name --address' process does not exist"
  CHECK_RESULT $? 0 0 "The 'garbd -d --name node_name --group grabd_name' process does not exist"
  CHECK_RESULT $? 0 0 "The SST process does not exist"
  CHECK_RESULT $? 0 0 "The node_name does not exist"
  CHECK_RESULT $? 0 0 "The options was not found"
  CHECK_RESULT $? 0 0 "The node_name was not found"
  CHECK_RESULT $? 0 0 "The version number is printed incorrectly"
```

- 涉及命令：garbd×10, test×8, kill×8

#### oe_test_service_garbd

- 描述：Test garbd.service restart
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
```

- 涉及命令：sed×5, mysqladmin×1, chown×1, grep×1
