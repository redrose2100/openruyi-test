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
#@Author    :   gaoyue
#@Contact   :   2829807379@qq.com
#@Date      :   2022/8/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "po4a" command
###################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "po4a"
    systemctl restart sshd.service
    touch savefile
    cp /etc/po4a/example.cfg ./
    cp /etc/po4a/example.txt ./
    LOG_INFO "End to prepare the test environment"
}
##########################################################
# Usage:
#     po4a [options] config_file

# Options:
#     -k, --keep
#         Minimal threshold for translation percentage to keep (i.e. write)
#         the resulting file (default: 80). I.e. by default, files have to be
#         translated at least at 80% to get written.

#     -h, --help
#         Show a short help message.

#     -M, --master-charset
#         Charset of the files containing the documents to translate. Note
#         that all master documents must use the same charset for now. This is
#         a known limitation, and we are working on solving this.

#     -L, --localized-charset
#         Charset of the files containing the localized documents. Note that
#         all translated documents will use the same charset for now. This is
#         a known limitation, and we are working on solving this.

#     -A, --addendum-charset
#         Charset of the addenda. Note that all the addenda should be in the
#         same charset.

#     -V, --version
#         Display the version of the script and exit.

#     -v, --verbose
#         Increase the verbosity of the program.

#     -q, --quiet
#         Decrease the verbosity of the program.

#     -d, --debug
#         Output some debugging information.

#     -o, --option
#         Extra option(s) to pass to the format plugin. Specify each option in
#         the 'name=value' format. See the documentation of each plugin for
#         more information about the valid options and their meanings.

#     -f, --force
#         Always generate the POT and PO files, even if po4a considers it is
#         not necessary.

#         The default behavior (when --force is not specified) is the
#         following:

#             If the POT file already exists, it is regenerated if a master
#             document or the configuration file is more recent. The POT file
#             is also written in a temporary document and po4a verifies that
#             the changes are really needed.

#             Also, a translation is regenerated only if its master document,
#             the PO file, one of its addenda or the configuration file is
#             more recent. To avoid trying to regenerate translations which do
#             not pass the threshold test (see --keep), a file with the
#             .po4a-stamp extension can be created (see --stamp).

#         If a master document includes files, you should use the --force flag
#         because the modification time of these included files are not taken
#         into account.

#         The PO files are always re-generated based on the POT with msgmerge
#         -U.

#     --stamp
#         Tells po4a to create stamp files when a translation is not generated
#         because it does not reach the threshold. These stamp files are named
#         according to the expected translated document, with the .po4a-stamp
#         extension.

#         Note: This only activates the creation of the .po4a-stamp files. The
#         stamp files are always used if they exist, and they are removed with
#         --rm-translations or when the file is finally translated.

#     --no-translations
#         Do not generate the translated documents, only update the POT and PO
#         files.

#     --no-update
#         Do not change the POT and PO files, only the translation may be
#         updated.

#     --keep-translations
#         Keeps the existing translation files even if the translation doesn't
#         meet the threshold specified by --keep. This option does not create
#         new translation files with few content, but it will save existing
#         translations which decay because of changes to the master files.

#         WARNING: This flag changes the po4a behavior in a rather drastic
#         way: your translated files will not get updated at all until the
#         translation improves. Only use this flag if you prefer shipping an
#         outdated translated documentation rather than only shipping an
#         accurate untranslated documentation.

#     --rm-translations
#         Remove the translated files (implies --no-translations).

#     --no-backups
#         This flag does nothing since 0.41, and may be removed in later
#         releases.

#     --rm-backups
#         This flag does nothing since 0.41, and may be removed in later
#         releases.

#     --translate-only translated-file
#         Translate only the specified file. It may be useful to speed up
#         processing if a configuration file contains a lot of files. Note
#         that this option does not update PO and POT files. This option can
#         be used multiple times.

#     --variable var=value
#         Define a variable that will be expanded in the po4a configuration
#         file. Every occurrence of $(var) will be replaced by value. This
#         option can be used multiple times.

#     --srcdir SRCDIR
#         Set the base directory for all input documents specified in the po4a
#         configuration file.

#     --destdir DESTDIR
#         Set the base directory for all the output documents specified in the
#         po4a configuration file.

#   Options Which Modify pot Header:
#     --porefs type[,wrap|nowrap]
#         Specify the reference format. Argument type can be one of never to
#         not produce any reference, file to only specify the file without the
#         line number, counter to replace line number by an increasing
#         counter, and full to include complete references (default: full).

