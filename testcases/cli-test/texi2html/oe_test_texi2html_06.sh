#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   liaoyuankun
#@Contact   :   1561203725@qq.com
#@Date      :   2023/8/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "texi2html" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "texi2html"
    LOG_INFO "End to prepare the test environment"
}
##########################################################
#Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.32), passed through in regex; marked by <-- HERE in m/^\s+@([^\s\{\}\@]+)({ <-- HERE })?\s*/ at /usr/bin/texi2html line 33105.
#Usage: texi2html  [OPTIONS] TEXINFO-FILE
#Translates Texinfo source documentation to HTML.
# Option   Type  Default  Description
# --conf-dir=s            append $s to the init file directories
# --css-include=s         use css file $s
# --css-ref=s             generate reference to the CSS URL $s
# --debug=i  0            output HTML with debuging information
# --disable-encoding      
#    do not output accented and special characters
#                                in Info output based on @documentencoding.
# --docbook               output Docbook XML rather than HTML.
# --document-language=s    use $s as document language
# --enable-encoding    0  override --disable-encoding (default in Info).
# --error-limit|e=i  1000  quit after NUM errors (default 1000).
# --fill-column|f=i       break Info lines at NUM characters (default 72).
# --footnote-style|s=s    output footnotes separate|end
# --force|F!   1          preserve output even if errors.
# --headers!              output navigation headers for each section
# --help|h:i              print help and exit
# --I=s                   append $s to the @include search path
# --ifdocbook!            expand ifdocbook and docbook sections
# --ifhtml!               expand ifhtml and html sections
# --ifinfo!               expand ifinfo
# --ifplaintext!          expand ifplaintext sections
# --iftex!                expand iftex and tex sections
# --ifxml!                expand ifxml and xml sections
# --info                  output Info rather than HTML.
# --init-file=s           load init file $s
# --internal-links=s      produce list of internal links in FILE.
# --l2h!                  if set, uses latex2html for @math and @tex
# --macro-expand|E=s      output macro expanded source in <file>
# --menu!   1             output Texinfo menus
# --no-validate|no-pointer-validate      
#    suppress node cross-reference validation
# --no-warn    0          suppress warnings (but not errors).
# --node-files!   0       produce one file per node for cross references
# --number-footnotes!   1  output footnote numbers.
# --number-sections!   1  output chapter and sectioning numbers.
# --output-indent=i       This option used to indent XML, it is ignored
# --output|out|o=s        output goes to $s (directory if split)
# --P=s                   prepend $s to the @include search path
# --paragraph-indent|p=s    
#    indent Info paragraphs by VAL spaces (default 3).
#                              If VAL is `none', do not indent; if VAL is
#                                `asis', preserve existing indentation.
# --plaintext             output plain text rather than HTML.
# --prefix=s              use as prefix for output files, instead of <docname>
# --program=s             Call as $s, setting corresponding defaults
# --raw-text              output raw text rather than HTML.
# --short-ext!   0        use "htm" extension for output HTML files
# --short-ref!   0        if set, references are without section numbers
# --split=s               
#    split document on section|chapter|node else no splitting
# --split-size=s  300000  split Info files at size s (default 300000).
# --toc-file=s            use $s as ToC file, instead of <docname>_toc.html
# --toc-links!   0        create links from headings to toc entries
# --top-file=s            use $s as top file, instead of <docname>.html
# --transliterate-file-names!   1  produce file names in ASCII transliteration
# --use-nodes!            use nodes for sectioning
# --verbose|v!            print progress info to stdout
# --version               print version and exit
# --xml                   output Texinfo XML rather than HTML.
#Note: 'Options' may be abbreviated. -- prefix may be replaced by a single -.
#'Type' specifications mean:
# <none>| !    no argument: variable is set to 1 on -foo (or, to 0 on -nofoo)
#    =s | :s   mandatory (or, optional)  string argument
#    =i | :i   mandatory (or, optional)  integer argument
#
#Send bugs and suggestions to <texi2html-bug@nongnu.org>
#

##########################################################
function run_test() {
    LOG_INFO "Start to run testcase:oe_test_texi2html."


    ### -css-ref ###
    texi2html -css-ref=default.css test && grep "default.css" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: -css-ref No Pass"
    rm -f test.html
    ### -conf-dir ###
    texi2html -conf-dir=example.conf test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -conf-dir No Pass"
    rm -f test.html
    ### --split=s ###
    texi2html -split=section test && find . -name "test" | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: -split=section No Pass"
    rm -rf test
    ### --split=s ###
    texi2html -split=chapter test && find . -name "test" | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: -split=chapter No Pass"
    rm -rf test
    ### --split=s ###
    texi2html -split=node test && find . -name "test" | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: -split=node No Pass"
    rm -rf test
    ### --split=s ###
    texi2html -split=s test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -split=s No Pass"
    rm -f test.html
    ### --init-file=s ###
    texi2html -init-file=newtexi2html test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -init-file=s No Pass"
    rm -f test.html
    ### --I=s ###
    texi2html -I=newDir test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -I=s No Pass"
    rm -f test.html
    ### --P=s ###
    texi2html -P=newDir test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -P=s No Pass"
    rm -f test.html

    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
