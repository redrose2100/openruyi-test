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
# @Author    :   renwenjie
# @Contact   :   renwenjie5@huawei.com
# @Date      :   2025/3/26
# @License   :   Mulan PSL v2
# @Desc      :   test python3-vllm
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start environmental preparation."
  DNF_INSTALL "python3-vllm"
  LOG_INFO "End of environmental preparation!"
}

function run_test() {
  LOG_INFO "Start to run test."

  LOG_INFO "oe_test_python3-vllm_01: import vllm; print(vllm.__version__)"
  python3 -c "import vllm; print(vllm.__version__)"
  CHECK_RESULT $? 0 0

  LOG_INFO "oe_test_python3-vllm_01: import vllm; print(vllm.__file__)"
  python3 -c "import vllm; print(vllm.__file__)"
  CHECK_RESULT $? 0 0

  LOG_INFO "oe_test_python3-vllm_01: from vllm import SamplingParams; params = SamplingParams(temperature=0.8, top_p=0.95); print(params)"
  python3 -c "from vllm import SamplingParams; params = SamplingParams(temperature=0.8, top_p=0.95); print(params)"
  CHECK_RESULT $? 0 0

  LOG_INFO "oe_test_python3-vllm_01: import EngineArgs | ModelRegistry"
  python3 -c "import vllm; \
	      from vllm.engine.arg_utils import EngineArgs; \
	      from vllm.model_executor.models import ModelRegistry"
  CHECK_RESULT $? 0 0

  LOG_INFO "oe_test_python3-vllm_01: from vllm.logger import init_logger; logger.warning('test')"
  python3 -c "import os; \
  	      import vllm; \
	      from vllm.logger import init_logger; \
	      log_path = os.path.expanduser(\"~/vllm.log\"); \
	      logger = init_logger(log_path); \
	      logger.warning(\"test\")"
  CHECK_RESULT $? 0 0

  LOG_INFO "End of the test."
}

function post_test() {
  LOG_INFO "start environment cleanup."
  DNF_REMOVE "$@"
  LOG_INFO "Finish environment cleanup!"
}

main "$@"
