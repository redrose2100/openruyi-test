#include <iostream>

void func2(int value) {
    std::cout << "Inside func2: " << value << std::endl;
}

void func1(int value) {
    std::cout << "Inside func1" << std::endl;
    func2(value);
}

int main() {
    int num = 42;
    std::cout << "Inside main" << std::endl;
    func1(num);
    return 0;
}