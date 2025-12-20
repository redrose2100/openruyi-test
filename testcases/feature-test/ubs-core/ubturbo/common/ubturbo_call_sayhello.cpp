#include "turbo_def.h"
#include "turbo_ipc_client.h"

int main()
{
    TurboByteBuffer send;
    TurboByteBuffer recv;
    uint32_t ret = turbo::ipc::client::UBTurboFunctionCaller("SayHello", send, recv);

    return ret;
}
