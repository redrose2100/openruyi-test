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

#define PACKAGE_NAME NULL
#define LOCAL_SESSION_NAME "session_test"

static int g_sessionId;

static int SessionOpened(int sessionId, int result)
{
    printf("<SessionOpened>CB: session %d open fail:%d\n", sessionId, result);
    if (result == 0) {
        g_sessionId = sessionId;
    }

    return result;
}

static void SessionClosed(int sessionId)
{
    printf("<SessionClosed>CB: session %d closed\n", sessionId);
}

static void ByteRecived(int sessionId, const void *data, unsigned int dataLen)
{
    printf("<ByteRecived>CB: session %d received %u bytes data=%s\n", sessionId, dataLen, (const char *)data);
}

static void MessageReceived(int sessionId, const void *data, unsigned int dataLen)
{
    printf("<MessageReceived>CB: session %d received %u bytes message=%s\n", sessionId, dataLen, (const char *)data);
}

static int CreateSessionServerInterface(void)
{
    const ISessionListener sessionCB = {
        .OnSessionOpened = SessionOpened,
        .OnSessionClosed = SessionClosed,
        .OnBytesReceived = ByteRecived,
        .OnMessageReceived = MessageReceived,
    };

    return CreateSessionServer(PACKAGE_NAME, LOCAL_SESSION_NAME, &sessionCB);
}

int main(int argc, char **argv)
{
    int ret = CreateSessionServerInterface();
    if (ret) {
        printf("CreateSessionServer fail:%d\n", ret);
        return 1;
    }
    else {
        printf("CreateSessionServer success:%d\n", ret);
        return 0;
    }
}