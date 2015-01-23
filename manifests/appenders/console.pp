define log4j::appenders::console(
  $path,
  $follow = true,
  $target = 'SYSTEM_ERR',
  $ignoreexceptions = true,
  $layout = '%m%n',
){

  validate_re($path, '.+\.xml$')
  validate_absolute_path($path)
  validate_bool($follow)
  validate_re($target, 'SYSTEM_OUT|SYSTEM_ERR')

  augeas {"appender-${name}":
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Appenders/Console[./#attribute/name = '${name}']/#attribute/name '${name}'",
      "set Configuration/Appenders/Console[./#attribute/name = '${name}']/#attribute/follow ${follow}",
      "set Configuration/Appenders/Console[./#attribute/name = '${name}']/#attribute/target ${target}",
      "set Configuration/Appenders/Console[./#attribute/name = '${name}']/#attribute/ignoreExceptions ${ignoreexceptions}",
      "set Configuration/Appenders/Console[./#attribute/name = '${name}']/PatternLayout/#attribute/pattern '${layout}'",
    ]
  }

  augeas {"appenderref-${name}":
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Loggers/Root/AppenderRef[./#attribute/ref = '${name}']/#attribute/ref ${name}",
    ]
  }
}