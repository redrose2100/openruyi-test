# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yihaolin01@foxmail.com
# @Contact   :   yihaolin01@foxmail.com
# @Modify    :   ss_wang@foxmail.com
# @Date      :   2022/03/26
# @License   :   Mulan PSL v2
# @Desc      :   Add new certificate
# #############################################
import tensorflow as tf
# Create a model using high-level tf.keras.* APIs
model = tf.keras.models.Sequential([
        tf.keras.layers.Dense(units=1, input_shape=[1]),
            tf.keras.layers.Dense(units=16, activation='relu'),
                tf.keras.layers.Dense(units=1)
                ])
model.compile(optimizer='sgd', loss='mean_squared_error') # compile the model
model.fit(x=[-1, 0, 1], y=[-3, -1, 1], epochs=5) # train the model
tf.saved_model.save(model, "saved_model_keras_dir")
model.save_weights('./my_ckpt')