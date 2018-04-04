#!/usr/bin/python3

import os
import sys

sys.path.insert(0, '/opt/IAS/lib/python3')
sys.path.insert(0,
    os.path.abspath(
        os.path.join(
            os.path.dirname(
                os.path.realpath(__file__)
            ), '../lib/python3'
        )
    )
)

from IASInfra import IASInfra

# Change "IASApplication" to whatever you want to call your app:
class IASApplication(IASInfra):

    def setup(self):
        self.log_info("Setting up.")
    
    def tear_down(self):
        self.log_info("Tearing down.")
        
    def main(self):
        self.log_info("In main.")
        
        # Use this to see what variables are available.
        # Currently, inconsistent and was used for testing.
        self.log_debug_variables()

        generic_output_file = self.get_generic_output_file_name('extract','txt')
        self.log_info(
            "Generic output file: "
            + generic_output_file
        )
        text_file = open(generic_output_file, "w")
        text_file.write('Here is an extract.')
        text_file.close



if __name__ == '__main__':
    app = IASApplication(__file__)
    # Set the environment variable, IASInfra_log_to_stderr, to something non-zero
    # to enable debugging to stderr.
    # Example:  export IASInfra_log_to_stderr=1
    app.run()
