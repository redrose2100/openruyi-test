#ifndef TURBOTEST_CONFIGURATION_H
#define TURBOTEST_CONFIGURATION_H

#include <string>
#include "turbotest_error.h"

namespace turbotest{

#define TURBOTEST_MODULE_NAME TurbotestConfig::Instance().GetModuleName()
#define TURBOTEST_MODULE_CODE TurbotestConfig::Instance().GetModuleCode()
#define TURBOTEST_CONFIG_NAME TurbotestConfig::Instance().GetConfigName()

    class TurbotestConfig {
    public:
        static TurbotestConfig &Instance()
        {
            static TurbotestConfig instance;
            return instance;
        }

        TurbotestConfig(const TurbotestConfig &) = delete;
        TurbotestConfig &operator=(const TurbotestConfig &) =delete;
        TurbotestConfig(TurbotestConfig &&) = delete;
        TurbotestConfig &operator=(TurbotestConfig &&) =delete;

        inline const char *GetModuleName()
        {
            return moduleName.c_str();
        }

        inline const char *GetConfigName()
        {
            return configName.c_str();
        }

        inline uint16_t GetModuleCode()
        {
            return moduleCode;
        }
        
        inline TurbotestResult Init(const uint16_t modCode)
        {
            moduleCode = modCode;
            return TURBOTEST_OK;
        }

    private:
        TurbotestConfig() = default;

        std::string moduleName = "turbotest";
        uint16_t moduleCode = 0;
        std::string configName = "plugin_turbotest";
    };
} // namespace turbotest

#endif