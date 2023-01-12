#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "securec.h"
#include "discovery_service.h"
#include "softbus_bus_center.h"
#include "session.h"
#include <stdio.h>
#include <cJSON.h>
#include <securec.h>
#include <softbus_common.h>
#include <device_auth.h>
#include <parameter.h>

#define PACKAGE_NAME 123
#define DEFAULT_CAPABILITY "osdCapability"
#define DEFAULT_PUBLISH_ID 123

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

int main(int argc, char **argv)
{
    int ret = DiscoveryInterface();
    if (ret) {
        printf("DiscoveryInterface fail, ret=%d\n", ret);
        return 1;
    }
    else{
    		printf("DiscoveryInterface success, ret=%d\n", ret);
    		return 0;
    }
}