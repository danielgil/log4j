define log4j::appender::rollingfile(
  $path,
  $filename,
  $append,
  $bufferedio,
  $buffersize,
  $immediateflush,
  $ignoreexceptions,
  $layout,
  $filepattern,
  $policy_startup,
  $policy_size,
  $policy_time,
  $strategy_min,
  $strategy_max,
  $strategy_compression,
  $strategy_fileindex,
){
  # Path validation
  validate_re($path, '.+\.xml$')
  validate_absolute_path($path)

  $append_real = pick($append, true)
  $bufferedio_real = pick($bufferedio, true)
  $buffersize_real = pick($buffersize, '8192')
  $immediateflush_real = pick($immediateflush, true)
  $ignoreexceptions_real = pick($ignoreexceptions, true)
  $layout_real = pick($layout, '%d{ISO8601} [%t] %-2p %c{1} %m%n')
  $filepattern_real = pick($filepattern, 'logs/$${date:yyyy-MM}/app-%d{MM-dd-yyyy}-%i.log.gz')
  $policy_startup_real = pick($policy_startup, true)
  $policy_size_real = pick($policy_size, '')
  $policy_time_real = pick($policy_time, '')
  $strategy_min_real = pick($strategy_min, '1')
  $strategy_max_real = pick($strategy_max, '10')
  $strategy_compression_real = pick($strategy_compression, '0')
  $strategy_fileindex_real = pick($strategy_fileindex, 'max')

  # Validate that the buffersize is a number
  validate_re($buffersize_real, '^\d+$')

  # Boolean parameter validation
  validate_bool($append_real)
  validate_bool($bufferedio_real)
  validate_bool($immediateflush_real)
  validate_bool($ignoreexceptions_real)

  # Strategy attributes validation
  validate_re($strategy_fileindex_real, '^(?i:min|max){0_real,1}$')
  validate_re($strategy_compression_real, '^[0-9]{0_real,1}$')
  validate_re($strategy_min_real, '^\d+$')
  validate_re($strategy_max_real, '^\d+$')

  # Policy attributes validation
  validate_bool($policy_startup_real)
  validate_re($policy_size_real, '^(?i:\d+\s?[MKG]B){0_real,1}$')
  validate_re($policy_time_real, '^([1-9]){0_real,1}$')

  if $policy_time_real != '' {
    $time_changes = "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/Policies/TimeBasedTriggeringPolicy/#attribute/interval '${policy_time_real}'"
    augeas{"appender-${name}-timepolicy":
      incl    =>  $path,
      lens    => 'Xml.lns',
      changes => $time_changes,
      require => Augeas["appender-${name}"]
    }
  }
  if $policy_size_real != '' {
    $size_changes = "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/Policies/SizeBasedTriggeringPolicy/#attribute/size '${policy_size_real}'"
    augeas{"appender-${name}-sizepolicy":
      incl    =>  $path,
      lens    => 'Xml.lns',
      changes => $size_changes,
      require => Augeas["appender-${name}"]
    }
  }
  if $policy_startup_real == true {
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
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/append ${append_real}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/bufferedIO ${bufferedio_real}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/bufferSize ${buffersize_real}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/fileName '${filename}'",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/immediateFlush ${immediateflush_real}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/#attribute/ignoreExceptions ${ignoreexceptions_real}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/DefaultRolloverStrategy/#attribute/fileIndex ${strategy_fileindex_real}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/DefaultRolloverStrategy/#attribute/min ${strategy_min_real}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/DefaultRolloverStrategy/#attribute/max ${strategy_max_real}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/DefaultRolloverStrategy/#attribute/compressionLevel ${strategy_compression_real}",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/PatternLayout/#attribute/pattern '${layout_real}'",
  ]

  augeas {"appender-${name}":
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => $appenderchanges,
  }

  augeas {"appenderref-${name}":
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Loggers/Root/AppenderRef[./#attribute/ref = '${name}']/#attribute/ref ${name}",
    ],
  }
}
