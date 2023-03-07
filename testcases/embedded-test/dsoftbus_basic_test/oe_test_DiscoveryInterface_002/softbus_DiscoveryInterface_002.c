/**
 * @title:测试StartDiscovery释放订阅/探测特定服务能力函数，
 * 入参PACKAGE_NAME为123、&info为正常、&cb为正常
 */
#include "dsoftbus_common.h"

static int Discovery_PackageName123(void)
{
    SubscribeInfo info = {
        .subscribeId = DEFAULT_PUBLISH_ID,
        .mode = DISCOVER_MODE_ACTIVE,
        .medium = COAP,
        .freq = LOW,
        .isSameAccount = false,
        .isWakeRemote = false,
        .capability = DEFAULT_CAPABILITY,
        .capabilityData = NULL,
        .dataLen = 0,
    };
    IDiscoveryCallback cb = {
        .OnDeviceFound = DeviceFound,
        .OnDiscoverFailed = DiscoveryFailed,
        .OnDiscoverySuccess = DiscoverySuccess,
    };
    return StartDiscovery(123, &info, &cb);
}

int main(int argc, char **argv)
{
    int ret = Discovery_PackageName123();
    if (ret) {
        printf("DiscoveryInterface fail, ret=%d\n", ret);
        return 1;
    }
    printf("DiscoveryInterface success, ret=%d\n", ret);
    return 0;
}