# nototools

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/nototools` |
| 注册用例数 | 18 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_nototools_base_notocoverage | TEST notocoverage in nototools options | config_params/pre_test/run_test/post_test | 8 |  |  |  |
| oe_test_nototools_base_noto_lint | TEST  noto_lint.py in nototools options | pre_test/run_test/post_test | 20 |  |  | 60m |
| oe_test_nototools_base_add_vs_cmap | TEST add_vs_cmap.py in nototools options | config_params/pre_test/run_test/post_test | 12 |  |  |  |
| oe_test_nototools_base_create_image | TEST create_image.py in nototools options | config_params/pre_test/run_test/post_test | 14 |  |  |  |
| oe_test_nototools_base_autofix_for_release | TEST autofix_for_release in nototools | config_params/pre_test/run_test/post_test | 4 |  |  |  |
| oe_test_nototools_base_decompose_ttc | TEST decompose_ttc in nototools | config_params/pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_nototools_base_drop_hints | TEST drop_hints in nototools | config_params/pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_nototools_base_dump_otl | TEST dump_otl in nototools | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_nototools_base_fix_khmer_and_lao_coverage | TEST fix_khmer_and_lao_coverage in nototools | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_nototools_base_fix_noto_cjk_thin | TEST fix_noto_cjk_thin in nototools | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_nototools_base_generate_sample_text | TEST generate_sample_text in nototools | pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_nototools_base_generate_website_2_data | TEST generate_website_2_data.py in nototools options | pre_test/run_test/post_test | 21 |  |  |  |
| oe_test_nototools_base_merge_fonts | TEST merge_fonts in nototools | config_params/pre_test/run_test/post_test | 5 |  |  |  |
| oe_test_nototools_base_merge_noto | TEST merge_noto in nototools | config_params/pre_test/run_test/post_test | 1 |  |  | 90m |
| oe_test_nototools_base_scale | TEST scale in nototools | config_params/pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_nototools_base_subset | TEST subset in nototools | config_params/pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_nototools_base_subset_symbols | TEST subset_symbols in nototools | config_params/pre_test/run_test/post_test | 1 |  |  |  |
| oe_test_nototools_base_test_vertical_extents | TEST test_vertical_extents in nototools | pre_test/run_test/post_test | 1 |  |  |  |

### 断言与命令明细

#### oe_test_nototools_base_notocoverage

- 描述：TEST notocoverage in nototools options
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "option: -h error"
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: --ranges error"
  CHECK_RESULT $? 0 0 "option: --text error"
  CHECK_RESULT $? 0 0 "option: --sep ${i} error"
  CHECK_RESULT $? 0 0 "option: --info error"
  CHECK_RESULT $? 0 0 "option: --chars_per_line error"
  CHECK_RESULT $? 0 0 "option: --limit error"
```

- 涉及命令：notocoverage×1

#### oe_test_nototools_base_noto_lint

- 描述：TEST  noto_lint.py in nototools options
- 函数：`pre_test, run_test, post_test`
- 断言（20 条）：

```
  CHECK_RESULT $? 0 0 "option: -h error"
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: --csv error"
  CHECK_RESULT $? 0 0 "option: --info error"
  CHECK_RESULT $? 0 0 "option: --suppress_extrema_details error"
  CHECK_RESULT $? 0 0 "option: --csv_header error"
  CHECK_RESULT $? 0 0 "option: --font_props_file error"
  CHECK_RESULT $? 0 0 "option: --config_file error"
  CHECK_RESULT $? 0 0 "option: ---config lint_spec"
  CHECK_RESULT $? 0 0 "option: --runlog error"
  CHECK_RESULT $? 0 0 "option: --skiplog error"
  CHECK_RESULT $? 0 0 "option: --dump_font_props error"
  ... 共 20 条（其余见源脚本）
```

- 涉及命令：noto_lint.py×1

#### oe_test_nototools_base_add_vs_cmap

- 描述：TEST add_vs_cmap.py in nototools options
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（12 条）：

```
  CHECK_RESULT $? 0 0 "option: -h error"
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: -o error"
  CHECK_RESULT $? 0 0 "option: --output error"
  CHECK_RESULT $? 0 0 "option: -s error"
  CHECK_RESULT $? 0 0 "option: --suffix error"
  CHECK_RESULT $? 0 0 "option: -d error"
  CHECK_RESULT $? 0 0 "option: --dstdir error"
  CHECK_RESULT $? 0 0 "option: -p ${i} error"
  CHECK_RESULT $? 0 0 "option: --presentation ${i} error"
  CHECK_RESULT $? 0 0 "option: -vs error"
  CHECK_RESULT $? 0 0 "option: --vs_added error"
```

- 涉及命令：add_vs_cmap.py×5

#### oe_test_nototools_base_create_image

- 描述：TEST create_image.py in nototools options
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（14 条）：

