#include <iostream>
#include <cstring>


void test01() {
  char* p = new char[8];
}

void test02() {
  static char* p = new char[8];
}

class Object {
public:
  Object() { _p = new char[8]; }
  ~Object() { if(_p) delete _p; }
private:
  char* _p = nullptr;
};

void test03() {
  Object* obj = new Object();
};

void test04() {
  char* data = new char[8];
  static char* p = data + 1;
}

void test05(){
    int* ptr = new int;
    delete[] ptr; 
}

void test06(){
  for (int i = 0; i < 10; ++i) {
    int uninitialized_variable;
    printf("%d\n", uninitialized_variable);
  }
}

int main() {
  test01(); // definitely lost
  test02(); // still reachable
  test03(); // indirectly lost
  test04(); // possibly lost
  test05(); // --show-mismatched-frees
  test06(); // --error-limit 
  int x;
  int y=x+5;
  return 0;
}