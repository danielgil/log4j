define log4j::appender::file(
  $path,
  $filename,
  $append,
  $bufferedio,
  $buffersize,
  $immediateflush,
  $locking,
  $ignoreexceptions,
  $layout,
){
  $append_real = pick($append, true)
  $bufferedio_real = pick($bufferedio, true)
  $buffersize_real = pick($buffersize, '8192')
  $immediateflush_real = pick($immediateflush, true)
  $locking_real = pick($locking, false)
  $ignoreexceptions_real = pick($ignoreexceptions, true)
  $layout_real = pick($layout, '%d{ISO8601} [%t] %-2p %c{1} %m%n')

  validate_re($path_real, '.+\.xml$')
  validate_absolute_path($path)
  validate_re($buffersize_real, '^\d+$')
  validate_bool($append_real)
  validate_bool($bufferedio_real)
  validate_bool($immediateflush_real)
  validate_bool($locking_real)
  validate_bool($ignoreexceptions_real)

  augeas {"appender-${name}":
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/name '${name}'",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/append ${append_real}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/bufferedIO ${bufferedio_real}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/bufferSize ${buffersize_real}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/fileName '${filename}'",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/immediateFlush ${immediateflush_real}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/locking ${locking_real}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/ignoreExceptions ${ignoreexceptions_real}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/PatternLayout/#attribute/pattern '${layout_real}'",
    ],
  }

  augeas {"appenderref-${name}":
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Loggers/Root/AppenderRef[./#attribute/ref = '${name}']/#attribute/ref ${name}",
    ],
  }
}
