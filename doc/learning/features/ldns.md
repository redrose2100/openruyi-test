# ldns

> 本文档由 `case_extract.json` 脚本生成（骨架），含元信息、环境约束、用例清单（@Desc/断言/命令），**全部为代码事实**。测试域内代表性特性的函数级深挖见 [`08-测试特性树`](../08-测试特性树.md)。

## 元信息

| 项 | 值 |
|----|----|
| 测试域 | 命令行与服务域（cli-test） |
| 套件路径 | `$OET_PATH/testcases/cli-test/ldns` |
| 注册用例数 | 21 |
| 环境约束 | 无 |

## 用例清单（测试点）

| 用例名 | 描述 | 函数 | 断言数 | 装包 | 远端 | 超时 |
|--------|------|------|-------:|------|------|------|
| oe_test_ldns | Test ldns package installation and command availability | pre_test/run_test/post_test | 6 | ✔ |  |  |
| oe_test_ldns_drill | Test drill command - DNS lookup tool | pre_test/run_test/post_test | 8 | ✔ |  |  |
| oe_test_ldns_mx | Test ldns-mx command - MX record query | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ldns_resolver | Test ldns-resolver command - parse resolver configuration | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ldns_test-edns | Test ldns-test-edns command - EDNS support testing | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ldns_read-zone | Test ldns-read-zone command - read zone files | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ldns_compare-zones | Test ldns-compare-zones command - compare zone files | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ldns_gen-zone | Test ldns-gen-zone command - generate zone files | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ldns_zsplit | Test ldns-zsplit command - split zone files | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_ldns_zcat | Test ldns-zcat command - concatenate zone files | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ldns_keygen | Test ldns-keygen command - generate DNSSEC keys | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ldns_signzone | Test ldns-signzone command - sign zone files with DNSSEC | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_ldns_verify-zone | Test ldns-verify-zone command - verify DNSSEC signed zones | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ldns_key2ds | Test ldns-key2ds command - convert DNSKEY to DS records | pre_test/run_test/post_test | 5 | ✔ |  |  |
| oe_test_ldns_nsec3-hash | Test ldns-nsec3-hash command - compute NSEC3 hashes | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ldns_rrsig | Test ldns-rrsig command - inspect RRSIG records | pre_test/run_test/post_test | 3 | ✔ |  |  |
| oe_test_ldns_chaos | Test ldns-chaos command - query CHAOS class records | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_ldns_config | Test ldns-config command - show compile configuration | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ldns_keyfetcher | Test ldns-keyfetcher command - fetch DNSKEY records | pre_test/run_test/post_test | 2 | ✔ |  |  |
| oe_test_ldns_revoke | Test ldns-revoke command - revoke DNSSEC keys | pre_test/run_test/post_test | 4 | ✔ |  |  |
| oe_test_ldns_walk | Test ldns-walk command - walk NSEC records | pre_test/run_test/post_test | 3 | ✔ |  |  |

### 断言与命令明细

#### oe_test_ldns

- 描述：Test ldns package installation and command availability
- 函数：`pre_test, run_test, post_test`
- 断言（6 条）：

```
  CHECK_RESULT $? 0 0 "ldns packages are not installed"
  CHECK_RESULT $? 0 0 "failed to get ldns rpm version"
  CHECK_RESULT $? 0 0 "failed to get ldns pkg-config version"
  CHECK_RESULT $? 0 0 "version mismatch: rpm=${rpm_version}, pkg-config=${pkg_version}"
  CHECK_RESULT $? 0 0 "ldns-version does not report the expected version"
  CHECK_RESULT $? 0 0 "${command_name} command is not available"
```

- 涉及命令：rpm×1, grep×1, command×1

#### oe_test_ldns_drill

- 描述：Test drill command - DNS lookup tool
- 函数：`pre_test, run_test, post_test`
- 断言（8 条）：

```
  CHECK_RESULT $? 0 0 "drill -h does not show usage information"
  CHECK_RESULT $? 0 0 "drill failed to resolve A record for ${TEST_DOMAIN}"
  CHECK_RESULT $? 0 0 "drill failed to query MX record for ${TEST_DOMAIN}"
  CHECK_RESULT $? 0 0 "drill failed to query NS record for ${TEST_DOMAIN}"
  CHECK_RESULT $? 0 0 "drill failed to query SOA record for ${TEST_DOMAIN}"
  CHECK_RESULT $? 0 0 "drill failed to query AAAA record for ${TEST_DOMAIN}"
  CHECK_RESULT $? 0 0 "drill -V 5 does not produce verbose output"
  CHECK_RESULT $? 0 0 "drill -T failed to trace from root servers"
```

