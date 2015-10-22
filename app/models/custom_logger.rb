class CustomLogger

  def initialize(logfile)
    @logfile = logfile
    @messages = []
  end

  def format_message(severity, timestamp, msg)
    "[#{severity}] #{timestamp.to_formatted_s(:db)} #{msg}\n"
  end

  def info(message)
    @messages << {:severity => 'INFO', :timestamp => Time.now, :message => message}
  end

  def warn(message)
    @messages << {:severity => 'WARN', :timestamp => Time.now, :message => message}
  end

  def flush
    @logfile.flock(File::LOCK_EX)
    @messages.each do |message|
      @logfile.write(format_message(message[:severity], message[:timestamp], message[:message]))
    end
    @logfile.flush
    @logfile.flock(File::LOCK_UN)
    @messages = []
  end
end