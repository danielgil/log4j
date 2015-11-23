define log4j::appender (
  $additionalfields = undef,
  $append = undef,
  $bufferedio = undef,
  $buffersize = undef,
  $filename = undef,
  $filepattern = undef,
  $follow = undef,
  $hostname = undef,
  $ignoreexceptions = undef,
  $immediateflush = undef,
  $layout = undef,
  $locking = undef,
  $path,
  $policy_startup = undef,
  $policy_size = undef,
  $policy_time = undef,
  $port = undef,
  $protocol = undef,
  $server = undef,
  $strategy_min = undef,
  $strategy_max = undef,
  $strategy_compression = undef,
  $strategy_fileindex = undef,
  $target = undef,
  $type = undef,
) {

  validate_re($type, '^(file|console|rollingfile|syslog|gelf)$')
  if $type == 'file' {
    log4j::appender::file { $title:
      path             => $path,
      filename         => $filename,
      append           => $append,
      bufferedio       => $bufferedio,
      immediateflush   => $immediateflush,
      locking          => $locking,
      ignoreexceptions => $ignoreexceptions,
      layout           => $layout,
    }
  } elsif $type == 'console' {
    log4j::appender::console { $title:
      path             => $path,
      follow           => $follow,
      target           => $target,
      ignoreexceptions => $ignoreexceptions,
      layout           => $layout,
    }
  } elsif $type == 'rollingfile' {
    log4j::appender::rollingfile { $title:
      path                 => $path,
      filename             => $filename,
      append               => $append,
      bufferedio           => $bufferedio,
      buffersize           => $buffersize,
      immediateflush       => $immediateflush,
      ignoreexceptions     => $ignoreexceptions,
      layout               => $layout,
      filepattern          => $filepattern,
      policy_startup       => $policy_startup,
      policy_size          => $policy_size,
      policy_time          => $policy_time,
      strategy_min         => $strategy_min,
      strategy_max         => $strategy_max,
      strategy_compression => $strategy_compression,
      strategy_fileindex   => $strategy_fileindex,
    }
  } elsif $type == 'syslog' {
    log4j::appender::syslog { $title:
      path => $path,
    }
  } else {
    log4j::appender::gelf { $title:
      path             => $path,
      server           => $server,
      port             => $port,
      hostname         => $hostname,
      protocol         => $protocol,
      layout           => $layout,
      additionalfields => $additionalfields,
    }
  }

}
