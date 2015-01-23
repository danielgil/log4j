define log4j::configfile(
  $path            = $name,
  $user            = 'root',
  $group           = 'root',
  $mode            = '0644',
  $replace         = false,
  $monitorInterval = '30',
  $rootLevel       = 'ERROR',
){
  validate_re($path, '.+\.xml$')
  validate_absolute_path($path)
  validate_re($rootLevel, '^(?i:OFF|FATAL|ERROR|WARN|INFO|DEBUG|TRACE|ALL)$')
  validate_bool($replace)
  validate_re($monitorInterval, '^\d+$')

  file {$path:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => $mode,
    replace => $replace,
    content => template('log4j/base.xml.erb'),
  }

}