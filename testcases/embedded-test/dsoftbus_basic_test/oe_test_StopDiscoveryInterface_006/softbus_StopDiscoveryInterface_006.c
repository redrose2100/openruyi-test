/**
 * @title:测试StopDiscovery取消订阅特性服务能力，
 *    入参STOP_PACKAGE_NAME为NULL、STOP_DEFAULT_PUBLISH_ID为0
 */
#include "dsoftbus_common.h"

#define STOP_PACKAGE_NAME NULL
#define STOP_DEFAULT_PUBLISH_ID 0

int main(int argc, char **argv)
{
    DiscoveryInterface();
    int ret = StopDiscovery(STOP_PACKAGE_NAME, STOP_DEFAULT_PUBLISH_ID);
    if (ret) {
        printf("StopDiscoveryInterface fail, ret=%d\n", ret);
        return 1;
    }
    else{
        printf("StopDiscoveryInterface success, ret=%d\n", ret);
        return 0;
    }
}