#!/usr/bin/env python
import time
import os
import signal
import sys

#first parameter:How many zombie processes are created
#second parameter:After how mush time, the zombie process was killed
zombie_count=sys.argv[1]
zombie_time=sys.argv[2]
print (zombie_count)
print (zombie_time)
def make_zombie():
    parent_pid = -1
    ppid = os.fork()
    if ppid == 0:
        count = 0
        pid = -1
        while (count < float(zombie_count)):
            count = count + 1
            pid = os.fork()
            if pid == 0:
                break
        if pid == 0:
            os._exit(0)
        else:
            while 1:
                time.sleep(1)
        os._exit(0)
    else:
        parent_pid = ppid

    #print parent_pid
    # kill zombie after 10s
    time.sleep(float(zombie_time))
    if parent_pid != -1:
        os.kill(parent_pid, signal.SIGTERM)
        parent_pid = -1
    with open('/tmp/zombie_parent_pid', 'w') as f:
        f.write(str(ppid))

if __name__ == '__main__':
    make_zombie()
