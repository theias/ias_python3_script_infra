from .IASInfraLogger import *
from .IASInfraDispatcher import *
from .IASInfraFullProjectPaths import *

import os
import sys

class IASInfra(
	IASInfraLogger,
	IASInfraDispatcher,
	IASInfraFullProjectPaths,
):
	def __init__(self, script_name):
		self.setup_IAS_infra_logging(script_name)
		
		self.real_bin=os.path.abspath(os.path.realpath(script_name))
		self.bin=os.path.abspath(script_name)
	
		self.log_debug_variables()
	
	def log_debug_variables(self):	
		self.log_debug("real_bin:" + self.real_bin)
		self.log_debug("bin: " + self.bin)
