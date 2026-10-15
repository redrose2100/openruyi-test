from functools import singledispatch

@singledispatch
def myfunc(arg):
    print(f"default implementation:{arg}")

@myfunc.register
def _(arg: int):
    print(f"handling int:{arg}")

@myfunc.register
def _(arg: str):
    print(f"handling str:{arg}")

@myfunc.register
def _(arg: list):
    print(f"handling list:{arg}")

myfunc(42)
myfunc("hello")
myfunc([1, 2, 3])
myfunc((1, 2, 3))
