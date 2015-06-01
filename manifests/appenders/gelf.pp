define log4j::appenders::gelf(
  $path,
  $server           = 'localhost',
  $port             = '12201',
  $hostname         = 'localhost',
  $protocol         = 'UDP',
  $layout           = '%m%n',
  $additionalfields = '',

){

  validate_re($path, '.+\.xml$')
  validate_absolute_path($path)
  validate_re($port, '^\d+$')
  validate_re($protocol, 'TCP|tcp|UDP|udp')

  augeas {"appender-${name}":
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/name '${name}'",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/server ${server}",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/port ${port}",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/hostName ${hostname}",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/protocol ${protocol}",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/additionalFields '${additionalfields}'",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/layout '${layout}'",
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