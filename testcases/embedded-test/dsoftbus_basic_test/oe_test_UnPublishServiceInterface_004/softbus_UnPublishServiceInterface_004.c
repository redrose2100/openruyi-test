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

#define PACKAGE_NAME "softbus_sample"
#define DEFAULT_CAPABILITY "osdCapability"
#define DEFAULT_PUBLISH_ID 123
#define UnPACKAGE_NAME "softbus_sample"
#define UnDEFAULT_PUBLISH_ID 0

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

int main(int argc, char **argv)
{
    PublishServiceInterface();
    int ret = UnPublishService(UnPACKAGE_NAME, UnDEFAULT_PUBLISH_ID);
    if (ret) {
        printf("UnPublishService fail:%d\n", ret);
        return 1;
    }
    else {
        printf("UnPublishService success:%d\n", ret);
        return 0;
    }
}