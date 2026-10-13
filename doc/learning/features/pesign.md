# pesign

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/pesign` |
| 注册用例数 | 9 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_service_pesign | Test pesign.service restart | pre_test/run_test/post_test | 0 | ✔ |  |  |
| oe_test_pesign_efikeygen | verify the uasge of pesign command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_pesign_efisiglist | verify the uasge of pesign command | pre_test/run_test/post_test | 9 | ✔ |  |  |
| oe_test_pesign_base_01 | verify the uasge of pesign command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pesign_base_02 | verify the uasge of pesign command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_pesign_authvar | verify the uasge of pesign command | pre_test/run_test/post_test | 11 | ✔ |  |  |
| oe_test_pesign_pesign-client_01 | verify the uasge of pesign command | pre_test/run_test/post_test | 10 | ✔ |  |  |
| oe_test_pesign_pesign-client_02 | verify the uasge of pesign command | pre_test/run_test/post_test | 7 | ✔ |  |  |
| oe_test_pesign_pesigcheck | verify the uasge of pesign command | pre_test/run_test/post_test | 9 | ✔ |  |  |

### 断言与命令明细

#### oe_test_service_pesign

- 描述：Test pesign.service restart
- 函数：`pre_test, run_test, post_test`
#### oe_test_pesign_efikeygen

- 描述：verify the uasge of pesign command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check efikeygen -? failed"
  CHECK_RESULT $? 0 0 "Check efikeygen --help failed"
  CHECK_RESULT $? 0 0 "Check efikeygen --usage failed"
  CHECK_RESULT $? 0 0 "Check efikeygen -d -S -n -c -u -k -s failed"
  CHECK_RESULT $? 0 0 "Check efikeygen -d t --signer -c --kernel -u -s failed"
  CHECK_RESULT $? 0 0 "Check efikeygen -d --self-sign --nickname --common-name --url -m --serial failed"
  CHECK_RESULT $? 0 0 "Check efikeygen -d --token --signer --nickname --common-name --module --url --serial failed"
```

- 涉及命令：efikeygen×4

#### oe_test_pesign_efisiglist

- 描述：verify the uasge of pesign command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Get pesign version failed" 1
  CHECK_RESULT $? 0 0 "Check efisiglist -? failed"
  CHECK_RESULT $? 0 0 "Check efisiglist --help failed"
  CHECK_RESULT $? 0 0 "Check efisiglist --usage failed"
  CHECK_RESULT $? 0 0 "Check efisiglist -i -o -a -h -t failed"
  CHECK_RESULT $? 0 0 "Check efisiglist --infile --outfile --add --hash --hash-type failed"
  CHECK_RESULT $? 0 0 "Check efisiglist -i -o -c failed"
  CHECK_RESULT $? 0 0 "Check efisiglist -i -o --certificate failed"
  CHECK_RESULT $? 0 0 "Check efisiglist -i -o -r failed" && test -f ./test
```

- 涉及命令：efisiglist×4

#### oe_test_pesign_base_01

- 描述：verify the uasge of pesign command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check pesign -?  failed"
  CHECK_RESULT $? 0 0 "Check pesign --help  failed"
  CHECK_RESULT $? 0 0 "Check pesign --usage  failed"
  CHECK_RESULT $? 0 0 "Check pesign -i -o -c -s -n -t -a -v -p -P -N failed"
  CHECK_RESULT $? 0 0 "Check pesign --in --out --certificate --sign --certdir -t --nss-token --ascii-armor --verbose --nopadding --nofork --nopadding failed"
  CHECK_RESULT $? 0 0 "Check pesign -h -d -V failed"
  CHECK_RESULT $? 0 0 "Check pesign --hash --digest_type --no-vendor-cert failed"
  CHECK_RESULT $? 0 0 "Check pesign -u failed"
  CHECK_RESULT $? 0 0 "Check pesign --signature-number failed"
  CHECK_RESULT $? 0 0 "Check pesign -i -S failed"
```

- 涉及命令：pesign×5, pgrep×1

#### oe_test_pesign_base_02

- 描述：verify the uasge of pesign command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check pesign -i grubx64.efi.signed --show-signature failed"
  CHECK_RESULT $? 0 0 "Check pesign -r failed"
  CHECK_RESULT $? 0 0 "Check pesign --remove-signature failed"
  CHECK_RESULT $? 0 0 "Check pesign -K failed"
  CHECK_RESULT $? 0 0 "Check pesign --export-pubkey failed"
  CHECK_RESULT $? 0 0 "Check pesign -C failed"
  CHECK_RESULT $? 0 0 "Check pesign --export-cert failed"
  CHECK_RESULT $? 0 0 "Check pesign -D failed"
  CHECK_RESULT $? 0 0 "Check pesign --daemonize failed"
  CHECK_RESULT $? 0 0 "Check pesign -f failed"
  CHECK_RESULT $? 0 0 "Check pesign --force failed"
