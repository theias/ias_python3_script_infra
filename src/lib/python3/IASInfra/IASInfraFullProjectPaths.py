import os

class IASInfraFullProjectPaths:
	def do_base_path_calculations(self):
		if self.are_we_in_src():
			self.up_path_components=['..']
			self.project_name=self.script_path_components[-3]
		else:
			self.installed_package_name=self.script_path_components[-1]
			self.up_path_components=['..','..']
	
		
	
	def get_generic_project_directory(self, dir_name):
		if self.are_we_in_src():
			return os.sep.join([
				self.paths[self.bin_whence],
				*self.up_path_components,
				dir_name,
			])

		else:
			return os.sep.join([
				self.paths[self.bin_whence],
				*self.up_path_components,
				dir_name,
				self.installed_package_name,
			])

	def bin_dir(self):
		return self.paths[self.bin_whence]
	
	def input_dir(self):
		return self.get_generic_project_directory('input')

	def output_dir(self):
		return self.get_generic_project_directory('output')

	def conf_dir(self):
		return self.get_generic_project_directory('etc')
	
	def log_dir(self):
		return self.get_generic_project_directory('log')

	def script_output_dir(self):
		project_output_dir = self.output_dir()
		script_output_dir = os.sep.join([
			project_output_dir,
			self.script_name_without_extension
		])
		
		return script_output_dir
