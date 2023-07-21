#!/usr/bin/env python3

# Copyright (c) 2022 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2022-11-17
# @License   :   Mulan PSL v2
# @Desc      :   gettext Basic Functions test
# ############################################

import os
import gettext

_ = gettext.gettext

LOCALE_DIR = os.path.abspath("locale")
gettext.bindtextdomain("test_script", LOCALE_DIR)
gettext.textdomain("test_script")

def LOG_INFO(info):
    print(info)

def pre_test():
    LOG_INFO(_("Start environment preparation."))
    DNF_INSTALL("gettext")
    local = os.popen("localectl status | grep System | awk -F '=' '{print $2}'").read().strip()
    os.system("localectl set-locale LANG=en_US.UTF-8")
    LOG_INFO(_("End of environmental preparation!"))

def run_test():
    LOG_INFO(_("Start testing..."))
    with open("test.py", "w") as f:
        f.write("""
import os
import gettext

_ = gettext.gettext

string = _("test")

LOCALE_DIR = os.path.abspath("locale")
gettext.bindtextdomain("test_script", LOCALE_DIR)
gettext.textdomain("test_script")


if __name__ == "__main__":
    print(_("hello world"))
""")
    os.system("xgettext -k_ -o test_script.po test.py")
    CHECK_RESULT(0, 0, _("Failed to execute the python file"))
    os.system("sed -i 's/charset=CHARSET/charset=UTF-8/g' test_script.po")
    os.system("sed -i 's/msgstr \"\"/msgstr \"%s\"/g' test_script.po" % _("你好"))
    CHECK_RESULT(0, 0, _("Description Failed to modify the test_script.po file"))
    os.makedirs("locale/zh_CN/LC_MESSAGES", exist_ok=True)
    os.makedirs("locale/en_US/LC_MESSAGES", exist_ok=True)
    os.system("msgfmt -o locale/zh_CN/LC_MESSAGES/test_script.mo test_script.po")
    CHECK_RESULT(0, 0, _("Can't generate mo file"))
    os.environ["LANG"] = "zh_CN.UTF-8"
    result = os.popen("python3 test.py").read().strip()
    CHECK_RESULT(result, _("你好"), _("test.py cannot be executed properly or Unable to filter necessary characters"))
    os.system("xgettext -k_ -o us.po test.py")
    CHECK_RESULT(0, 0, _("Unable to generate us.po"))
    os.system("sed -i 's/charset=CHARSET/charset=UTF-8/g' us.po")
    os.system("sed -i 's/msgstr \"\"/msgstr \"%s\"/g' us.po" % _("hello"))
    os.system("msgfmt -o locale/en_US/LC_MESSAGES/test_script.mo us.po")
    CHECK_RESULT(0, 0, _("mo files cannot be generated using us.po"))
    os.environ["LANG"] = "en_US.UTF-8"
    result = os.popen("python3 test.py").read().strip()
    CHECK_RESULT(result, _("hello"), _("test.py cannot be executed properly or Unable to filter necessary characters"))
    LOG_INFO(_("Finish test!"))

def post_test():
    LOG_INFO(_("start environment cleanup."))
    DNF_REMOVE("gettext")
    os.remove("test.py")
    os.remove("test_script.po")
    os.remove("us.po")
    os.system("rm -rf locale/")
    os.system("localectl set-locale LANG=%s" % local)
    LOG_INFO(_("Finish environment cleanup!"))

main()
