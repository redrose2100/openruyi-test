import tensorflow as tf

def tsst_tensorflow():
    hello = tf.constant('Hello, TensorFlow!')
    output = hello.numpy()
    expected_output = b'Hello, TensorFlow!'
    assert output == expected_output, f"Expected: {expected_output}, but got: {output.decode('utf-8')}"
    print("Assertion passed. Test successful!")

if __name__ == '__main__':
    tsst_tensorflow()
