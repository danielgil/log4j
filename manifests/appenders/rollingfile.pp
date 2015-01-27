define log4j::appenders::rollingfile(
  $path,
  $filename,
  $append=true,
  $bufferedio=true,
  $buffersize='8192',
  $immediateflush=true,
  $ignoreexceptions=true,
  $layout='%d{ISO8601} [%t] %-2p %c{1} %m%n',
  $filepattern='logs/$${date:yyyy-MM}/app-%d{MM-dd-yyyy}-%i.log.gz',
  $policy_startup = true,
  $policy_size = '',
  $policy_time = '',
  $strategy_min = '1',
  $strategy_max = '10',
  $strategy_compression = '0',
  $strategy_fileindex = 'max'
){
  # Path validation
  validate_re($path, '.+\.xml$')
  validate_absolute_path($path)

  # Validate that the buffersize is a number
  validate_re($buffersize, '^\d+$')

  # Boolean parameter validation
  validate_bool($append)
  validate_bool($bufferedio)
  validate_bool($immediateflush)
  validate_bool($ignoreexceptions)

  # Strategy attributes validation
  validate_re($strategy_fileindex, '^(?i:min|max){0,1}$')
  validate_re($strategy_compression, '^[0-9]{0,1}$')
  validate_re($strategy_min, '^\d+$')
  validate_re($strategy_max, '^\d+$')

  # Policy attributes validation
  validate_bool($policy_startup)
  validate_re($policy_size, '^(?i:\d+\s?[MKG]B){0,1}$')
  validate_re($policy_time, '^([1-9]){0,1}$')

  if $policy_time != '' {
    $time_changes = "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/Policies/TimeBasedTriggeringPolicy/#attribute/interval '${policy_time}'"
    augeas{"appender-${name}-timepolicy":
      incl    =>  $path,
      lens    => 'Xml.lns',
      changes => $time_changes,
      require => Augeas["appender-${name}"]
    }
  }
  if $policy_size != '' {
    $size_changes = "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/Policies/SizeBasedTriggeringPolicy/#attribute/size '${policy_size}'"
    augeas{"appender-${name}-sizepolicy":
      incl    =>  $path,
      lens    => 'Xml.lns',
      changes => $size_changes,
      require => Augeas["appender-${name}"]
    }
  }
  if $policy_startup == true {
    $startup_changes = "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/Policies/OnStartupTriggeringPolicy ''"
    augeas{"appender-${name}-startuppolicy":
      incl    =>  $path,
      lens    => 'Xml.lns',
      changes => $startup_changes,
      require => Augeas["appender-${name}"]
    }
  }

  $appenderchanges =[
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/name '${name}'",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/append ${append}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/bufferedIO ${bufferedio}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/bufferSize ${buffersize}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/fileName '${filename}'",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/immediateFlush ${immediateflush}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/ignoreExceptions ${ignoreexceptions}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/DefaultRolloverStrategy/#attribute/fileIndex ${strategy_fileindex}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/DefaultRolloverStrategy/#attribute/min ${strategy_min}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/DefaultRolloverStrategy/#attribute/max ${strategy_max}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/DefaultRolloverStrategy/#attribute/compressionLevel ${strategy_compression}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/PatternLayout/#attribute/pattern '${layout}'",
  ]

  augeas {"appender-${name}":
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => $appenderchanges,
    require => Log4j::Configfile[$path]
  }

  augeas {"appenderref-${name}":
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Loggers/Root/AppenderRef[./#attribute/ref = '${name}']/#attribute/ref ${name}",
    ],
    require => Log4j::Configfile[$path]
  }
}