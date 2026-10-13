# djvulibre

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/djvulibre` |
| 注册用例数 | 6 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_djvulibre_01 | verification djvulibre's commnd | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_djvulibre_02 | verification djvulibre's commnd | pre_test/run_test/post_test | 17 | ✔ |  |  |
| oe_test_djvulibre_03 | verification djvulibre's commnd | pre_test/run_test/post_test | 22 | ✔ |  |  |
| oe_test_djvulibre_04 | verification djvulibre's commnd | pre_test/run_test/post_test | 25 | ✔ |  |  |
| oe_test_djvulibre_05 | verification djvulibre's commnd | pre_test/run_test/post_test | 21 | ✔ |  |  |
| oe_test_djvulibre_06 | test djvulibre | pre_test/run_test/post_test | 2 | ✔ |  |  |

### 断言与命令明细

#### oe_test_djvulibre_01

- 描述：verification djvulibre's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "Check any2djvu --help failed."
  CHECK_RESULT $? 0 0 "Check any2djvu failed."
  CHECK_RESULT $? 0 0 "Check mesh-preprint.djvu not exist."
  CHECK_RESULT $? 0 0 "Check any2djvu test.djvu failed."
  CHECK_RESULT $? 0 0 "Check test.djvu not exist."
  CHECK_RESULT $? 0 0 "Check bzz --help failed."
  CHECK_RESULT $? 0 0 "Check bzz -e failed."
  CHECK_RESULT $? 0 0 "Check bzz -d failed."
  CHECK_RESULT $? 0 0 "Check c44 --help failed."
  CHECK_RESULT $? 0 0 "Check c44 -crcbdelay failed."
  CHECK_RESULT $? 0 0 "Check test1.djvu not exist."
  CHECK_RESULT $? 0 0 "Check c44 -crcbfull failed."
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：test×6, c44×4, bzz×3

#### oe_test_djvulibre_02

- 描述：verification djvulibre's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（17 条）：

```
  CHECK_RESULT $? 0 0 "Check cjb2 --help failed."
  CHECK_RESULT $? 0 0 "Check cjb2 -lossy failed."
  CHECK_RESULT $? 0 0 "Check cjb2_1.djvu not exist."
  CHECK_RESULT $? 0 0 "Check cjb2 -clean failed."
  CHECK_RESULT $? 0 0 "Check cjb2_2.djvu not exist."
  CHECK_RESULT $? 0 0 "Check cjb2 -verbose failed."
  CHECK_RESULT $? 0 0 "Check cjb2_3.djvu not exist."
  CHECK_RESULT $? 0 0 "Check cpaldjvu --help failed."
  CHECK_RESULT $? 0 0 "Check cpaldjvu -colors failed."
  CHECK_RESULT $? 0 0 "Check cpal_1 not exist."
  CHECK_RESULT $? 0 0 "Check cpaldjvu -dpi failed."
  CHECK_RESULT $? 0 0 "Check cpal_2 not exist."
  ... 共 17 条（其余见源脚本）
```

- 涉及命令：test×7, cpaldjvu×4, cjb2×3

#### oe_test_djvulibre_03

- 描述：verification djvulibre's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（22 条）：

```
  CHECK_RESULT $? 0 0 "Check test.djvu not exist."
  CHECK_RESULT $? 0 0 "Check ddjvu --help failed."
  CHECK_RESULT $? 0 0 "Check ddjvu -verbose failed."
  CHECK_RESULT $? 0 0 "Check ddjvu1 not exist."
  CHECK_RESULT $? 0 0 "Check ddjvu -format=pgm failed."
  CHECK_RESULT $? 0 0 "Check ddjvu1.pgm not exist."
  CHECK_RESULT $? 0 0 "Check ddjvu -aspect=no failed."
  CHECK_RESULT $? 0 0 "Check ddjvu2 not exist."
  CHECK_RESULT $? 0 0 "Check ddjvu -mode=mask failed."
  CHECK_RESULT $? 0 0 "Check ddjvu3 not exist."
  CHECK_RESULT $? 0 0 "Check ddjvu -mode=foreground failed."
  CHECK_RESULT $? 0 0 "Check ddjvu4 not exist."
  ... 共 22 条（其余见源脚本）
```

- 涉及命令：test×10, ddjvu×7, djvmcvt×2

#### oe_test_djvulibre_04

- 描述：verification djvulibre's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（25 条）：

```
  CHECK_RESULT $? 0 0 "Check test.djvu not exist."
  CHECK_RESULT $? 0 0 "Check djvudump failed."
  CHECK_RESULT $? 0 0 "Check djvuextract --help failed."
  CHECK_RESULT $? 0 0 "Check djvumake --help failed."
  CHECK_RESULT $? 0 0 "Check djvups --help failed."
  CHECK_RESULT $? 0 0 "Check djvups -color=yes failed."
  CHECK_RESULT $? 0 0 "Check djvups1.ps not exist."
  CHECK_RESULT $? 0 0 "Check djvups -color=no failed."
  CHECK_RESULT $? 0 0 "Check djvups2.ps not exist."
  CHECK_RESULT $? 0 0 "Check djvups -verbose failed."
  CHECK_RESULT $? 0 0 "Check djvups.ps not exist."
  CHECK_RESULT $? 0 0 "Check djvups -format=ps failed."
  ... 共 25 条（其余见源脚本）
```

- 涉及命令：test×11, djvups×10

#### oe_test_djvulibre_05

- 描述：verification djvulibre's commnd
- 函数：`pre_test, run_test, post_test`
- 断言（21 条）：

```
  CHECK_RESULT $? 0 0 "Check test.djvu not exist."
  CHECK_RESULT $? 0 0 "Check djvused --help failed."
  CHECK_RESULT $? 0 0 "Check djvused -e failed."
  CHECK_RESULT $? 0 0 "Check file.dsed not exist."
  CHECK_RESULT $? 0 0 "Check djvused -f failed."
  CHECK_RESULT $? 0 0 "Check djvuserve help failed."
  CHECK_RESULT $? 0 0 "Check djvused failed."
  CHECK_RESULT $? 0 0 "Check djvutoxml --help failed."
  CHECK_RESULT $? 0 0 "Check djvutoxml --with-anno failed."
  CHECK_RESULT $? 0 0 "Check djvutoxml not exist."
  CHECK_RESULT $? 0 0 "Check djvutoxml --with-text failed."
  CHECK_RESULT $? 0 0 "Check djvutoxml1 not exist."
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：test×8, djvutxt×3

#### oe_test_djvulibre_06

- 描述：test djvulibre
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "djvm failure"
  CHECK_RESULT $? 0 0 "output.djvu not exist"
```

- 涉及命令：djvm×1, test×1
