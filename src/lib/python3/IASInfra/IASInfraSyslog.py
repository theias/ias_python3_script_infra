from syslog import *

class IASInfraSyslog:
	def setup_IAS_infra_logging(self, script_name):
		openlog(script_name,LOG_PID)
	
	def log_debug(self, message):
		syslog(LOG_DEBUG, message)
	
	def log_info(self, message):
		syslog(LOG_INFO, message)
	
	def log_notice(self, message):
		syslog(LOG_NOTICE, message)
	
	def log_warning(self, message):
		syslog(LOG_WARNING, message)
	
	def log_error(self, message):
		syslog(LOG_ERR, message)
	
	def log_critical(self, message):
		syslog(LOG_CRIT, message)
	
	def log_alert(self, message):
		syslog(LOG_ALERT, message)
	
	def log_emergency(self, message):
		syslog(LOG_EMERG, message)