```
  CHECK_RESULT $? 0 0 "option: -h error"
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: --test error"
  CHECK_RESULT $? 0 0 "option: --codes 1234 -f NotoNaskhArabic -b bold -i italic -st semi-condensed -s 16 -l ar -t png error"
  CHECK_RESULT $? 0 0 "option: --codes 1234 -f NotoNasJPArabic -b heavy -i oblique -st ultra-expanded -s 8 -l JP -t svg error"
  CHECK_RESULT $? 0 0 "option: --codes 1234 -f NotoNas -b normal -i normal -st semi-expanded -s 8 -l mn -t png error"
  CHECK_RESULT $? 0 0 "option: --codes 1234 -f NotoNas -b bold -i italic -st extra-expanded -s 16 -l ar -t svg error"
  CHECK_RESULT $? 0 0 "option: --codes 1234 --font NotoNaskhArabic --bold bold --italic italic --stretch semi-condensed --size 16 --lang ar --type png error"
  CHECK_RESULT $? 0 0 "option: --text 1234 -f NotoNaskhArabic -b ultralight -i italic -st ultra-condensed -s 16 -l ar -t png error"
  CHECK_RESULT $? 0 0 "option: --text 1234 -f NotoNasJPArabic -b light -i oblique -st extra-condensed -s 8 -l JP -t svg error"
  CHECK_RESULT $? 0 0 "option: --text 1234 -f NotoNas -b normal -i normal -st condensed -s 8 -l mn -t png -mh -2 -hm 16 error"
  CHECK_RESULT $? 0 0 "option: --text 1234 -f NotoNas -b bold -i italic -st normal -s 16 -l ar -t svg -mh -2 -hm 16 error"
  ... 共 14 条（其余见源脚本）
```

- 涉及命令：test×11, mkdir×1, create_image.py×1

#### oe_test_nototools_base_autofix_for_release

- 描述：TEST autofix_for_release in nototools
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "option: -h error"
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: --src_root --dst_root error"
  CHECK_RESULT $? 0 0 "option: --src_root --dst_root --save_unmodified error"
```

- 涉及命令：autofix_for_release.py×1

#### oe_test_nototools_base_decompose_ttc

- 描述：TEST decompose_ttc in nototools
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "decompose_ttc.py run error"
```

#### oe_test_nototools_base_drop_hints

- 描述：TEST drop_hints in nototools
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "drop_hints.py run error"
```

#### oe_test_nototools_base_dump_otl

- 描述：TEST dump_otl in nototools
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "dump_otl.py run error"
```

#### oe_test_nototools_base_fix_khmer_and_lao_coverage

- 描述：TEST fix_khmer_and_lao_coverage in nototools
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "fix_khmer_and_lao_coverage.py run error"
```

#### oe_test_nototools_base_fix_noto_cjk_thin

- 描述：TEST fix_noto_cjk_thin in nototools
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "fix_noto_cjk_thin.py run error"
```

#### oe_test_nototools_base_generate_sample_text

- 描述：TEST generate_sample_text in nototools
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "generate_sample_text.py run error"
```

#### oe_test_nototools_base_generate_website_2_data

- 描述：TEST generate_website_2_data.py in nototools options
- 函数：`pre_test, run_test, post_test`
- 断言（21 条）：

```
  CHECK_RESULT $? 0 0 "option: -h error"
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: -c error"
  CHECK_RESULT $? 0 0 "option: --clean error"
  CHECK_RESULT $? 0 0 "option: -d error"
  CHECK_RESULT $? 0 0 "option: --dest error"
  CHECK_RESULT $? 0 0 "option: -pj error"
  CHECK_RESULT $? 0 0 "option: --pretty_json error"
  CHECK_RESULT $? 0 0 "option: -nr error"
  CHECK_RESULT $? 0 0 "option: --no_repo_check error"
  CHECK_RESULT $? 0 0 "option: -nz error"
  CHECK_RESULT $? 0 0 "option: --no_zips error"
  ... 共 21 条（其余见源脚本）
```

- 涉及命令：generate_website_2_data.py×9, generate_website_2_data×1

#### oe_test_nototools_base_merge_fonts

- 描述：TEST merge_fonts in nototools
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "option: -h error"
  CHECK_RESULT $? 0 0 "option: --help error"
  CHECK_RESULT $? 0 0 "option: -d -o error"
  CHECK_RESULT $? 0 0 "option: -d -o -v error"
  CHECK_RESULT $? 0 0 "option: --directory --output --verbose error"
```

- 涉及命令：merge_fonts.py×3

#### oe_test_nototools_base_merge_noto

- 描述：TEST merge_noto in nototools
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "merge_noto.py run error"
```

- 涉及命令：mkdir×1, grep×1

#### oe_test_nototools_base_scale

- 描述：TEST scale in nototools
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "scale.py run error"
```

#### oe_test_nototools_base_subset

- 描述：TEST subset in nototools
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "subset.py run error"
```

#### oe_test_nototools_base_subset_symbols

- 描述：TEST subset_symbols in nototools
- 函数：`config_params, pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "subset_symbols.py run error"
```

#### oe_test_nototools_base_test_vertical_extents

- 描述：TEST test_vertical_extents in nototools
- 函数：`pre_test, run_test, post_test`
- 断言（1 条）：

```
  CHECK_RESULT $? 0 0 "test_vertical_extents.py run error"
```

- 涉及命令：grep×1