#         Argument can be followed by a comma and either wrap or nowrap
#         keyword. References are written by default on a single line. The
#         wrap option wraps references on several lines, to mimic gettext
#         tools (xgettext and msgmerge). This option will become the default
#         in a future release, because it is more sensible. The nowrap option
#         is available so that users who want to keep the old behavior can do
#         so.

#     --msgid-bugs-address email@address
#         Set the report address for msgid bugs. By default, the created POT
#         files have no Report-Msgid-Bugs-To fields.

#     --copyright-holder string
#         Set the copyright holder in the POT header. The default value is
#         "Free Software Foundation, Inc."

#     --package-name string
#         Set the package name for the POT header. The default is "PACKAGE".

#     --package-version string
#         Set the package version for the POT header. The default is
#         "VERSION".

#   Options to Modify po Files:
#     --msgmerge-opt options
#         Extra options for msgmerge(1).

#         Note: $lang will be extended to the current language.

#     --no-previous
#         This option removes --previous from the options passed to msgmerge.
#         This permits to support versions of gettext earlier than 0.16.

#     --previous
#         This option adds --previous to the options passed to msgmerge. It
#         requires gettext 0.16 or later, and is activated by default.

#   Example:
#     Let's assume you maintain a program named foo which has a man page
#     man/foo.1 which naturally is maintained in English only. Now you as the
#     upstream or downstream maintainer want to create and maintain the
#     translation. First you need to create the POT file necessary to send to
#     translators using po4a-gettextize(1).

#     So for our case we would call

#      cd man && po4a-gettextize -f man -m foo.1 -p foo.pot

#     You would then send this file to the appropriate language lists or offer
#     it for download somewhere on your website.

#     Now let's assume you received three translations before your next
#     release: de.po (including an addendum de.add), sv.po and pt.po. Since
#     you don't want to change your Makefile(s) whenever a new translation
#     arrives you can use po4a with an appropriate configuration file in your
#     Makefile. Let's call it po4a.cfg. In our example it would look like the
#     following:

#      [po_directory] man/po4a/po/

#      [type: man] man/foo.1 $lang:man/translated/$lang/foo.1 \
#                 add_$lang:?man/po4a/add_$lang/$lang.add opt:"-k 80"

#     In this example we assume that your generated man pages (and all PO and
#     addenda files) should be stored in man/translated/$lang/ (respectively
#     in man/po4a/po/ and man/po4a/add_$lang/) below the current directory. In
#     our example the man/po4a/po/ directory would include de.po, pt.po and
#     sv.po, and the man/po4a/add_de/ directory would include de.add.

#     Note the use of the modifier ? as only the German translation (de.po) is
#     accompanied by an addendum.

#     To actually build the translated man pages you would then (once!) add
#     the following line in the build target of the appropriate Makefile:

#             po4a po4a.cfg

#     Once this is set up you don't need to touch the Makefile when a new
#     translation arrives, i.e. if the French team sends you fr.po and fr.add
#     then you simply drop them respectively in man/po4a/po/ and
#     man/po4a/add_fr/ and the next time the program is built the French
#     translation is automatically build as well in man/translated/fr/.

#     Note that you still need an appropriate target to install localized
#     manual pages with English ones.

#     Finally if you do not store generated files into your version control
#     system, you will need a line in your clean target as well: -rm -rf
#     man/translated

##########################################################
function run_test() {
    LOG_INFO "Start to run testcase:oe_test_po4a."
    ### -h ###
    po4a -h | grep -E "Usage:\n    po4a [options]"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### -V ###
    po4a -V | grep -E "po4a version "
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### -k ###
    po4a -k example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -a No Pass"
    ### -M ###
    po4a -M example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### -L ###
    po4a -L example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### -A ###
    po4a -A example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### -v ###
    po4a -v example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### -q ###
    po4a -q example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### -d ###
    po4a -d example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    # ### -o ###
    # po4a -o name=value example.cfg
    # CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### -f ###
    po4a -f example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### --stamp ###
    po4a --stamp example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### --no-translations ###
    po4a --no-translations example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### --no-update ###
    po4a --no-update example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### --keep-translations ###
    po4a --keep-translations example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### --rm-translations ###
    po4a --rm-translations example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### --no-backups ###
    po4a --no-backups example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### --rm-backups ###
    po4a --rm-backups example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### --translate-only ###
    po4a --translate-only example.txt example.cfg
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    # ### --variable var=value ###
    # po4a --variable var=value example.cfg
    # CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### --srcdir ###
    po4a --srcdir ./
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    ### --destdir ###
    po4a --destdir ./
    CHECK_RESULT $? 0 0 "L$LINENO: -l No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf savefile result example.conf
    LOG_INFO "End to restore the test environment."
}

main "$@"
