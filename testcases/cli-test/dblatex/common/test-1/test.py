import sys
import os

def main(latex_file, stdout):
    """
    Texpost Plugin Entry point
    """
    # Let's find out the backend used
    tex_engine = os.environ["LATEX"]

    # Let's log something
    print("Plugin called on '%s' file" % (latex_file))

    # Open the latex file and parse it

    sys.exit(0)