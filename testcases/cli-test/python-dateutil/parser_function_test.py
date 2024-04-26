#!/usr/bin/bash

# Copyright (c) KylinSoft  Co., Ltd. 2023-2024.All rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wuzhaomin
# @Contact   :   wuzhaomin@kylinos.cn
# @Date      :   2024/4/19
# @License   :   Mulan PSL v2
# @Desc      :   test parser
# ############################################

from dateutil import parser  
  
# 解析日期时间字符串  
date_time_str = "Feb 19 2024 16:03:50"  
parsed_datetime = parser.parse(date_time_str)  
  
# 打印解析后的日期时间  
print("Parsed DateTime:", parsed_datetime)  
  
# 检查解析后的日期时间是否符合预期  
expected_year = 2024  
expected_month = 2  
expected_day = 19  
expected_hour = 16  
expected_minute = 3  
expected_second = 50  
  
if (  
    parsed_datetime.year == expected_year and  
    parsed_datetime.month == expected_month and  
    parsed_datetime.day == expected_day and  
    parsed_datetime.hour == expected_hour and  
    parsed_datetime.minute == expected_minute and  
    parsed_datetime.second == expected_second  
):  
    print("Date and time parsed successfully!")  
else:  
    print("Date and time parsing failed!")