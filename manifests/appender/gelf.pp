define log4j::appender::gelf(
  $path,
  $server           = 'localhost',
  $port             = '12201',
  $hostname         = 'localhost',
  $protocol         = 'UDP',
  $layout           = '%m%n',
  $additionalfields = '',
){

  $server_real = pick($server, 'localhost')
  $port_real = pick($port, '12201')
  $hostname_real = pick($hostname, 'localhost')
  $protocol_real = pick($protocol, 'UDP')
  $layout_real = pick($layout, '%m%n')
  $additionalfields_real = pick($additionalfields, '')

  validate_re($path, '.+\.xml$')
  validate_absolute_path($path)
  validate_re($port_real, '^\d+$')
  validate_re($protocol_real, 'TCP|tcp|UDP|udp')

  augeas {"appender-${name}":
    incl    =>  $path,
    lens    => 'Xml.lns',
    changes => [
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/name '${name}'",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/server ${server_real}",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/port ${port_real}",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/hostName ${hostname_real}",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/protocol ${protocol_real}",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/additionalFields '${additionalfields_real}'",
      "set Configuration/Appenders/GELF[./#attribute/name = '${name}']/#attribute/layout '${layout_real}'",
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
