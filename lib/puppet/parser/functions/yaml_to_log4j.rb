# Returns an array of 5 hashes, in exactly this order:
#  - Hash of log4j::configfile
#  - Hash of log4j::logger
#  - Hash of log4j::appenders::console
#  - Hash of log4j::appenders::file
#  - Hash of log4j::appenders::rollingfile
# The intention is that these hashes can then be called with
# the create_resources() function

module Puppet::Parser::Functions

  newfunction(:yaml_to_log4j, :type => :rvalue) do |args|

    raise Puppet::ParseError, 'Wrong parameter type. yaml_to_log4j takes a Hash as single parameter.' unless args[0].is_a? Hash

    configfiles            = args[0]
    loggers                = {}
    appenders              = {}
    console_appenders      = {}
    rolling_file_appenders = {}
    file_appenders         = {}

    # Extract loggers and appenders
    configfiles.each do |key, value|
      loggers.merge!(value.delete('loggers').each { |logger,attributes| attributes['path'] = key.to_s})
      appenders.merge!(value.delete('appenders').each { |appender,attributes| attributes['path'] = key.to_s})
    end

    # Classify appenders by type
    appenders.each do |key,value|
      console_appenders[key]      = appenders[key] if value['type'] =~ /^console$/i
      rolling_file_appenders[key] = appenders[key] if value['type'] =~ /^rollingfile$/i
      file_appenders[key]         = appenders[key] if value['type'] =~ /^file$/i
      appenders[key].delete('type')
    end

    [configfiles, loggers, console_appenders, file_appenders, rolling_file_appenders]
  end
end
