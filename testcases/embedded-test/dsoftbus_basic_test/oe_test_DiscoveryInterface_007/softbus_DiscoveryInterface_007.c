/**
 * @title:测试StartDiscovery释放订阅/探测特定服务能力函数，
 *    入参PACKAGE_NAME为正常、&info为正常、&cb中OnDiscoverySuccess为NULL
 */
#include "dsoftbus_common.h"

static int Discovery_ErrCallBack(void)
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
        .OnDiscoverySuccess = NULL,
    };
    return StartDiscovery(PACKAGE_NAME, &info, &cb);
}

int main(int argc, char **argv)
{
    int ret = Discovery_ErrCallBack();
    if (ret) {
        printf("Discovery_NullCallBack fail, ret=%d\n", ret);
        return 1;
    }
    printf("Discovery_NullCallBack success, ret=%d\n", ret);
    return 0;
}