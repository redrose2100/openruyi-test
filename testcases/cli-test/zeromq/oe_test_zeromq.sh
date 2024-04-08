#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2024.3.22
# @License   :   Mulan PSL v2
# @Desc      :   zeromq formatting test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test(){
    LOG_INFO "Start environment preparation."
    mkdir /tmp/zeromq    
    cat > /tmp/zeromq/server.cpp << EOF
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <assert.h>
#include <zmq.h>                         
int main (void)                                                                         
{                                                                                        
    //  Socket to talk to clients                                                       
    void *context = zmq_ctx_new ();                                                      
    void *responder = zmq_socket (context, ZMQ_REP);                               
    int rc = zmq_bind (responder, "tcp://*:5555");                                       
    assert (rc == 0);                                                                  
    while (1) {                                                             
        char buffer [10];                                                         
        zmq_recv (responder, buffer, 10, 0);                                         
        printf ("Received Hello\n");                                               
        sleep (1);          //  Do some 'work'                                           
        zmq_send (responder, "World", 5, 0);                                           
    }                                                         
    return 0;                                                                        
}
EOF
    cat > /tmp/zeromq/client.cpp << EOF
#include <zmq.h>                                                                       
#include <string.h>                                                                
#include <stdio.h>                                                                  
#include <unistd.h>       
int main (void)                                                                      
{                                                                        
    printf ("Connecting to hello world server…\n");                                     
    void *context = zmq_ctx_new ();                                        
    void *requester = zmq_socket (context, ZMQ_REQ);                                
    zmq_connect (requester, "tcp://localhost:5555");      
    int request_nbr;                                                                
    for (request_nbr = 0; request_nbr != 10; request_nbr++) {                            
        char buffer [10];                                                                
        printf ("Sending Hello %d…\n", request_nbr);                                  
        zmq_send (requester, "Hello", 5, 0);                                        
        zmq_recv (requester, buffer, 10, 0);                                        
        printf ("Received World %d\n", request_nbr);                                    
    }     
    zmq_close (requester);                                                        
    zmq_ctx_destroy (context);      
    return 0;                                                                                    
}
EOF
    DNF_INSTALL "zeromq zeromq-devel zeromq-help gcc-c++"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep zeromq
    CHECK_RESULT $? 0 0 "Return value error"
    cd /tmp/zeromq && g++ server.cpp -o server -lzmq -I./include -L./lib 
    g++ client.cpp -o client -lzmq -I./include -L./lib
    test -f /tmp/zeromq/server
    test -f /tmp/zeromq/client
    CHECK_RESULT $? 0 0 "execute zeromq-file fail"
    ./server & ./client > /tmp/zeromq/client_txt
    SLEEP_WAIT 20
    pgrep -af server |awk '{print $1}' | xargs -I {} kill -9 {}
    grep "Sending Hello " /tmp/zeromq/client_txt
    CHECK_RESULT $? 0 0 "sever execute fail"

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/zeromq 
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

