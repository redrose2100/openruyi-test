#include <cstdint>
#include <string>
#include <filesystem>
#include <fstream>

#include "callback_manager.h"
#include "turbotest_config.h"
#include "turbotest_error.h"
#include "turbo_conf.h"
#include "turbo_logger.h"

using namespace turbo::config;
using namespace turbo::log;
using namespace turbotest;
using namespace std;

extern "C" {
uint32_t TurboPluginInit(const uint16_t modCode);
void TurboPluginDeInit();
}

uint32_t TurboPluginInit(const uint16_t modCode)
{
    UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[TurbotestInit] Start init turbotest plugin" << " modCode：" << modCode << ".";
    TurbotestResult ret = TurbotestConfig::Instance().Init(modCode);
    if (ret != TURBOTEST_OK) {
        UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[TurbotestInit] Turboresr config init failed." << ret;
        return TURBOTEST_ERROR;
    }

    ret = CallbackManager::Init();
    if (ret != TURBOTEST_OK) {
        UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[RmrsInit] Rmrs config init failed." << ret;
        return TURBOTEST_ERROR;
    }

    UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[TurbotestInit] Init turbotest plugin" << " modCode:" << modCode << " success.";
    return TURBOTEST_OK;

}

void TurboPluginDeInit()
{
    auto ret = CallbackManager::DeInit();
    if (ret != TURBOTEST_OK) {
        UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[RmrsInit] Rmrs config init failed." << ret;
    }
    UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[TurbotestInit] Plugin turbotest deinit.";
}
