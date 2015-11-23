define log4j::appender::console(
  $path,
  $follow,
  $target,
  $ignoreexceptions,
  $layout,
){

  $layout_real = pick($layout, '%m%n')
  $ignoreexceptions_real = pick($ignoreexceptions, true)
  $target_real = pick($target, 'SYSTEM_ERR')
  $follow_real = pick($follow, true)

  validate_re($path, '.+\.xml$')
  validate_absolute_path($path)
  validate_bool($follow_real)
  validate_re($target_real, 'SYSTEM_OUT|SYSTEM_ERR')

  augeas {"appender-${name}":
    incl    => $path,
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Appenders/Console[./#attribute/name = '${name}']/#attribute/name '${name}'",
      "set Configuration/Appenders/Console[./#attribute/name = '${name}']/#attribute/follow ${follow_real}",
      "set Configuration/Appenders/Console[./#attribute/name = '${name}']/#attribute/target ${target_real}",
      "set Configuration/Appenders/Console[./#attribute/name = '${name}']/#attribute/ignoreExceptions ${ignoreexceptions_real}",
      "set Configuration/Appenders/Console[./#attribute/name = '${name}']/PatternLayout/#attribute/pattern '${layout_real}'",
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
