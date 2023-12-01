#include <iostream>
void recursiveFunction(int depth) {
    int data[8]; // Allocate some data on the stack
    if (depth > 0) {
        recursiveFunction(depth - 1);
    }
}

int main() {
    // Call the recursive function to allocate stack space
    recursiveFunction(10);

    std::cout << "Stack allocated." << std::endl;

    return 0;
}