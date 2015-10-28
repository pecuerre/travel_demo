CUSTOM_LOGFILE = File.open('log/custom_logger.log', File::CREAT|File::APPEND|File::RDWR)
CUSTOM_LOGFILE.sync = true