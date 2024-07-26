from tempita import Template

def test_tempita_functionality():
    try:
        template_string = "Hello, {{ name }}!"
        template = Template(template_string)
        rendered_template = template.substitute(name="Alice")
        assert rendered_template == "Hello, Alice!"
        print("Python3-tempita.noarch test passed.")
    except AssertionError as e:
        print("Assertion error in Python3-tempita.noarch test:", str(e))
    except Exception as e:
        print("Python3-tempita.noarch test failed:", str(e))

if __name__ == '__main__':
    test_tempita_functionality()
