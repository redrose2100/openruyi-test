#include <iostream>
#include <unistd.h>
#include <stdio.h>
int main() {
    std::cout << "Main process: PID = " << getpid() << std::endl;

    pid_t childPid = fork(); // Create a child process

    fprintf(stdout, "This is standard output.\n");
    fprintf(stderr, "This is standard error.\n");
    if (childPid == 0) {
        // This is the child process
        std::cout << "Child process: PID = " << getpid() << std::endl;
        return 1;
    } else if (childPid > 0) {
        // This is the parent process
        std::cout << "Parent process: Created child with PID = " << childPid << std::endl;
    } else {
        std::cerr << "Failed to fork" << std::endl;
        return 1;
    }

    return 0;
}