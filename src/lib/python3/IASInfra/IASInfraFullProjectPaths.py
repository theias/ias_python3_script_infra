import os

class IASInfraFullProjectPaths:
	def do_base_path_calculations(self):
		if self.are_we_in_src():
			self.up_path_components=['..']
			self.project_name=self.script_path_components[-3]
		else:
			self.installed_package_name=self.script_path_components[-2]
			self.up_path_components=['..','..',self.installed_package_name]
	
	def get_generic_project_directory(self, dir_name):
		if self.are_we_in_src():
			return os.path.join(
				self.paths[self.bin_whence],
				*self.up_path_compoents,
				dir_name
			)
		else:
			return os.path.join(
				self.paths[self.bin_whence],
				*self.up_path_components,
				dir_name,
				self.installed_package_name
			)
