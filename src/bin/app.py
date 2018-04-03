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


class IASApplication(IASInfra):

	def setup(self):
		self.log_info("Setting up.")
	
	def tear_down(self):
		self.log_info("Tearing down.")
		
	def main(self):
		self.log_info("In main.")



if __name__ == '__main__':
	app = IASApplication(__file__)
	app.run()