- 涉及命令：drill×2

#### oe_test_ldns_mx

- 描述：Test ldns-mx command - MX record query
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ldns-mx does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-mx failed to query MX record for ${TEST_DOMAIN}"
  CHECK_RESULT $? 0 0 "ldns-mx failed to query MX record for ${TEST_DOMAIN_2}"
```

#### oe_test_ldns_resolver

- 描述：Test ldns-resolver command - parse resolver configuration
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ldns-resolver -h does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-resolver failed to parse /etc/resolv.conf"
  CHECK_RESULT $? 0 0 "ldns-resolver output does not contain resolver properties"
```

- 涉及命令：ldns-resolver×1

#### oe_test_ldns_test-edns

- 描述：Test ldns-test-edns command - EDNS support testing
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ldns-test-edns -h does not show usage"
  CHECK_RESULT $? 0 0 "No nameserver found in /etc/resolv.conf"
  CHECK_RESULT $? 0 0 "ldns-test-edns failed to test EDNS support for ${DNS_CACHE_IP}"
```

- 涉及命令：ldns-test-edns×1, test×1

#### oe_test_ldns_read-zone

- 描述：Test ldns-read-zone command - read zone files
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ldns-read-zone -h does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-read-zone does not output SOA record with zone origin"
  CHECK_RESULT $? 0 0 "ldns-read-zone -c does not output NS or A records"
  CHECK_RESULT $? 0 0 "ldns-read-zone -s failed to strip DNSSEC data"
```

- 涉及命令：ldns-read-zone×3, mkdir×1

#### oe_test_ldns_compare-zones

- 描述：Test ldns-compare-zones command - compare zone files
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ldns-compare-zones -h does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-compare-zones failed to report 0 differences for identical zones"
  CHECK_RESULT $? 0 0 "ldns-compare-zones failed to report differences for modified zones"
```

- 涉及命令：mkdir×1, ldns-compare-zones×1

#### oe_test_ldns_gen-zone

- 描述：Test ldns-gen-zone command - generate zone files
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ldns-gen-zone -h does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-gen-zone failed to generate DNS records"
  CHECK_RESULT $? 0 0 "ldns-gen-zone -a 5 failed to add artificial NS records"
  CHECK_RESULT $? 0 0 "ldns-gen-zone -o failed to set the origin"
```

- 涉及命令：ldns-gen-zone×3, mkdir×1

#### oe_test_ldns_zsplit

- 描述：Test ldns-zsplit command - split zone files
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "ldns-zsplit does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-zsplit failed to split zone file"
  CHECK_RESULT $? 0 0 "ldns-zsplit did not create zone.db.000"
  CHECK_RESULT $? 0 0 "ldns-zsplit -n 2 failed to split zone file"
  CHECK_RESULT $? 0 0 "ldns-zsplit -n 2 did not create zone.db.000 and zone.db.001"
```

- 涉及命令：mkdir×1, test×1, ldns-zsplit×1

#### oe_test_ldns_zcat

- 描述：Test ldns-zcat command - concatenate zone files
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ldns-zcat -h does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-zsplit failed to split zone file for zcat test"
  CHECK_RESULT $? 0 0 "ldns-zcat output does not contain SOA record with zone origin"
  CHECK_RESULT $? 0 0 "ldns-zcat failed to concatenate specific split files"
```

- 涉及命令：mkdir×1, ldns-zcat×1, ldns-zsplit×1

#### oe_test_ldns_keygen

- 描述：Test ldns-keygen command - generate DNSSEC keys
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ldns-keygen -h does not show usage information"
  CHECK_RESULT $? 0 0 "RSA SHA1 key file was not created or does not contain DNSKEY record"
  CHECK_RESULT $? 0 0 "RSA SHA256 key file was not created or does not contain DNSKEY record"
  CHECK_RESULT $? 0 0 "KSK key file was not created or does not contain DNSKEY record with flag 257"
