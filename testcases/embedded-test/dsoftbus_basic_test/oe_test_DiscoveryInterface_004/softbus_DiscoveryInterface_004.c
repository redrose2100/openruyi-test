/**
 * @title:测试StartDiscovery释放订阅/探测特定服务能力函数，
 *    入参PACKAGE_NAME为正常、&info为空、&cb为正常
 */
#include "dsoftbus_common.h"

static int Discovery_NullInfo(void)
{
    SubscribeInfo info = {
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
    int ret = Discovery_NullInfo();
    if (ret) {
        printf("Discovery_NullInfo fail, ret=%d\n", ret);
        return 1;
    }
    printf("Discovery_NullInfo success, ret=%d\n", ret);
    return 0;
}