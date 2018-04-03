from .IASInfraLogger import *
from .IASInfraDispatcher import *
from .IASInfraFullProjectPaths import *

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
		
		self.paths={}
		
		self.paths['real_bin'] = os.path.dirname(os.path.abspath(os.path.realpath(script_name)))
		self.paths['bin'] = os.path.dirname(os.path.abspath(script_name))
	
		self.default_bin_whence = 'real_bin'

		self.bin_whence = self.default_bin_whence
		
		self.are_we_in_src()
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
		self.log_debug("real_bin:" + self.paths['real_bin'])
		self.log_debug("bin: " + self.paths['bin'])
