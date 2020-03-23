from IAS.Infra.Logger import *
from IAS.Infra.Dispatcher import *
from IAS.Infra.FullProjectPaths import *

from datetime import *

import os
import sys
import json
import getpass
import pprint

print("HAI\n")

class IASInfra(
    IASInfraLogger,
    IASInfraDispatcher,
    IASInfraFullProjectPaths,
):
    def __init__(self, script_name):
        
        # self.log_to_stderr = False
        
        # pp = pprint.PrettyPrinter(indent=4)
        # pp.pprint(os.environ)
        
        self.script_name = script_name
        
        if 'IASInfra_log_to_stderr' in os.environ:
            if os.environ['IASInfra_log_to_stderr'] != '0':
                self.log_to_stderr = True
            else:
                self.log_to_stderr = False
        else:
            self.log_to_stderr = False
        
        self.setup_IAS_infra_logging(script_name)
        
        self.script_file = os.path.basename(script_name)
        
        self.script_name_without_extension, self.script_extension = os.path.splitext(self.script_file)
        self.paths={}
        
        self.paths['real_bin'] = os.path.dirname(os.path.abspath(os.path.realpath(script_name)))
        self.paths['bin'] = os.path.dirname(os.path.abspath(script_name))
    
        self.default_bin_whence = 'real_bin'

        self.bin_whence = self.default_bin_whence
        
        self.do_base_path_calculations()


    def are_we_in_src(self):
        self.script_path_components = self.paths[self.bin_whence].split('/')
        
        # pp = pprint.PrettyPrinter(indent=4)
        # pp.pprint(self.script_path_components)
        # pp.pprint(self.paths)
        
        if self.script_path_components[-2] == 'src':
            return True
        return False
        # print("Maybe src dir: " + maybe_src_dir)

    def log_debug_variables(self):
        self.log_debug("************ Debugging variables")
        self.log_debug("Script name without extension: " + self.script_name_without_extension);
        self.log_debug("real_bin:" + self.paths['real_bin'])
        self.log_debug("bin: " + self.paths['bin'])
        
        self.log_debug('bin_dir ' + self.bin_dir())
        self.log_debug('input_dir ' + self.input_dir())
        self.log_debug('output_dir ' + self.output_dir())
        self.log_debug('conf_dir ' + self.conf_dir())
        self.log_debug('log_dir ' + self.log_dir())
        

    def create_script_output_dir(self):
        output_dir = self.script_output_dir()
                
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
        

    def get_generic_output_file_name(self,label='generic',extension='txt'):
        output_dir = self.script_output_dir()

        self.create_script_output_dir()

        file_name_components = [
            self.script_name_without_extension,
            datetime.now().strftime('%Y-%m-%d-%H-%M-%S'),
            label + '.' + extension,
        ]
        join_args = [output_dir]
        join_args.append('--'.join(file_name_components))

        full_path_name = os.sep.join(join_args)
        
        return full_path_name
    
    def log_start(self):
        self.log_info('%s : --BEGINNING--' % sys.argv[0])
        self.log_info('script file: %s' % os.path.realpath(self.script_name))
        self.log_info('User: %s' % getpass.getuser()) 
        self.log_info('Arguments: %s' % json.dumps(sys.argv))

    def log_end(self):
        self.log_info('%s --ENDING--' % sys.argv[0])
    
    def log_error_and_exit(self, message, exit_value):
        self.log_error(message)
        sys.exit(exit_value)
        
