#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <cJSON.h>
#include <securec.h>
#include <softbus_common.h>
#include <device_auth.h>
#include <parameter.h>
#include "securec.h"
#include "discovery_service.h"
#include "softbus_bus_center.h"
#include "session.h"

#define PACKAGE_NAME "softbus_sample"
#define LOCAL_SESSION_NAME "session_test"
#define TARGET_SESSION_NAME "session_test"
#define DEFAULT_CAPABILITY "osdCapability"
#define DEFAULT_SESSION_GROUP "group_test"
#define DEFAULT_PUBLISH_ID 123

static void PublishSuccess(int publishId)
{
    printf("<PublishSuccess>CB: publish %d done\n", publishId);
}

static void PublishFailed(int publishId, PublishFailReason reason)
{
    printf("<PublishFailed>CB: publish %d failed, reason=%d\n", publishId, (int)reason);
}

static int PublishServiceInterface()
{
    PublishInfo info = {
        .publishId = DEFAULT_PUBLISH_ID,
        .mode = DISCOVER_MODE_PASSIVE,
        .medium = COAP,
        .freq = LOW,
        .capability = DEFAULT_CAPABILITY,
        .capabilityData = NULL,
        .dataLen = 0,
    };
    IPublishCallback cb = {
        .OnPublishSuccess = PublishSuccess,
        .OnPublishFail = PublishFailed,
    };
    return PublishService(PACKAGE_NAME, &info, &cb);
}

static void UnPublishServiceInterface(void)
{
    int ret = UnPublishService(PACKAGE_NAME, DEFAULT_PUBLISH_ID);
    if (ret != 0) {
        printf("UnPublishService fail:%d\n", ret);
    }
}

static void DeviceFound(const DeviceInfo *device)
{
    unsigned int i;
    printf("<DeviceFound>CB: Device has found\n");
    printf("\tdevId=%s\n", device->devId);
    printf("\tdevName=%s\n", device->devName);
    printf("\tdevType=%d\n", device->devType);
    printf("\taddrNum=%d\n", device->addrNum);
    for (i = 0; i < device->addrNum; i++) {
        printf("\t\taddr%d:type=%d,", i + 1, device->addr[i].type);
        switch (device->addr[i].type) {
            case CONNECTION_ADDR_WLAN:
            case CONNECTION_ADDR_ETH:
                printf("ip=%s,port=%d,", device->addr[i].info.ip.ip, device->addr[i].info.ip.port);
                break;
            default:
                break;
        }
        printf("peerUid=%s\n", device->addr[i].peerUid);
    }
    printf("\tcapabilityBitmapNum=%d\n", device->capabilityBitmapNum);
    for (i = 0; i < device->addrNum; i++) {
        printf("\t\tcapabilityBitmap[%d]=0x%x\n", i + 1, device->capabilityBitmap[i]);
    }
    printf("\tcustData=%s\n", device->custData);
    printf("Result: The peer device is successfully discovered.\n");
}

static void DiscoverySuccess(int subscribeId)
{
    printf("<DiscoverySuccess>CB: discover subscribeId=%d\n", subscribeId);
}

static void DiscoveryFailed(int subscribeId, DiscoveryFailReason reason)
{
    printf("<DiscoveryFailed>CB: discover subscribeId=%d failed, reason=%d\n", subscribeId, (int)reason);
}

static int DiscoveryInterface(void)
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
    return StartDiscovery(PACKAGE_NAME, &info, &cb);
}

static void StopDiscoveryInterface(void)
{
    int ret = StopDiscovery(PACKAGE_NAME, DEFAULT_PUBLISH_ID);
    if (ret) {
        printf("StopDiscovery fail:%d\n", ret);
    }
}

int main(int argc, char **argv)
{
    bool loop = true;
    int ret;

    ret = PublishServiceInterface();
    if (ret) {
        printf("PublishService fail, ret=%d\n", ret);
    }

    ret = DiscoveryInterface();
    if (ret) {
        printf("DiscoveryInterface fail, ret=%d\n", ret);
        goto err_DiscoveryInterface;
    }
    while (loop) {
        printf("\nInput c to commnuication, Input s to stop:");
        char op = getchar();
    }

    StopDiscoveryInterface();
err_DiscoveryInterface:
    UnPublishServiceInterface();
    return 0;
}
