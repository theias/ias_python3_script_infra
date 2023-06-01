#!/usr/bin/python3
"""An example application for using IASInfra

This is a description of your project.

"""
__author__ = "Your Name <your-email@example.com"
__credits__ = """
Infrastructure Design: Martin VanWinkle, Institute for Advanced Study
"""

import os
import sys

sys.path.insert(0, '/opt/IAS/lib/python3')
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), '../lib/python3'))) # pylint: disable=line-too-long

# pylint: disable=wrong-import-position
from IAS.Infra import IASInfra

# Change "IASApplication" to whatever you want to call your app:
class IASApplication(IASInfra):
    """ This app does something. """
    def setup(self):
        """ This is where you setup. """
        self.log_info("Setting up.")

    def tear_down(self):
        """ This is where you tear down. """
        self.log_info("Tearing down.")

    def main(self):
        """ This is where the work gets done """
        self.log_info("In main.")

        # Use this to see what variables are available.
        # Currently, inconsistent and was used for testing.
        self.log_debug_variables()

        generic_output_file = self.get_generic_output_file_name('extract', 'txt')
        self.log_info(
            "Generic output file: "
            + generic_output_file
        )

        text_file = open(generic_output_file, "w")
        text_file.write("Here is an extract.\n")
        text_file.close # pylint: disable=pointless-statement



if __name__ == '__main__':
    APP = IASApplication(__file__)
    # Set the environment variable, IASInfra_log_to_stderr, to something non-zero
    # to enable debugging to stderr.
    # Example:  export IASInfra_log_to_stderr=1
    APP.run()
