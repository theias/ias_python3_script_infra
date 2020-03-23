from IAS.Infra import IASInfra

# Change "IASApplication" to whatever you want to call your app:
class IASSampleApplication(IASInfra):

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
        text_file.write("Here is an extract.\n")
        text_file.close

