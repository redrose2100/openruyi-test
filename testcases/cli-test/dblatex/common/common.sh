#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Songfurong
# @Contact   :   2597578239@qq.com
# @Date      :   2022/12/16
# @License   :   Mulan PSL v2
# @Desc      :   mtx common prepare
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Define configuration information
function common_config_params() {
    TMP_DIR="./tmp"
    TMP_PATH_O1=$TMP_PATH"/O1"
    TMP_PATH_O2=$TMP_PATH"/O2"
    TMP_PATH="$(mktemp -d -t dblatex.XXXXXXXXXXXX)"
}

# Test environment preparation
function common_pre() {
    DNF_INSTALL "dblatex opensp dejavu-fonts"
    mkdir -p $TMP_DIR $TMP_PATH_O1 $TMP_PATH_O2
    ln -s /usr/bin/python3 /usr/bin/python
    sed -i 's#string.join(self.bib_path +#":".join(self.bib_path +#g' $(rpm -ql dblatex | grep bibtex.py)
    sed -i 's#\[os.getenv("BIBINPUTS", "")\], ":")#\[os.getenv("BIBINPUTS", "")\])#g' $(rpm -ql dblatex | grep bibtex.py)
    sed -i 's#string.join(self.bst_path +#":".join(self.bst_path +#g' $(rpm -ql dblatex | grep bibtex.py)
    sed -i 's#\[os.getenv("BSTINPUTS", "")\], ":")#\[os.getenv("BSTINPUTS", "")\])#g' $(rpm -ql dblatex | grep bibtex.py)
    sed -i 's#list.sort()#sorted(list)#g' $(rpm -ql dblatex | grep bibtex.py)
    sed -i 's#openout_any = p#openout_any = a#g' $(rpm -ql texlive-base | grep texmf-dist/web2c)/texmf.cnf
    sed -i '271s#self.doc.must_compile = 1#self.doc.must_compile = 0#g' $(rpm -ql dblatex | grep bibtex.py)
}

# Environmental recovery
function common_post() {
    sed -i 's#":".join(self.bib_path +#string.join(self.bib_path +#g' $(rpm -ql dblatex | grep bibtex.py)
    sed -i 's#\[os.getenv("BIBINPUTS", "")\])#\[os.getenv("BIBINPUTS", "")\], ":")#g' $(rpm -ql dblatex | grep bibtex.py)
    sed -i 's#":".join(self.bst_path +#string.join(self.bst_path +#g' $(rpm -ql dblatex | grep bibtex.py)
    sed -i 's#\[os.getenv("BSTINPUTS", "")\])#\[os.getenv("BSTINPUTS", "")\], ":")#g' $(rpm -ql dblatex | grep bibtex.py)
    sed -i 's#sorted(list)#list.sort()#g' $(rpm -ql dblatex | grep bibtex.py)
    sed -i 's#openout_any = a#openout_any = p#g' $(rpm -ql texlive-base | grep texmf-dist/web2c)/texmf.cnf
    sed -i '271s#self.doc.must_compile = 0#self.doc.must_compile = 1#g' $(rpm -ql dblatex | grep bibtex.py)
    rm -rf ${TMP_DIR} ${TMP_PATH_O1} ${TMP_PATH_O2}
    DNF_REMOVE
}

