#ifndef TURBOTEST_CALLBACK_MANAGER_H
#define TURBOTEST_CALLBACK_MANAGER_H

#include "turbotest_error.h"
#include "turbo_ipc_server.h"

namespace turbotest {
    class CallbackManager{
        
    public:
        static TurbotestResult Init();
        static TurbotestResult SayHelloHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult SayGoogByeHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult RegIpcServiceTestHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult UnRegIpcServiceTestHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult TurboGetUInt32Handler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult TurboGetFloatHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult TurboGetStrHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult TurboGetBoolHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult TurboGetUInt64Handler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        
        static TurbotestResult TurboLogInfoHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult TurboLogCritHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult TurboLogErrorHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult TurboLogWarnHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        static TurbotestResult TurboLogDebugHandler(const TurboByteBuffer &req, TurboByteBuffer &resp);
        
        static TurbotestResult DeInit();
    private:
        static const int privateParam; // 私有参数

    };
    
} // namespace turbotest

#endif