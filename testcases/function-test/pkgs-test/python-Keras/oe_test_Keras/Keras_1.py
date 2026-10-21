import numpy as np
from keras.models import Model
from keras.layers import Input, Dense

if __name__ == '__main__':
    # 创建函数化模型
    a = Input(shape=(100,))
    b = Dense(100)(a)
    model = Model(inputs=a, outputs=b)

    # 编译
    model.compile(optimizer='rmsprop',
                  loss='binary_crossentropy',
                  metrics=['accuracy'])

    # 学习
    data = np.random.random((1000, 100))
    labels = np.random.randint(2, size=(1000, 100))
    model.fit(data, labels, epochs=10, batch_size=32)

    # 测试
    model.predict(data, batch_size=None, verbose=0, steps=None, callbacks=None)
    exit(0)

