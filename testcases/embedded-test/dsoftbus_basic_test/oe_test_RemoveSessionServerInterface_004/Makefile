TARGET = RemoveSessionServerInterface_004
OBJECTS = softbus_RemoveSessionServerInterface_004.o

LIBS = -lsoftbus_client.z -lsyspara.z -ldeviceauth_sdk.z -lsec_shared.z -lsoftbus_utils.z
CFLAGS=-Wall

.PHNOY:all
all: ${TARGET}
obj: ${OBJECTS}

${TARGET} : ${OBJECTS} Makefile
	${CC} -o ${TARGET} ${OBJECTS} ${LIBS}
%.o: %.c
	${CC} ${CFLAGS} -c $< 
.PHNOY: clean
clean:
	-rm -rf ${TARGET} ${OBJECTS}