#!/usr/bin/bash

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2022-11-09
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function prce_install() {
    yum install  pcre pcre-devel -y
    if [ $? -eq 0 ];then
      echo 'pcre installation succeeded'
    else
      echo 'Packages name or warehouse error'
    fi
}

function check_version() {
    version=`pcre-config --version`
    if [ $? -eq 0 ];then
      echo "pcre's  installed successfully"
    else
      echo 'pcre  installed failed'
      exit 1
    fi
}

function import_config() {
    echo '/usr/local/lib/pcre' >> /etc/ld.so.conf
    ldconfig
    if [ $? -eq 0 ];then
      echo "File configuration successful(ld.so.conf)"
    else
      echo "check your file configuration (/etc/ld.so.conf)"
      exit 1
    fi
}

function edit_config() {
    cat > file.c << EOF
#include <pcre.h>
#include <stdio.h>
int main()
{
  printf("aaa");
  return 0;
}
EOF
    if [ $? -eq 0 ];then
      echo "File configuration successful(file.c)"
    else
      echo "check your file configuration (file.c)"
      exit 1
    fi
}


function make_file.c() {
      gcc -I/usr/local/include/pcre -L/usr/local/lib/pcre -lpcre file.c
  if [ $? -eq 0 ];then
    echo 'pcre verify successful'
  else
    echo 'check your file configuration (File.c)'
    exit 1
  fi
}

main "$@"