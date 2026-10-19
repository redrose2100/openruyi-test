#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding-jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2025/08/28
# @License   :   Mulan PSL v2
# @Desc      :   Kubeflow deployment with Serverless
# #############################################
# shellcheck disable=SC2016
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL oedp python3-libselinux
    ssh-keyscan -H "${NODE1_IPV4}" >> ~/.ssh/known_hosts
    oedp repo update
    oedp init kubeflow-1.9.1
    sed -i "s#ansible_host: HOST_IP#ansible_host: ${NODE1_IPV4}#g" ./kuberay/config.yaml
    sed -i "s#ansible_password: \"\"#ansible_password: ${NODE1_PASSWORD}#g" ./kuberay/config.yaml
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start run_test"
    
    oedp run install-kserve -p ~/kubeflow-1.9.1/ 2>&1 | grep "Execute succeeded: install KServe"
    CHECK_RESULT $? 0 0 "Failed to deployment with Kserve"

    kubectl apply -f - <<EOF
apiVersion: "serving.kserve.io/v1beta1"
kind: "InferenceService"
metadata:
  name: "sklearn-iris"
spec:
  predictor:
    model:
      modelFormat:
        name: sklearn
      storageUri: "gs://kfserving-examples/models/sklearn/1.0/model"
EOF
   CHECK_RESULT $? 0 0 "Failed to deployment sklearn-iris"

   kubectl get inferenceservices sklearn-iris | grep "sklearn-iris"
   CHECK_RESULT $? 0 0 "Failed to grep sklearn-iris info"

   curl -v "http://sklearn-iris.default.svc.cluster.local/v1/models/sklearn-iris:predict" -d '{"instances": [[6.8,  2.8,  4.8,  1.4], [6.0,  3.4,  4.5,  1.6]]}' -H "Content-Type: application/json" > sklearn-iris 2>&1
   grep '{"predictions": [1, 1]}' sklearn-iris

    LOG_INFO "End run_test"
}

function post_test() {
    LOG_INFO "Start post_test"
    
    rm -rf sklearn-iris kubeflow-1.9.1
    DNF_REMOVE "$@"

    LOG_INFO "End post_test"
}

main "$@"




