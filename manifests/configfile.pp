define log4j::configfile(
  $path            = $name,
  $user            = 'root',
  $group           = 'root',
  $mode            = '0644',
  $replace         = false,
  $monitorInterval = '30',
  $rootLevel       = 'ERROR',
  $xmllint         = true,
){
  validate_re($path, '.+\.xml$')
  validate_absolute_path($path)
  validate_re($rootLevel, '^(?i:OFF|FATAL|ERROR|WARN|INFO|DEBUG|TRACE|ALL)$')
  validate_bool($replace)
  validate_re($monitorInterval, '^\d+$')
  validate_bool($xmllint)

  file {$path:
    ensure  => present,
    owner   => $user,
    group   => $group,
    mode    => $mode,
    replace => $replace,
    content => template('log4j/base.xml.erb'),
  }

  # Apply all changes after the base skeleton has been installed
  Augeas <| incl == $name |> { require => File[$name]}

  if ($xmllint){
    $xmllint_package = $::osfamily? {
      /^(?i:Debian|Ubuntu)$/ => 'libxml2-utils',
      /^(?i:RedHat|CentOS)$/ => 'libxml2',
    }
    if ! defined(Package[$xmllint_package]){
      package{ $xmllint_package:
        ensure => installed
      }
    }
    exec{"lint-${name}":
      command     => "xmllint --format --output ${path} ${path}",
      path        => '/bin/:/usr/bin:/sbin',
      refreshonly => true,
    }

    # All changes trigger a new linting
    Augeas <| incl == $name |> { notify => Exec["lint-${name}"]}
  }
}