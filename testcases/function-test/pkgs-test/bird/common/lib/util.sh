#!/bin/bash

function extract_data(){
    if [[ -f ./common/data.tar.gz ]]; then
        tar -xvf ./common/data.tar.gz
    fi
}

function clean_dir(){
    filelist=$(ls)
    for filename in ${filelist[@]}; do
        if [[ -d $filename ]] && [[ ! "${filename}x" == "commonx" ]]; then
            rm -rf $filename
        fi
    done
}
