/**
 * @title:测试PublishService发布特定服务能力函数，
 *    入参PACKAGE_NAME为正常、&info为空、&cb为正常
 */
#include "dsoftbus_common.h"

static int PublishService_NullInfo()
{
    PublishInfo info = {
    };
    IPublishCallback cb = {
        .OnPublishSuccess = PublishSuccess,
        .OnPublishFail = PublishFailed,
    };
    return PublishService(PACKAGE_NAME, &info, &cb);
}

int main(int argc, char **argv)
{
    int ret;

    ret = PublishService_NullInfo();
    if (ret) {
        printf("PublishService fail, ret = %d\n", ret);
        return 1;
    }
    else {
        printf("PublishService success, ret = %d\n", ret);
        return 0;
    }
}