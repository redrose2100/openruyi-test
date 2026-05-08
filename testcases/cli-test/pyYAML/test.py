#!/usr/bin/python
# -*- coding: UTF-8 -*-
import os,sys
import yaml
def generate_yaml_doc(yaml_file):
    py_object = {'school': 'zhang','students': ['a', 'b']}
    file = open(yaml_file, 'w')
    yaml.dump(py_object, file)
    file.close()
current_path = os.path.abspath(".")
yaml_path = os.path.join(current_path, "generate.yaml")
generate_yaml_doc(yaml_path)