#include<iostream>
#include<gmpxx.h>
using namespace std;
int main()
{
mpz_class a;
//计算2的1000次方，似乎C++就没有数学函数支持了？
a = 1;
for(int i = 0; i < 1000; i++)
    a *= 2;
cout<<"2^1000 = "<<a<<endl;
//计算-12345*9876543210123456789
mpz_class b, c;
       b = -12345;
       c = "98765432100123456789";
         cout<<"b * c = "<<b * c<<endl;
return 0;    
}
