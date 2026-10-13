# scrub

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/scrub` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_scrub_base_01 | verify the uasge of scrub command | pre_test/run_test/post_test | 14 | ✔ |  |  |

### 断言与命令明细

#### oe_test_scrub_base_01

- 描述：verify the uasge of scrub command
- 函数：`pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "Check scrub --version failed"
  CHECK_RESULT $? 0 0 "Check scrub -v failed"
  CHECK_RESULT $? 0 0 "Check scrub -h failed"
  CHECK_RESULT $? 0 0 "Check scrub --help failed"
  CHECK_RESULT $? 0 0 "Check scrub -b -X -s failed"
  CHECK_RESULT $? 0 0 "Check scrub --blocksize --device-size --freespace failed"
  CHECK_RESULT $? 0 0 "Check scrub p failed"
  CHECK_RESULT $? 0 0 "Check scrub --pattern failed"
  CHECK_RESULT $? 0 0 "Check scrub failed"
  CHECK_RESULT $? 0 0 "Check scrub -f failed"
  CHECK_RESULT $? 0 0 "Check scrub failed"
  CHECK_RESULT $? 0 0 "Check scrub --force failed"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：scrub×5, timeout×2, test×2
