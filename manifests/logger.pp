define log4j::logger($path, $level, $additivity){

  validate_bool($additivity)
  validate_re($level, '^(?i:OFF|FATAL|ERROR|WARN|INFO|DEBUG|TRACE|ALL)$')

  augeas {$name:
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Loggers/Logger[./#attribute/name = '${name}']/#attribute/name ${name}",
      "set Configuration/Loggers/Logger[./#attribute/name = '${name}']/#attribute/level ${level}",
      "set Configuration/Loggers/Logger[./#attribute/name = '${name}']/#attribute/additivity ${additivity}",
    ]
  }


}