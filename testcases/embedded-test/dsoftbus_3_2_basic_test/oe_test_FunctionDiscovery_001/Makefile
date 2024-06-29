TARGET = FunctionDiscovery_001
SRC = dsoftbus_FunctionDiscovery_001.c  ../common/dsoftbus_common.c
OBJ = ${SRC:.c=.o}

LIBS = -lsoftbus_client.z -ldeviceauth_sdk.z  -lbegetutil.z  -lcjson -lboundscheck

CFLAGS = -Wall -g -I../common -I=/usr/include/dsoftbus/ -I=/usr/include/hilog/ -I=/usr/include/device_auth/ -I=/usr/include/init/

.PHNOY:all
all: ${TARGET}

${TARGET} : ${OBJ}
	${CC}  ${CFLAGS}  ${LIBS} $^ -o $@
${OBJ}:%.o:%.c
	${CC} ${CFLAGS} ${LIBS} -c $< -o $@

.PHNOY: clean
clean:
	-rm -rf ${TARGET} ${OBJ}
