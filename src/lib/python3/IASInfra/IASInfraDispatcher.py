class IASInfraDispatcher:
    def run(self):
    
        self.log_start()
        
        if hasattr(self.__class__, 'setup') and callable(getattr(self.__class__, 'setup')):
            self.setup()
    
        self.main()
    
        if hasattr(self.__class__, 'tear_down') and callable(getattr(self.__class__, 'tear_down')):
            self.tear_down()
        
        self.log_end()