```

- 涉及命令：pesign×11, pgrep×1

#### oe_test_pesign_authvar

- 描述：verify the uasge of pesign command
- 函数：`pre_test, run_test, post_test`
- 断言（11 条）：

```
  CHECK_RESULT $? 0 0 "Check authvar -?  failed"
  CHECK_RESULT $? 0 0 "Check authvar --help  failed"
  CHECK_RESULT $? 0 0 "Check authvar --usage  failed"
  CHECK_RESULT $? 0 0 "Check authvar -d -n -v -t -S -s -e -N failed"
  CHECK_RESULT $? 0 0 "Check authvar --certdir --name --value --timestamp --sign --set --export --namespace failed"
  CHECK_RESULT $? 0 0 "Check authvar -d -n -v -t -S -a -e failed"
  CHECK_RESULT $? 0 0 "Check authvar -d -n -v -t -S --append -e failed"
  CHECK_RESULT $? 0 0 "Check authvar -d -c -S -n -e failed"
  CHECK_RESULT $? 0 0 "Check authvar -d --clear -S -n -e failed"
  CHECK_RESULT $? 0 0 "Check authvar -f failed"
  CHECK_RESULT $? 0 0 "Check authvar --valuefilefailed"
```

- 涉及命令：authvar×6

#### oe_test_pesign_pesign-client_01

- 描述：verify the uasge of pesign command
- 函数：`pre_test, run_test, post_test`
- 断言（10 条）：

```
  CHECK_RESULT $? 0 0 "Check pesign-client -? failed"
  CHECK_RESULT $? 0 0 "Check pesign-client --help failed"
  CHECK_RESULT $? 0 0 "Check pesign-client --usage failed"
  CHECK_RESULT $? 0 0 "Check pesign-client -c -q -t failed"
  CHECK_RESULT $? 0 0 "Check pesign-client --certificate --is-unlocked --token failed"
  CHECK_RESULT $? 0 0 "Check echo pesign-client -c -u failed"
  CHECK_RESULT $? 0 0 "Check echo pesign-client -c --unlock failed"
  CHECK_RESULT $? 0 0 "Check pesign-client -c -q failed"
  CHECK_RESULT $? 0 0 "Check pesign-client --certificate --is-unlocked failed"
  CHECK_RESULT $? 0 0 "Check pesign-client -k failed"
```

- 涉及命令：pesign-client×3, pesign×1, pgrep×1

#### oe_test_pesign_pesign-client_02

- 描述：verify the uasge of pesign command
- 函数：`pre_test, run_test, post_test`
- 断言（7 条）：

```
  CHECK_RESULT $? 0 0 "Check pesign-client -i -o -c -s failed."
  CHECK_RESULT $? 0 0 "Check pesign-client --infile --outfile -c --sign failed."
  CHECK_RESULT $? 0 0 "Check pesign-client -i -c -F -s -e failed."
  CHECK_RESULT $? 0 0 "Check pesign-client -i -c --pinfile -s -e failed."
  CHECK_RESULT $? 0 0 "Check pesign-client -i -o -c -s -f failed."
  CHECK_RESULT $? 0 0 "Check pesign-client -i -o -c -s --pinfd failed."
  CHECK_RESULT $? 0 0 "Check pesign-client -kill failed"
```

- 涉及命令：pesign-client×6, pesign×2, pgrep×1

#### oe_test_pesign_pesigcheck

- 描述：verify the uasge of pesign command
- 函数：`pre_test, run_test, post_test`
- 断言（9 条）：

```
  CHECK_RESULT $? 0 0 "Check pesigcheck -? failed"
  CHECK_RESULT $? 0 0 "Check pesigcheck --help failed"
  CHECK_RESULT $? 0 0 "Check pesigcheck --usage failed"
  CHECK_RESULT $? 0 0 "Check pesigcheck -i -q -v -n -D failed"
  CHECK_RESULT $? 0 0 "Check pesigcheck --in --quiet --verbose --no-system-db --dbfile failed"
  CHECK_RESULT $? 0 0 "Check pesigcheck -i -q -v -n -X -c failed"
  CHECK_RESULT $? 0 0 "Check pesigcheck --in --quiet --verbose --no-system-db --dbxfile --certfile failed"
  CHECK_RESULT $? 0 0 "Check authvar -i -d failed"
  CHECK_RESULT $? 0 0 "Check authvar -l -d failed"
```

- 涉及命令：pesigcheck×2, authvar×2, pesign×1, pgrep×1
