/**
 * @title:测试StartDiscovery释放订阅/探测特定服务能力函数，
 *     入参PACKAGE_NAME为正常、&info为中capability不在正常范围内、&cb为正常
 */
#include "dsoftbus_common.h"

#define ERR_CAPABILITY "123456"

static int Discovery_ErrCapability(void)
{
    SubscribeInfo info = {
        .subscribeId = DEFAULT_PUBLISH_ID,
        .mode = DISCOVER_MODE_ACTIVE,
        .medium = COAP,
        .freq = LOW,
        .isSameAccount = false,
        .isWakeRemote = false,
        .capability = ERR_CAPABILITY,
        .capabilityData = NULL,
        .dataLen = 0,
    };
    IDiscoveryCallback cb = {
        .OnDeviceFound = DeviceFound,
        .OnDiscoverFailed = DiscoveryFailed,
        .OnDiscoverySuccess = DiscoverySuccess,
    };
    return StartDiscovery(PACKAGE_NAME, &info, &cb);
}

int main(int argc, char **argv)
{
    int ret = Discovery_ErrCapability();
    if (ret) {
        printf("DiscoveryInterface fail, ret=%d\n", ret);
        return 1;
    }
    printf("DiscoveryInterface success, ret=%d\n", ret);
    return 0;
}