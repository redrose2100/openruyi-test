/**
 * @ttitle:测试StartDiscovery释放订阅/探测特定服务能力函数，TestRes函数第二个入参为1时是正常测试，为0时是异常测试
 */
#include "dsoftbus_common.h"

#define DEFAULT_PUBLISH_ID 123
#define DEFAULT_CAPABILITY "osdCapability"
#define PACKAGE_NAME "softbus_sample"
#define WRONG_PACKAGE_1 NULL

void ComTest()
{
    char *interface_name = "DiscoveryInterface";

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

    int ret = StartDiscovery(PACKAGE_NAME, &info, &cb);
    TestRes(ret, 1, interface_name, 1);
    StopDiscovery(PACKAGE_NAME, DEFAULT_PUBLISH_ID);

    ret = StartDiscovery("    ", &info, &cb);
    TestRes(ret, 1, interface_name, 2);
    StopDiscovery("    ", DEFAULT_PUBLISH_ID);

    ret = StartDiscovery(WRONG_PACKAGE_1, &info, &cb);
    TestRes(ret, 0, interface_name, 3);
    StopDiscovery(WRONG_PACKAGE_1, DEFAULT_PUBLISH_ID);

    SubscribeInfo wrong_info_1 = {};
    ret = StartDiscovery(PACKAGE_NAME, &wrong_info_1, &cb);
    TestRes(ret, 0, interface_name, 4);
    StopDiscovery(PACKAGE_NAME, DEFAULT_PUBLISH_ID);

    SubscribeInfo wrong_info_2 = {
        .subscribeId = 0,
        .mode = DISCOVER_MODE_ACTIVE,
        .medium = COAP,
        .freq = LOW,
        .isSameAccount = false,
        .isWakeRemote = false,
        .capability = DEFAULT_CAPABILITY,
        .capabilityData = NULL,
        .dataLen = 0,
    };
    ret = StartDiscovery(PACKAGE_NAME, &wrong_info_2, &cb);
    TestRes(ret, 1, interface_name, 5);
    StopDiscovery(PACKAGE_NAME, 0);

    SubscribeInfo wrong_info_3 = {
        .subscribeId = -1,
        .mode = DISCOVER_MODE_ACTIVE,
        .medium = COAP,
        .freq = LOW,
        .isSameAccount = false,
        .isWakeRemote = false,
        .capability = DEFAULT_CAPABILITY,
        .capabilityData = NULL,
        .dataLen = 0,
    };
    ret = StartDiscovery(PACKAGE_NAME, &wrong_info_3, &cb);
    TestRes(ret, 1, interface_name, 6);
    StopDiscovery(PACKAGE_NAME, -1);

    SubscribeInfo wrong_info_4 = {
        .subscribeId = DEFAULT_PUBLISH_ID,
        .mode = DISCOVER_MODE_ACTIVE,
        .medium = COAP,
        .freq = LOW,
        .isSameAccount = false,
        .isWakeRemote = false,
        .capability = "",
        .capabilityData = NULL,
        .dataLen = 0,
    };
    ret = StartDiscovery(PACKAGE_NAME, &wrong_info_4, &cb);
    TestRes(ret, 0, interface_name, 7);
    StopDiscovery(PACKAGE_NAME, DEFAULT_PUBLISH_ID);

    SubscribeInfo wrong_info_5 = {
        .subscribeId = DEFAULT_PUBLISH_ID,
        .mode = DISCOVER_MODE_ACTIVE,
        .medium = COAP,
        .freq = LOW,
        .isSameAccount = false,
        .isWakeRemote = false,
        .capability = "    ",
        .capabilityData = NULL,
        .dataLen = 0,
    };
    ret = StartDiscovery(PACKAGE_NAME, &wrong_info_5, &cb);
    TestRes(ret, 0, interface_name, 8);
    StopDiscovery(PACKAGE_NAME, DEFAULT_PUBLISH_ID);

    ret = StartDiscovery(WRONG_PACKAGE_1, &wrong_info_1, &cb);
    TestRes(ret, 0, interface_name, 9);
    StopDiscovery(PACKAGE_NAME, DEFAULT_PUBLISH_ID);
}

int main(int argc, char **argv)
{
    ComTest();
    return 0;
}
