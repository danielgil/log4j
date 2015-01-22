class log4j(
  $path,
  $user  = 'root',
  $group = 'root',
  $mode  = '0644',
){
  validate_re($path, '.+\.xml$')

  file {$path:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => $mode,
    content => template('log4j/base.xml.erb'),
  }

  create_resources()
  augeas {'foo.xml':
      incl    =>  '/tmp/foo.xml',
      context =>  '/files/tmp/foo.xml/foo',
      lens    => 'Xml.lns',
      changes => [
        'set bar/#text herp',
      ]
  }

}
