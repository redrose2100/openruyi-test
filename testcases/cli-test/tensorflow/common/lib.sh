#!/usr/bash
source "$OET_PATH/libs/locallibs/common_lib.sh"
function get_tensorflow() {
    DNF_INSTALL "python3-tensorflow"
    old_LD_LIBRARY_PATH=LD_LIBRARY_PATH                          
    tspath=$(dirname $(find / -name libtensorflow_framework.so*)) 
    export LD_LIBRARY_PATH=$tspath:$LD_LIBRARY_PATH 
}
function model(){
    python3 ./common/saved_model.py
    wait
    python3 ./common/gen_tf_keras.model.py
    wait
}
