define log4j::appenders::file(
  $path,
  $filename,
  $append=true,
  $bufferedio=true,
  $buffersize='8192',
  $immediateflush=true,
  $locking=false,
  $ignoreexceptions=true,
  $layout='%d{ISO8601} [%t] %-2p %c{1} %m%n'
){

  validate_re($path, '.+\.xml$')
  validate_absolute_path($path)
  validate_re($buffersize, '^\d+$')
  validate_bool($append)
  validate_bool($bufferedio)
  validate_bool($immediateflush)
  validate_bool($locking)
  validate_bool($ignoreexceptions)


  augeas {"appender-${name}":
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/name '${name}'",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/append ${append}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/bufferedIO ${bufferedio}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/bufferSize ${buffersize}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/fileName '${filename}'",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/immediateFlush ${immediateflush}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/locking ${locking}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/#attribute/ignoreExceptions ${ignoreexceptions}",
      "set Configuration/Appenders/File[./#attribute/name = '${name}']/PatternLayout/#attribute/pattern '${layout}'",
    ],
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