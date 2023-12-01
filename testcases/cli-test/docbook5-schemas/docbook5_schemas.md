| 测试套 | 用例名 | 测试级别 | 测试类型 | 用例描述 | 节点数 | 预置条件 | 操作步骤 | 预期输出（注：空也为预期输出) | 是否自动化 | 备注  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| docbook5_schemas | oe\_test\_docbook5_schemas | 模块测试 | 功能测试 | 测试docbook5\_schemas软件包docbook5\_schemas命令相关功能 | 1   | 1.安装docbook5_schemas软件包<br><br>2.需要xml文件 | 1.测试 1.执行命令db4-entities.pl /etc/xml/docbook-5.xml | 1.有"version="相关的日志打印 | 是   |     |
