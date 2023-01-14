| 测试套            | 用例名 | 测试级别 | 测试类型 | 用例描述                                        | 节点数 | 预置条件                            | 操作步骤                               | 预期结果 | 是否自动化 | 备注  |
|----------------| ------ | -------- | -------- |---------------------------------------------| ------ |---------------------------------|------------------------------------|------|-------|-----|
| netlabel_tools |oe_test_netlabel_tools_netlabelctl_01 | 单元测试 | 功能测试 | 测试netlabel软件netlabelctl命令及参数用法      | 1 | 安装二进制包：dnf install -y netlabel  | 1、-h：打印帮助信息，执行命令：netlabelctl -h 2>&1 ｜ grep 'NetLabel Control Utility'<br/>2、-V：打印版本信息，执行命令：netlabelctl -V 2>&1 ｜ grep 'NetLabel Control Utility'<br/>3、-p：尝试使输出可读，执行命令：netlabelctl -p map list 2>&1 ｜ grep 'Configured NetLabel'<br/>4、calipso：添加calipso 域的实例，执行命令： netlabelctl calipso add pass doi:11<br/>5、unlbl accept：开 unlbl域，执行命令： netlabelctl -p unlbl accept on<br>6、unlbl accept：关 unlbl域，执行命令： netlabelctl unlbl accept off<br/>7、unlbl list列出unlbl域列表，执行命令： netlabelctl unlbl list 2>&1 ｜ grep 'accept'<br/>8、-v：启用额外输出，执行命令：netlabelctl -v mgmt version 2>&1 ｜ grep '[[:digit:]]'<br/>9、-v：查看mgmt protocols 信息，执行命令：netlabelctl -v mgmt protocols 2>&1 ｜ grep 'UNLABELED,CIPSOv4,CALIPSO'<br/>10、mgmt：打印版本信息，执行命令：netlabelctl mgmt version 2>&1 ｜ grep '[[:digit:]]'<br/> | 1、帮助信息打印成功<br>2、版本信息打印成功<br/>3、命令执行出成功<br/>4、域添加成功<br/>5、域启动成功<br/>6、域关闭成功<br>7、unlbl域查看成功<br/>8、命令执行出成功<br/>9、查看mgmt protocols 信息<br/>10、查看版本信息成功<br/> | 是     |     |
| netlabel_tools |oe_test_netlabel_tools_netlabelctl_02 | 单元测试 | 功能测试 | 测试netlabel软件netlabelctl命令及参数用法 | 1 | 安装二进制包：dnf install -y netlabel | 1、cipsov4  CALIPSO/IPv6 数据包处理，添加，执行命令： netlabelctl cipsov4 add pass doi:16 tags:1 <br/>2、cipsov4  CALIPSO/IPv6 数据包处理，删除，执行命令： netlabelctl cipsov4 del doi:16 <br/>3、cipsov4  CALIPSO/IPv6 数据包处理，添加，执行命令： netlabelctl cipsov4 add trans doi:8 tags:1 levels:0=0,1=1 categories:0=1,1=0 <br/>4、cipsov4  CALIPSO/IPv6 数据包处理，删除，执行命令：或者 netlabelctl cipsov4 del doi:8 <br/>5、cipsov4  CALIPSO/IPv6 数据包处理，添加，执行命令： netlabelctl cipsov4 add local doi:9 <br/>6、cipsov4  CALIPSO/IPv6 数据包处理，删除，执行命令： netlabelctl cipsov4 del doi:9 <br/>7、cipsov4  CALIPSO/IPv6 数据包处理，展示，执行命令： netlabelctl -p cipsov4 list 2>&1 ｜ grep 'Configured' <br/>8、cipsov4  CALIPSO/IPv6 数据包处理，删除，执行命令： netlabelctl cipsov4 del doi:8<br/><br/>9、cipso CIPSO/IPv4 数据包处理，添加，执行命令：netlabelctl cipso add pass doi:16 tags:1<br/>1、cipso CIPSO/IPv4 数据包处理，展示，执行命令：netlabelctl -p cipso list -v -t 10 2>&1 ｜ grep 'Configured CIPSO'<br/>10、cipso CIPSO/IPv4 数据包处理，删除，执行命令：netlabelctl cipso del doi:16<br/> | 1、cipsov4  数据包添加成功 <br>2、cipsov4  数据包删除成功<br/>3、cipsov4  数据包添加成功<br/>4、cipsov4  数据包删除成功<br/>5、cipsov4  数据包添加命令执行成功<br/>6、cipsov4  数据包删除功<br/>7、cipsov4  数据包展示成功<br/>8、cipsov4  数据包删除成功<br/>9、cipso CIPSO/IPv4 数据包处理添加成功<br/>10、cipso CIPSO/IPv4 数据包处理删除成功<br/> | 是 | |
| netlabel_tools |oe_test_netlabel_tools_netlabelctl_03 | 单元测试 | 功能测试 | 测试netlabel软件netlabelctl命令及参数用法 | 1 | 安装二进制包：dnf install -y netlabel | 1、mgmt：打印mgmt protocols信息，执行命令： netlabelctl mgmt protocols 2>&1 ｜ grep 'UNLABELED'<br>2、CALIPSO/IPv6 数据包处理，添加，执行命令：netlabelctl calipso add pass doi:11<br/>3、CALIPSO/IPv6 数据包处理，删除，执行命令：netlabelctl calipso del doi:11	<br/>4、unlbl add 命令执行失败。issue：[](https://gitee.com/src-openeuler/netlabel_tools/issues/I689L6?from=project-issue) | 1、输出信息成功<br>2、数据包添加成功<br>3、数据包删除成功<br>4、命令执行成功 | 是 | |




.

 





