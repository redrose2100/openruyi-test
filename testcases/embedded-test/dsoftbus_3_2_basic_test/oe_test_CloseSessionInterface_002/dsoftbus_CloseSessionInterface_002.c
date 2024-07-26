/**
 * @ttitle:测试CloseSessio断开传输连接函数异常入参，入参sessionID�?�?1
 */
#include "dsoftbus_common.h"

void ComTest()
{
    NodeBasicInfo *dev = NULL;
    int dev_num = GetAllNodeDeviceInfoInterface(&dev);
    if (dev_num <= 0) {
        return;
    }

    OpenSessionInterface(dev[0].networkId, TYPE_BYTES);
    CloseSession(0);

    CloseSession(-1);
}

int main(int argc, char **argv)
{
    PreEnv();
    CommunicationLoop();
    CleanEnv();
    return 0;
}
