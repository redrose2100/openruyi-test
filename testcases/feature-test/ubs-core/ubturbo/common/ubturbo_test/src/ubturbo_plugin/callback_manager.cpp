#include "callback_manager.h"
#include <unistd.h>

#include <chrono>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <thread>
#include <fstream>
#include <sys/stat.h>

#include "turbotest_config.h"
#include "turbo_conf.h"
#include "turbo_def.h"
#include "turbo_ipc_server.h"
#include "turbo_logger.h"
#include "turbo_serialize.h"

namespace turbotest{
    using namespace turbo::ipc::server;
    using namespace turbo::config;
    using namespace turbo::serialize;

    const int CallbackManager::privateParam = 1;

    TurbotestResult CallbackManager::Init()
    {
        UBTURBO_LOG_DEBUG(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[Init][CallbackManager] Start register IPC services -- The first batch";

        UBTurboRegIpcService("SayHello", CallbackManager::SayHelloHandler);
        UBTurboRegIpcService("RegIpcServiceTest", CallbackManager::RegIpcServiceTestHandler);
        UBTurboRegIpcService("UnRegIpcServiceTest", CallbackManager::UnRegIpcServiceTestHandler);
        UBTurboRegIpcService("TurboGetUInt32", CallbackManager::TurboGetUInt32Handler);
        UBTurboRegIpcService("TurboGetFloat", CallbackManager::TurboGetFloatHandler);
        UBTurboRegIpcService("TurboGetStr", CallbackManager::TurboGetStrHandler);
        UBTurboRegIpcService("TurboGetBool", CallbackManager::TurboGetBoolHandler);
        UBTurboRegIpcService("TurboGetUInt64", CallbackManager::TurboGetUInt64Handler);
        
        UBTurboRegIpcService("TurboLogCrit", CallbackManager::TurboLogCritHandler);
        UBTurboRegIpcService("TurboLogError", CallbackManager::TurboLogErrorHandler);
        UBTurboRegIpcService("TurboLogWarn", CallbackManager::TurboLogWarnHandler);
        UBTurboRegIpcService("TurboLogDebug", CallbackManager::TurboLogDebugHandler);
        UBTurboRegIpcService("TurboLogInfo", CallbackManager::TurboLogInfoHandler);

        UBTURBO_LOG_DEBUG(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[Init][CallbackManager] End register IPC services -- The first batch";

        UBTURBO_LOG_DEBUG(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[Init][CallbackManager] Start register IPC services -- The second batch";

        auto makeHandler = []() -> IpcHandlerFunc {
            return [](const TurboByteBuffer &req, TurboByteBuffer &resp) -> uint32_t {
                return 0;
            };
        };

        // --- Part 1:Batch register TestService ---
        struct TestService
        {
            std::string name;
            std::string desc;
        };

        std::vector<TestService> services = {
            {"", "[NullName] empty string"},
            {"ValidName", "[ValidName] vaild but not registered"},
            {std::string(200, 'a'), "[OverLength] overlength string"},
            {"ValidName", "[Duplicate] duplicate registration"}
        };
        
        int retSum = 0;
        for (auto &svc : services) {
            int ret = static_cast<int>(UBTurboRegIpcService(svc.name, makeHandler()));
            retSum += (ret != 0 ? 1 : 0);

            UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
            << "[Init] Register service " << svc.desc << ", name='" << svc.name << "'returned ret=" << ret;
        }

        UBTURBO_LOG_DEBUG(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[Init] Batch registration finished, total failed registration:" << retSum;

        // --- Part 2:Original test points 1-4 registration/unregistration flow ---
        std::string reRegisterName = "ReRegisterTest";
        int ret1 = static_cast<int>(UBTurboRegIpcService(reRegisterName, makeHandler()));
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[TestPoint1] First registration of '" << reRegisterName << "' returned ret=" << ret1;

        int ret2 = static_cast<int>(UBTurboUnRegIpcService(reRegisterName));
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[TestPoint1] Unregister '" << reRegisterName << "' returned ret=" << ret2;

        int ret3 = static_cast<int>(UBTurboRegIpcService(reRegisterName, makeHandler()));
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[TestPoint1] Register again '" << reRegisterName << "' returned ret=" << ret3;

        int ret4 = static_cast<int>(UBTurboUnRegIpcService(""));
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[TestPoint2] Unregister empty string returned ret='" << ret4;

        int ret5 = static_cast<int>(UBTurboUnRegIpcService("NotRegisteredName"));
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[TestPoint2] Unregister no-registered name returned ret='" << ret5;

        std::string testName = "TestService";
        int ret6 = static_cast<int>(UBTurboRegIpcService(testName, makeHandler()));
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[TestPoint3] Register '" << testName << "' returned ret=" << ret6;

        int ret7 = static_cast<int>(UBTurboUnRegIpcService(testName));
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[TestPoint3] Unregister '" << reRegisterName << "' returned ret=" << ret7;

        int ret8 = static_cast<int>(UBTurboUnRegIpcService(testName));
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[TestPoint4] Repeated unregister '" << reRegisterName << "' returned ret=" << ret8;

        UBTURBO_LOG_DEBUG(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE)
        << "[Init][CallbackManager] End register IPC services -- The second batch";

        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::SayHelloHandler(const TurboByteBuffer &req, TurboByteBuffer &resp)
    {
        UBTURBO_LOG_INFO("Turbotest", 555) << "[Turbotest][SayHello]Hello!OpenEuler!";
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][SayHello]Hello, openeuler! The handler you registered before is executed!";
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "";
        UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][SayHello]Hello, openeuler! The handler you registered before is executed!";
        return TURBOTEST_OK;
    }


    TurbotestResult CallbackManager::SayGoogByeHandler(const TurboByteBuffer &req, TurboByteBuffer &resp)
    {
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][SayHello]Good Bye, openeuler! The handler you registered before is executed!";
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::RegIpcServiceTestHandler(const TurboByteBuffer &req, TurboByteBuffer &resp)
    {
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][RegIpcServiceTestHandler] RegIpcServiceTestHandler is called";
        auto ret = UBTurboRegIpcService("SayGoogBye", CallbackManager::SayGoogByeHandler);
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][RegIpcServiceTestHandler] RegIpcServiceTestHandler is end";
        if (ret != 0){
            return TURBOTEST_ERROR;
        }
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::UnRegIpcServiceTestHandler(const TurboByteBuffer &req, TurboByteBuffer &resp)
    {
        auto ret = UBTurboUnRegIpcService("SayHello");
        if (ret != 0){
            return TURBOTEST_ERROR;
        }
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::TurboGetUInt32Handler(const TurboByteBuffer &req, TurboByteBuffer &resp) 
    {
        RmrsInStream reader(req.data, req.len);
        std::string section, configKey;
        reader >> section >> configKey;
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetUInt32Handler]section is " << section << "; configKey is " << configKey;
        uint32_t configValue;
        uint32_t turboAPIRet = UBTurboGetUInt32(section, configKey, configValue);
        RmrsOutStream builder;
        builder << turboAPIRet << configValue;
        resp.data = builder.GetBufferPointer();
        resp.len = builder.GetSize();
        if (turboAPIRet != 0) {
            UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetUInt32Handler]TurboGetUInt32 fail, retcode is " << turboAPIRet;
            return TURBOTEST_ERROR;
        }
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetUInt32Handler]TurboGetUInt32 succeed, the value is " << configValue;
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::TurboGetFloatHandler(const TurboByteBuffer &req, TurboByteBuffer &resp) 
    {
        RmrsInStream reader(req.data, req.len);
        std::string section, configKey;
        reader >> section >> configKey;
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetFloatHandler]section is " << section << "; configKey is " << configKey;
        float configValue;
        uint32_t turboAPIRet = UBTurboGetFloat(section, configKey, configValue);
        RmrsOutStream builder;
        builder << turboAPIRet << configValue;
        resp.data = builder.GetBufferPointer();
        resp.len = builder.GetSize();
        if (turboAPIRet != 0) {
            UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetFloatHandler]TurboGetFloat fail, retcode is " << turboAPIRet;
            return TURBOTEST_ERROR;
        }
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetFloatHandler]TurboGetFloat succeed, the value is " << configValue;
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::TurboGetStrHandler(const TurboByteBuffer &req, TurboByteBuffer &resp) 
    {
        RmrsInStream reader(req.data, req.len);
        std::string section, configKey;
        reader >> section >> configKey;
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetStrHandler]section is " << section << "; configKey is " << configKey;
        std::string configValue;
        uint32_t turboAPIRet = UBTurboGetStr(section, configKey, configValue);
        RmrsOutStream builder;
        builder << turboAPIRet << configValue;
        resp.data = builder.GetBufferPointer();
        resp.len = builder.GetSize();
        if (turboAPIRet != 0) {
            UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetStrHandler]TurboGetStr fail, retcode is " << turboAPIRet;
            return TURBOTEST_ERROR;
        }
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetStrHandler]TurboGetStr succeed, the value is " << configValue;
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::TurboGetBoolHandler(const TurboByteBuffer &req, TurboByteBuffer &resp) 
    {
        RmrsInStream reader(req.data, req.len);
        std::string section, configKey;
        reader >> section >> configKey;
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetBoolHandler]section is " << section << "; configKey is " << configKey;
        bool configValue;
        uint32_t turboAPIRet = UBTurboGetBool(section, configKey, configValue);
        RmrsOutStream builder;
        builder << turboAPIRet << configValue;
        resp.data = builder.GetBufferPointer();
        resp.len = builder.GetSize();
        if (turboAPIRet != 0) {
            UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetBoolHandler]TurboGetBool fail, retcode is " << turboAPIRet;
            return TURBOTEST_ERROR;
        }
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetBoolHandler]TurboGetBool succeed, the value is " << configValue;
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::TurboGetUInt64Handler(const TurboByteBuffer &req, TurboByteBuffer &resp) 
    {
        RmrsInStream reader(req.data, req.len);
        std::string section, configKey;
        reader >> section >> configKey;
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetUInt64Handler]section is " << section << "; configKey is " << configKey;
        uint64_t configValue;
        uint32_t turboAPIRet = UBTurboGetUInt64(section, configKey, configValue);
        RmrsOutStream builder;
        builder << turboAPIRet << configValue;
        resp.data = builder.GetBufferPointer();
        resp.len = builder.GetSize();
        if (turboAPIRet != 0) {
            UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetUInt64Handler]TurboGetUInt64 fail, retcode is " << turboAPIRet;
            return TURBOTEST_ERROR;
        }
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboGetUInt64Handler]TurboGetUInt64 succeed, the value is " << configValue;
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::TurboLogCritHandler(const TurboByteBuffer &req, TurboByteBuffer &resp)
    {
        RmrsInStream reader(req.data, req.len);
        std::string moduleName;
        uint16_t moduleId;
        std::string content;

        std::ostringstream oss;
        oss << std::this_thread::get_id();
        std::string tid_str = oss.str();
        pid_t pid = getpid();

        reader >> moduleName >> moduleId >> content;
        bool ret;
        if (strcmp(moduleName.c_str(), "nullptr") == 0) {
            ret = UBTURBO_LOG_CRIT(nullptr, moduleId) << content << "[testpoint] pid of this log is " << pid << "[testpoint] tid of this log is " << tid_str;
        } else {
            ret = UBTURBO_LOG_CRIT(moduleName.c_str(), moduleId) << content << "[testpoint] pid of this log is " << pid << "[testpoint] tid of this log is " << tid_str;
        }
        if (!ret) {
            UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboLogCritHandler]call UBTURBO_LOG_CRIT fail, ret is false";
            return TURBOTEST_ERROR;
        }
        UBTURBO_LOG_CRIT(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboLogCritHandler]call UBTURBO_LOG_CRIT succeed, ret is true";
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::TurboLogErrorHandler(const TurboByteBuffer &req, TurboByteBuffer &resp)
    {
        RmrsInStream reader(req.data, req.len);
        std::string moduleName;
        uint16_t moduleId;
        std::string content;

        std::ostringstream oss;
        oss << std::this_thread::get_id();
        std::string tid_str = oss.str();
        pid_t pid = getpid();

        reader >> moduleName >> moduleId >> content;
        bool ret;
        if (strcmp(moduleName.c_str(), "nullptr") == 0) {
            ret = UBTURBO_LOG_ERROR(nullptr, moduleId) << content << "[testpoint] pid of this log is " << pid << "[testpoint] tid of this log is " << tid_str;
        } else {
            ret = UBTURBO_LOG_ERROR(moduleName.c_str(), moduleId) << content << "[testpoint] pid of this log is " << pid << "[testpoint] tid of this log is " << tid_str;
        }
        if (!ret) {
            UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboLogErrorHandler]call UBTURBO_LOG_ERROR fail, ret is false";
            return TURBOTEST_ERROR;
        }
        UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboLogErrorHandler]call UBTURBO_LOG_ERROR succeed, ret is true";
        return TURBOTEST_OK;
    }


    TurbotestResult CallbackManager::TurboLogWarnHandler(const TurboByteBuffer &req, TurboByteBuffer &resp)
    {
        RmrsInStream reader(req.data, req.len);
        std::string moduleName;
        uint16_t moduleId;
        std::string content;

        std::ostringstream oss;
        oss << std::this_thread::get_id();
        std::string tid_str = oss.str();
        pid_t pid = getpid();

        reader >> moduleName >> moduleId >> content;
        bool ret;
        if (strcmp(moduleName.c_str(), "nullptr") == 0) {
            ret = UBTURBO_LOG_WARN(nullptr, moduleId) << content << "[testpoint] pid of this log is " << pid << "[testpoint] tid of this log is " << tid_str;
        } else {
            ret = UBTURBO_LOG_WARN(moduleName.c_str(), moduleId) << content << "[testpoint] pid of this log is " << pid << "[testpoint] tid of this log is " << tid_str;
        }
        if (!ret) {
            UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboLogWarnHandler]call UBTURBO_LOG_WARN fail, ret is false";
            return TURBOTEST_ERROR;
        }
        UBTURBO_LOG_WARN(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboLogWarnHandler]call UBTURBO_LOG_WARN succeed, ret is true";
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::TurboLogDebugHandler(const TurboByteBuffer &req, TurboByteBuffer &resp)
    {
        RmrsInStream reader(req.data, req.len);
        std::string moduleName;
        uint16_t moduleId;
        std::string content;

        std::ostringstream oss;
        oss << std::this_thread::get_id();
        std::string tid_str = oss.str();
        pid_t pid = getpid();

        reader >> moduleName >> moduleId >> content;
        bool ret;
        if (strcmp(moduleName.c_str(), "nullptr") == 0) {
            ret = UBTURBO_LOG_DEBUG(nullptr, moduleId) << content << "[testpoint] pid of this log is " << pid << "[testpoint] tid of this log is " << tid_str;
        } else {
            ret = UBTURBO_LOG_DEBUG(moduleName.c_str(), moduleId) << content << "[testpoint] pid of this log is " << pid << "[testpoint] tid of this log is " << tid_str;
        }
        if (!ret) {
            UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboLogDebugHandler]call UBTURBO_LOG_DEBUG fail, ret is false";
            return TURBOTEST_ERROR;
        }
        UBTURBO_LOG_DEBUG(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboLogDebugHandler]call UBTURBO_LOG_DEBUG succeed, ret is true";
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::TurboLogInfoHandler(const TurboByteBuffer &req, TurboByteBuffer &resp)
    {
        RmrsInStream reader(req.data, req.len);
        std::string moduleName;
        uint16_t moduleId;
        std::string content;

        std::ostringstream oss;
        oss << std::this_thread::get_id();
        std::string tid_str = oss.str();
        pid_t pid = getpid();

        reader >> moduleName >> moduleId >> content;
        bool ret;
        if (strcmp(moduleName.c_str(), "nullptr") == 0) {
            ret = UBTURBO_LOG_INFO(nullptr, moduleId) << content << "[testpoint] pid of this log is " << pid << "[testpoint] tid of this log is " << tid_str;
        } else {
            ret = UBTURBO_LOG_INFO(moduleName.c_str(), moduleId) << content << "[testpoint] pid of this log is " << pid << "[testpoint] tid of this log is " << tid_str;
        }
        if (!ret) {
            UBTURBO_LOG_ERROR(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboLogInfoHandler]call UBTURBO_LOG_INFO fail, ret is false";
            return TURBOTEST_ERROR;
        }
        UBTURBO_LOG_INFO(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[Turbotest][TurboLogInfoHandler]call UBTURBO_LOG_INFO succeed, ret is true";
        return TURBOTEST_OK;
    }

    TurbotestResult CallbackManager::DeInit() {
        UBTURBO_LOG_DEBUG(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[CallbackManager]Start unregister ipc service";
        UBTurboUnRegIpcService("SayHello");
        UBTURBO_LOG_DEBUG(TURBOTEST_MODULE_NAME, TURBOTEST_MODULE_CODE) << "[CallbackManager]End unregister ipc service";

        return TURBOTEST_OK;
    }
 
} // namespace turbotest

