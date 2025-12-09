#include "turbo_def.h"
#include "turbo_ipc_client.h"
#include "turbo_serialize.h"

using namespace turbo::serialize;

int main(int argc, char* argv[])
{
    if (argc < 4) {
        std::cerr << "usage: " << argv[0] << "<getValueFunc> <configName> <configKey>" << std::endl;
        return 1;
    }
    TurboByteBuffer req;
    TurboByteBuffer resp;
    std::string getValueFuncStr = argv[1];
    std::string section = argv[2];
    std::string configKey = argv[3];
    RmrsOutStream builder;
    builder << section << configKey;
    req.data = builder.GetBufferPointer();
    req.len = builder.GetSize();
    if (getValueFuncStr == "TurboGetUInt32") {
        uint32_t ipcRet = turbo::ipc::client::UBTurboFunctionCaller(getValueFuncStr, req, resp);
        delete[] req.data;
        if (ipcRet != 0) {
            std::cout << "UBTurboFunctionCaller Return Code is Non-zero" << std::endl;
            return ipcRet;
        }
        uint32_t turboAPIRet;
        uint32_t configValue;
        RmrsInStream reader(resp.data, resp.len);
        reader >> turboAPIRet >> configValue;
        std::cout << configKey << "=" << configValue << std::endl;
        return ipcRet;
    }
    if (getValueFuncStr == "TurboGetFloat") {
        uint32_t ipcRet = turbo::ipc::client::UBTurboFunctionCaller(getValueFuncStr, req, resp);
        delete[] req.data;
        if (ipcRet != 0) {
            std::cout << "UBTurboFunctionCaller Return Code is Non-zero" << std::endl;
            return ipcRet;
        }
        uint32_t turboAPIRet;
        float configValue;
        RmrsInStream reader(resp.data, resp.len);
        reader >> turboAPIRet >> configValue;
        std::cout << configKey << "=" << configValue << std::endl;
        return ipcRet; 
    }
    if (getValueFuncStr == "TurboGetStr") {
        uint32_t ipcRet = turbo::ipc::client::UBTurboFunctionCaller(getValueFuncStr, req, resp);
        delete[] req.data;
        if (ipcRet != 0) {
            std::cout << "UBTurboFunctionCaller Return Code is Non-zero" << std::endl;
            return ipcRet;
        }
        uint32_t turboAPIRet;
        std::string configValue;
        RmrsInStream reader(resp.data, resp.len);
        reader >> turboAPIRet >> configValue;
        std::cout << configKey << "=" << configValue << std::endl;
        return ipcRet; 
    }
    if (getValueFuncStr == "TurboGetBool") {
        uint32_t ipcRet = turbo::ipc::client::UBTurboFunctionCaller(getValueFuncStr, req, resp);
        delete[] req.data;
        if (ipcRet != 0) {
            std::cout << "UBTurboFunctionCaller Return Code is Non-zero" << std::endl;
            return ipcRet;
        }
        uint32_t turboAPIRet;
        bool configValue;
        RmrsInStream reader(resp.data, resp.len);
        reader >> turboAPIRet >> configValue;
        std::cout << configKey << "=" << configValue << std::endl;
        return ipcRet; 
    }
    if (getValueFuncStr == "TurboGetUInt64") {
        uint32_t ipcRet = turbo::ipc::client::UBTurboFunctionCaller(getValueFuncStr, req, resp);
        delete[] req.data;
        if (ipcRet != 0) {
            std::cout << "UBTurboFunctionCaller Return Code is Non-zero" << std::endl;
            return ipcRet;
        }
        uint32_t turboAPIRet;
        uint64_t configValue;
        RmrsInStream reader(resp.data, resp.len);
        reader >> turboAPIRet >> configValue;
        std::cout << configKey << "=" << configValue << std::endl;
        return ipcRet; 
    }
    uint32_t ipcRet = turbo::ipc::client::UBTurboFunctionCaller(getValueFuncStr, req, resp);
    delete[] req.data;
    if (ipcRet != 0) {
        std::cerr << "Unknown function name: " << getValueFuncStr << std::endl;
    return ipcRet;
    }
    return 999;
}