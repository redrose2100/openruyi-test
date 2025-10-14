
#include <iostream>
#include <unistd.h>
#include <sys/wait.h>
#include <vector>
#include <cstring>

const size_t GB40 = 40UL * 1024 * 1024 * 1024; // 40GB in bytes

void allocate_memory() {
    try {
        char* huge_mem = new char[GB40];
        memset(huge_mem, 0, GB40); 
	std::cout << "Process " << getpid() << " allocated 40GB memory" << std::endl;
	while (true) {
            for (size_t i = 0; i < GB40; i++) {
                huge_mem[i] += i % 256;
	    }
	}    
        delete[] huge_mem;
    } catch (const std::bad_alloc& e) {
        std::cerr << "Memory allocation failed: " << e.what() << std::endl;
        exit(EXIT_FAILURE);
    }
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <num_processes(1-4)>" << std::endl;
        return EXIT_FAILURE;
    }

    int num_processes = std::stoi(argv[1]);

    std::vector<pid_t> child_pids;
    for (int i = 0; i < num_processes; ++i) {
        pid_t pid = fork();
        if (pid == 0) {
            allocate_memory();
            return EXIT_SUCCESS;
        } else if (pid > 0) {
            child_pids.push_back(pid);
        } else {
            std::cerr << "Fork failed" << std::endl;
            return EXIT_FAILURE;
        }
    }

    for (pid_t pid : child_pids) {
        waitpid(pid, nullptr, 0);
    }

    return EXIT_SUCCESS;
}

