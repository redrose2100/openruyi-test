/**
 * @ttitle:测试软总线的发现设备功能场�? */
#include "dsoftbus_common.h"

void ComTest()
{
    PublishServiceInterface();
    DiscoveryInterface();
}

int main(int argc, char **argv)
{
    CommunicationLoop();
    UnPublishServiceInterface();
    StopDiscoveryInterface();
    return 0;
}
