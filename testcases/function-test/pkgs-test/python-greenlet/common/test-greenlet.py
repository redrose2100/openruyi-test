from greenlet import greenlet

def T1():
    print("T1.1")
    gr2.switch() #switch gr2, enter T2
    print("T1.2")
    gr2.switch()

def T2():
    print("T2.1")
    gr1.switch() #switch gr1, enter T1
    print("T2.2")

gr1 = greenlet(T1)
gr2 = greenlet(T2)

gr1.switch() #run gr1 first ,namely T1

