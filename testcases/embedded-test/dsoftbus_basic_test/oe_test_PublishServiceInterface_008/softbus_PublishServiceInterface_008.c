/**
 * @ttitle:测试PublishService发布特定服务能力函数，入参PACKAGE_NAME为NULL、&info为空、&cb为空
 */
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

#define PACKAGE_NAME NULL
#define DEFAULT_CAPABILITY "osdCapability"
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
    };
    IPublishCallback cb = {
    };
    return PublishService(PACKAGE_NAME, &info, &cb);
}

int main(int argc, char **argv)
{
    int ret;

    ret = PublishServiceInterface();
    if (ret) {
        printf("PublishService fail, ret = %d\n", ret);
        return 1;
    }
    else {
        printf("PublishService success, ret = %d\n", ret);
        return 0;
    }
}