```

- 涉及命令：mkdir×1, ldns-keygen×1, grep×1

#### oe_test_ldns_signzone

- 描述：Test ldns-signzone command - sign zone files with DNSSEC
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "ldns-signzone -h does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-signzone failed to sign zone"
  CHECK_RESULT $? 0 0 "signed.zone was not created or does not contain RRSIG records"
  CHECK_RESULT $? 0 0 "ldns-signzone -n failed to sign zone"
  CHECK_RESULT $? 0 0 "ldns-signzone -n output does not contain RRSIG records"
```

- 涉及命令：ldns-signzone×3, mkdir×1

#### oe_test_ldns_verify-zone

- 描述：Test ldns-verify-zone command - verify DNSSEC signed zones
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ldns-verify-zone -h does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-verify-zone failed to verify signed zone"
  CHECK_RESULT $? 0 0 "ldns-verify-zone with -k failed to verify signed zone"
```

- 涉及命令：ldns-verify-zone×2, mkdir×1, ldns-signzone×1

#### oe_test_ldns_key2ds

- 描述：Test ldns-key2ds command - convert DNSKEY to DS records
- 函数：`pre_test, run_test, post_test`
- 断言（5 条）：

```
  CHECK_RESULT $? 0 0 "ldns-key2ds -h does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-key2ds -f -1 failed to convert DNSKEY to DS"
  CHECK_RESULT $? 0 0 "ldns-key2ds -1 did not produce DS record for example.test"
  CHECK_RESULT $? 0 0 "ldns-key2ds -f -2 failed to convert DNSKEY to DS"
  CHECK_RESULT $? 0 0 "ldns-key2ds -2 did not produce DS record for example.test"
```

- 涉及命令：ldns-key2ds×3, grep×2, mkdir×1

#### oe_test_ldns_nsec3-hash

- 描述：Test ldns-nsec3-hash command - compute NSEC3 hashes
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ldns-nsec3-hash -h does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-nsec3-hash did not produce a 32-char Base32hex hash"
  CHECK_RESULT $? 0 0 "ldns-nsec3-hash -t 5 did not produce a valid hash"
  CHECK_RESULT $? 0 0 "ldns-nsec3-hash -s ABCD did not produce a valid hash"
```

- 涉及命令：ldns-nsec3-hash×3, mkdir×1

#### oe_test_ldns_rrsig

- 描述：Test ldns-rrsig command - inspect RRSIG records
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ldns-rrsig does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-rrsig failed to query RRSIG for root zone"
  CHECK_RESULT $? 0 0 "ldns-rrsig failed to query RRSIG SOA for root zone"
```

#### oe_test_ldns_chaos

- 描述：Test ldns-chaos command - query CHAOS class records
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "ldns-chaos does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-chaos produced no recognizable output for ${NS_NAME}"
```

#### oe_test_ldns_config

- 描述：Test ldns-config command - show compile configuration
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ldns-config -h does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-config --version does not output version information"
  CHECK_RESULT $? 0 0 "ldns-config --cflags does not output include flags"
  CHECK_RESULT $? 0 0 "ldns-config --libs does not output link flags"
```

- 涉及命令：ldns-config×1

#### oe_test_ldns_keyfetcher

- 描述：Test ldns-keyfetcher command - fetch DNSKEY records
- 函数：`pre_test, run_test, post_test`
- 断言（2 条）：

```
  CHECK_RESULT $? 0 0 "ldns-keyfetcher -h does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-keyfetcher produced no recognizable output for root zone"
```

- 涉及命令：mkdir×1, ldns-keyfetcher×1

#### oe_test_ldns_revoke

- 描述：Test ldns-revoke command - revoke DNSSEC keys
- 函数：`pre_test, run_test, post_test`
- 断言（4 条）：

```
  CHECK_RESULT $? 0 0 "ldns-revoke does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-revoke -n failed to output revoked DNSKEY record"
  CHECK_RESULT $? 0 0 "ldns-revoke did not print revoked confirmation"
  CHECK_RESULT $? 0 0 "ldns-revoke corrupted the key file (no DNSKEY record)"
```

- 涉及命令：mkdir×1, ldns-revoke×1

#### oe_test_ldns_walk

- 描述：Test ldns-walk command - walk NSEC records
- 函数：`pre_test, run_test, post_test`
- 断言（3 条）：

```
  CHECK_RESULT $? 0 0 "ldns-walk does not show usage information"
  CHECK_RESULT $? 0 0 "ldns-walk -version does not output version information"
  CHECK_RESULT $? 0 0 "ldns-walk produced no recognizable output for ${TEST_ZONE}"
```

- 涉及命令：ldns-walk×1
