TARGET = UnPublishServiceInterface_001
SRC = dsoftbus_UnPublishServiceInterface_001.c  ../common/dsoftbus_common.c
OBJ = ${SRC:.c=.o}

LIBS = -lsoftbus_client.z -ldeviceauth_sdk.z  -lsyspara.z  -lcjson -lboundscheck

CFLAGS = -Wall -g -I../common

.PHNOY:all
all: ${TARGET}

${TARGET} : ${OBJ}
	${CC}  ${CFLAGS}  ${LIBS} $^ -o $@
${OBJ}:%.o:%.c
	${CC} ${CFLAGS} ${LIBS} -c $< -o $@

.PHNOY: clean
clean:
	-rm -rf ${TARGET} ${OBJ}
