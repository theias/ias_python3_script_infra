from .IASInfraLogger import *
from .IASInfraDispatcher import *
from .IASInfraFullProjectPaths import *

from datetime import *

import os
import sys

import pprint

class IASInfra(
	IASInfraLogger,
	IASInfraDispatcher,
	IASInfraFullProjectPaths,
):
	def __init__(self, script_name):
		self.setup_IAS_infra_logging(script_name)
		
		self.script_file = os.path.basename(script_name)
		
		self.script_name_without_extension, self.script_extension = os.path.splitext(self.script_file)
		self.paths={}
		
		self.paths['real_bin'] = os.path.dirname(os.path.abspath(os.path.realpath(script_name)))
		self.paths['bin'] = os.path.dirname(os.path.abspath(script_name))
	
		self.default_bin_whence = 'real_bin'

		self.bin_whence = self.default_bin_whence
		
		self.do_base_path_calculations()
		self.log_debug_variables()

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

		file_name_components = [
			self.script_name_without_extension,
			datetime.now().strftime('%Y-%m-%d-%H-%M-%S'),
			label + '.' + extension,
		]
		
		full_path_name = os.sep.join([
			output_dir,
			*['--'.join(file_name_components)],
		])
		
		return full_path_name

    	
