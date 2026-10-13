# libgeotiff

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `${OET_PATH}/testcases/cli-test/libgeotiff` |
| 注册用例数 | 1 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_libgeotiff | Many of the innuendo parameters and type information used to describe the popularity of GeoTiff | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_libgeotiff

- 描述：Many of the innuendo parameters and type information used to describe the popularity of GeoTiff
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "The geo file is not generated"
  CHECK_RESULT $? 0 0 "Use the decimal point instead of the DMS to report corner failures"
  CHECK_RESULT $? 0 0 "Report project.4 equivalent projection definition failed"
  CHECK_RESULT $? 0 0 "Do not report a failure to normalize parameter values"
  CHECK_RESULT $? 0 0 "The tfw file is not generated"
  CHECK_RESULT $? 0 0 "This file is not an image file"
  CHECK_RESULT $? 0 0 "This file is not an image file"
```

- 涉及命令：listgeo×4, test×1
