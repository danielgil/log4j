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
  $strategy = 'fileIndex="max" min="1" max="10" compressionLevel="0"',
){

  if $policy_time != '' {
    $time_changes = "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/Policies/TimeBasedTriggeringPolicy/#text '${policy_time}'"
    augeas{"appender-${name}-timepolicy":
      incl    =>  $path,
      lens    => 'Xml.lns',
      changes => $time_changes,
      require => Augeas["appender-${name}"]
    }
  }
  if $policy_size != '' {
    $size_changes = "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/Policies/SizeBasedTriggeringPolicy/#text '${policy_size}'"
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
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/DefaultRolloverStrategy/#text '${strategy}'",
    "set Configuration/Appenders/RollingFile[./#attribute/name = '${name}']/PatternLayout/#attribute/pattern '${layout}'",
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
    ]
  }
}