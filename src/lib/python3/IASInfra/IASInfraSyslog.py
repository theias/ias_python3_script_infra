from __future__ import print_function

from syslog import *

import sys

# I plan on adding logging to files here.  This is more of a placeholder to
# just get something working.
# I'm aware of https://docs.python.org/3.1/library/logging.html
# but I haven't thought of how I'd incorporate it into a framework.

class IASInfraSyslog:
    def setup_IAS_infra_logging(self, script_name):
        openlog(script_name,LOG_PID)
    
    def log_debug(self, message):
        if self.log_to_stderr:
            self.log_eprint('LOG_DEBUG ', message)
            
        syslog(LOG_DEBUG, message)
    
    def log_info(self, message):
        if self.log_to_stderr:
            self.log_eprint('LOG_INFO', message)
            
        syslog(LOG_INFO, message)
    
    def log_notice(self, message):
        if self.log_to_stderr:
            self.log_eprint('LOG_NOTICE', message)
            
        syslog(LOG_NOTICE, message)
    
    def log_warning(self, message):
        self.log_eprint('LOG_WARNIN', message)
        syslog(LOG_WARNING, message)
    
    def log_error(self, message):
        self.log_eprint('LOG_ERR', message)
        syslog(LOG_ERR, message)
    
    def log_critical(self, message):
        self.log_eprint('LOG_CRIT', message)
        syslog(LOG_CRIT, message)
    
    def log_alert(self, message):
        self.log_eprint('LOG_ALERT', message)
        syslog(LOG_ALERT, message)
    
    def log_emergency(self, message):
        self.log_eprint('LOG_EMERG', message)
        syslog(LOG_EMERG, message)
    
    def log_eprint(self, *args, **kwargs):
        print(*args, file=sys.stderr, **kwargs)
