# rpcsvc-proto

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/rpcsvc-proto` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_rpcsvc-proto_rpcgen | verify the uasge of rpcsvc-proto command | pre_test/run_test/post_test | 10 | ✔ |  |  |

### 断言与命令明细

#### oe_test_rpcsvc-proto_rpcgen

- 描述：verify the uasge of rpcsvc-proto command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check rpcgen -C  text.x  -T  failed"
  CHECK_RESULT $? 0 0 "Check rpcgen -C -a -b text.x -I -K 2 -L -M -N -5  failed"
  CHECK_RESULT $? 0 0 "Check rpcgen -C text.x -h -i 100  failed"
  CHECK_RESULT $? 0 0 "Check rpcgen -C text.x -l  failed"
  CHECK_RESULT $? 0 0 "Check rpcgen -C text.x -m  failed"
  CHECK_RESULT $? 0 0 "Check rpcgen -C text.x -c -o demo1  failed"
  CHECK_RESULT $? 0 0 "Check rpcgen -C  text.x  -Sc  failed"
  CHECK_RESULT $? 0 0 "Check rpcgen -C text.x -t  failed"
  CHECK_RESULT $? 0 0 "Check rpcgen --version  failed"
  CHECK_RESULT $? 0 0 "Check rpcgen --help  failed"
```

- 涉及命令：rpcgen×8, test×3
