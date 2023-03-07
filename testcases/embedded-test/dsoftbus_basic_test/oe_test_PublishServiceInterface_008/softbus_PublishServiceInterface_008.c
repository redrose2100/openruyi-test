/**
 * @title:测试PublishService发布特定服务能力函数，
 *    入参PACKAGE_NAME为NULL、&info为空、&cb为空
 */
#include "dsoftbus_common.h"

static int PublishService_AllNull()
{
    PublishInfo info = {
    };
    IPublishCallback cb = {
    };
    return PublishService(NULL, &info, &cb);
}

int main(int argc, char **argv)
{
    int ret;

    ret = PublishService_AllNull();
    if (ret) {
        printf("PublishService fail, ret = %d\n", ret);
        return 1;
    }
    else {
        printf("PublishService success, ret = %d\n", ret);
        return 0;
    }
}