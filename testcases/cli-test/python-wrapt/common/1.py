import wrapt

@wrapt.decorator
def log_call(wrapped, instance, args, kwargs):
    print(f"Calling {wrapped.__name__} with args {args} and kwargs {kwargs}")
    return wrapped(*args, **kwargs)

# 使用装饰器
@log_call
def my_function(a, b=2):
    print(f"a = {a}, b = {b}")

my_function(1)
my_function(a=3, b=4)
