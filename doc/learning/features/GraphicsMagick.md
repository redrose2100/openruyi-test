# GraphicsMagick

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/GraphicsMagick` |
| 注册用例数 | 2 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_GraphicsMagick | Use librhsm case | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_GraphicsMagick01 | Use librhsm case | pre_test/run_test/post_test | 7 | ✔ |  |  |

### 断言与命令明细

#### oe_test_GraphicsMagick

- 描述：Use librhsm case
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "Error, Please to install GraphicsMagick"
  CHECK_RESULT $? 0 0 "Error, Check photos or command"
  CHECK_RESULT $? 0 0 "Error, Fail to create test.bmp"
```

- 涉及命令：test×1

#### oe_test_GraphicsMagick01

- 描述：Use librhsm case
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Error, Fail to resize image"
  CHECK_RESULT $? 0 0 "Error, resized image not created"
  CHECK_RESULT $? 0 0 "Error, Fail to rotate image"
  CHECK_RESULT $? 0 0 "Error, rotated image not created"
  CHECK_RESULT $? 0 0 "Error, Fail to identify image info"
  CHECK_RESULT $? 0 0 "Error, Fail to batch process images"
  CHECK_RESULT $? 0 0 "Error, batch processed images missing"
```

- 涉及命令：test×3
