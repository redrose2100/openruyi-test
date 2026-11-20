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

source "${OET_PATH}/libs/locallibs/common_lib.sh"

# Define configuration information
function common_config_params() {
    TMP_DIR="./tmp"
    TMP_PATH="$(mktemp -d -t dblatex.XXXXXXXXXXXX)"
    TMP_PATH_O1=$TMP_PATH"/O1"
    TMP_PATH_O2=$TMP_PATH"/O2"
}

# Test environment preparation
function common_pre() {
    # The texlive dependency chain of dblatex is large enough to exceed the
    # local dnf timeout when installed in a single transaction, so install it
    # in several smaller batches before pulling in dblatex itself.
    DNF_INSTALL "texlive-basic texlive-latex"
    DNF_INSTALL "texlive-latexrecommended texlive-latexextra"
    DNF_INSTALL "texlive-mathscience texlive-fontsrecommended texlive-texmf"
    DNF_INSTALL "dblatex opensp fonts-dejavu"
    mkdir -p "$TMP_DIR" "$TMP_PATH_O1" "$TMP_PATH_O2"
    [ -e /usr/bin/python ] || ln -s /usr/bin/python3 /usr/bin/python
    # Only the legacy python2-era dblatex ships a bibtex.py that needs these
    # rewrites. The python3 build (openRuyi) has no such file and must not be
    # touched, otherwise ":".join(...) would be downgraded to string.join(...).
    BIBTEX_PY="$(rpm -ql dblatex 2>/dev/null | grep -m1 'bibtex\.py$')"
    if [ -n "${BIBTEX_PY}" ] && [ -f "${BIBTEX_PY}" ]; then
        sed -i 's#string.join(self.bib_path +#":".join(self.bib_path +#g' "${BIBTEX_PY}"
        sed -i 's#\[os.getenv("BIBINPUTS", "")\], ":")#\[os.getenv("BIBINPUTS", "")\])#g' "${BIBTEX_PY}"
        sed -i 's#string.join(self.bst_path +#":".join(self.bst_path +#g' "${BIBTEX_PY}"
        sed -i 's#\[os.getenv("BSTINPUTS", "")\], ":")#\[os.getenv("BSTINPUTS", "")\])#g' "${BIBTEX_PY}"
        sed -i 's#list.sort()#sorted(list)#g' "${BIBTEX_PY}"
        sed -i 's#self.doc.must_compile = 1#self.doc.must_compile = 0#g' "${BIBTEX_PY}"
    fi
    # texlive-base does not exist in openRuyi; texlive-texmf owns texmf.cnf and
    # the exact location depends on the texlive packaging, so look it up.
    TEXMF_CNF="$(find /usr/share/texlive /usr/share/texmf /etc/texmf -name texmf.cnf -type f 2>/dev/null | head -n1)"
    if [ -n "${TEXMF_CNF}" ]; then
        sed -i 's#openout_any = p#openout_any = a#g' "${TEXMF_CNF}"
    fi
}

# Environmental recovery
function common_post() {
    BIBTEX_PY="$(rpm -ql dblatex 2>/dev/null | grep -m1 'bibtex\.py$')"
    if [ -n "${BIBTEX_PY}" ] && [ -f "${BIBTEX_PY}" ]; then
        sed -i 's#\":\".join(self.bib_path +#string.join(self.bib_path +#g' "${BIBTEX_PY}"
        sed -i 's#\[os.getenv("BIBINPUTS", "")\])#\[os.getenv("BIBINPUTS", "")\], ":")#g' "${BIBTEX_PY}"
        sed -i 's#\":\".join(self.bst_path +#string.join(self.bst_path +#g' "${BIBTEX_PY}"
        sed -i 's#\[os.getenv("BSTINPUTS", "")\])#\[os.getenv("BSTINPUTS", "")\], ":")#g' "${BIBTEX_PY}"
        sed -i 's#sorted(list)#list.sort()#g' "${BIBTEX_PY}"
        sed -i 's#self.doc.must_compile = 0#self.doc.must_compile = 1#g' "${BIBTEX_PY}"
    fi
    TEXMF_CNF="$(find /usr/share/texlive /usr/share/texmf /etc/texmf -name texmf.cnf -type f 2>/dev/null | head -n1)"
    if [ -n "${TEXMF_CNF}" ]; then
        sed -i 's#openout_any = a#openout_any = p#g' "${TEXMF_CNF}"
    fi
    rm -rf "${TMP_DIR}" "${TMP_PATH_O1}" "${TMP_PATH_O2}"
    DNF_REMOVE "$@"
}

