# perl-Net-Server

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/perl-Net-Server` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_perl-Net-Server | Test perl-Net-Server | pre_test/run_test/post_test | 13 | ✔ |  |  |

### 断言与命令明细

#### oe_test_perl-Net-Server

- 描述：Test perl-Net-Server
- 函数：`pre_test, run_test, post_test`
- 断言（13 条）：

```
  CHECK_RESULT $? 0 0 "L$LINENO: Fork No Pass "
  CHECK_RESULT $? 0 0 "L$LINENO: INET No Pass. Output Error."
  CHECK_RESULT $? 1 0 "L$LINENO: INET No Pass. Port $port still in use."
  CHECK_RESULT $? 0 0 "L$LINENO: MultiType No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: Multiplex No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: PreForkSimple No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: PreFork No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: Single No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: Http No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: app No Pass"
  CHECK_RESULT $? 0 0 "L$LINENO: app No Pass. Failed to get data from net-server"
  CHECK_RESULT $? 0 0 "L$LINENO: IPv4 No Pass"
  ... 共 13 条（其余见源脚本）
```

- 涉及命令：netstat×11, kill×10
