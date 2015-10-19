Spree::Admin::ReportsController.class_eval do
  def initialize
    super
    Spree::Admin::ReportsController.add_available_report!(:sales_total)
    Spree::Admin::ReportsController.add_available_report!(:sources_statistics)
    Spree::Admin::ReportsController.add_available_report!(:custom_log)
  end

  def sources_statistics
    @sources = SourceCounter.all
  end

  def custom_log
    @logs = File.open(CUSTOM_LOGFILE){|f| f.readlines.last(250)}
  end

  def custom_log_download
    send_file CUSTOM_LOGFILE.path
  end
end
