define log4j::configfile(
  $path            = $name,
  $user            = 'root',
  $group           = 'root',
  $mode            = '0644',
  $monitorInterval = '30',
  $rootLevel       = 'ERROR',
){
  validate_re($path, '.+\.xml$')
  validate_absolute_path($path)
  validate_re($rootLevel, '^(OFF|FATAL|ERROR|WARN|INFO|DEBUG|TRACE|ALL)$')

  file {$path:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => $mode,
    content => template('log4j/base.xml.erb'),
  }

}