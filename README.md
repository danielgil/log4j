# puppet-log4j

This is a puppet module to manage your log4j2 configuration programatically.
It provides types for loggers and appenders so that your final log4j config can be generated
either from Hiera data or from Puppet manifests.

## Installation

From the Forge:
```
puppet module install danielgil-log4j
```

Cloning from Github into your `$MODULEPATH` directory, e.g.:
```
git clone https://github.com/danielgil/log4j.git /etc/puppetlabs/puppet/modules/log4j
```

## Usage (from Hiera)
To generate a log4j.xml directly from a Yaml file, you can use a structure of nested hashes:

1. Top level: configuration file paths, e.g. `/tmp/config.xml`. This element has
two required elements, `loggers` and `appenders`, plus the normal optional parameters of the `log4j::configfile` class.
2. `Loggers` is a hash of hashes representing each logger. See the parameters of `log4j::logger`.
3. `Appenders` is a hash of hashes representing each appender. Notice the `type` parameter can be `console`,
`file` or `rollingfile`.


Full example:
```
---
log4j::data:
    '/tmp/config.xml':
        loggers:
            my.class:
                level     : 'INFO'
                additivity: true
            other.class:
                level     : 'ERROR'
                additivity: true
        appenders:
            appender1:
                type    : 'file'
                filename: '/opt/otherapp/logs/access.log'
                follow  : true
  '/opt/otherapp.xml':
        user     : tomcat
        group    : tomcat
        mode     : 0644
        loggers  :
            my.awesome.class:
                level     : 'INFO'
                additivity: true
        appenders:
            someappender:
                type  : 'console'
                layout: '%m%n'
            anotherappender:
                type          : 'rollingfile'
                layout        : '%d{ISO8601} [%t] %-2p %c{1} %m%n'
                policy_startup: false
                policy_size   : '200 Mb'
            anotherappender:
                type          : 'gelf'
                layout        : '%d{ISO8601} [%t] %-2p %c{1} %m%n'
                protocol      : TCP
                server        : someserver.somedomain
                port          : 1234
```

## Usage (from Puppet Manifests)

#### Config Skeleton ####
Create skeleton configuration files with `log4j::configfile`.

Minimal:
```
log4j::configfile {'/tmp/config.xml':}
```

Full:
```
log4j::configfile {'/tmp/config.xml':
  user            => 'root',
  group           => 'root',
  mode            => '0644',
  monitorInterval => '40',
  rootLevel       => 'INFO',
  replace         => false,
  xmllint         => true,
}
```
The `xmllint` parameter, if set to true, will install `libxml2` and use it to format the
resulting log4j configuration file.

#### Add Appenders ####

The `File` appender writes to a file. Only `path` and `filename` are required.
```
log4j::appenders::file {'somefile':
  path     => $xmlpath,
  filename => '/tmp/somelog.log',
  append               => true,
  bufferedio           => true,
  buffersize           => '8192',
  immediateflush       => true,
  locking              => false,
  ignoreexceptions     => true,
  layout   => '%d{ISO8601} [%t] %-2p %c{1} %m%n',
}
```

The `Console` appender writes to either the system's standard output or error.
Only `path` is required.
```
log4j::appenders::console {'stdout':
  path     => '/tmp/config.xml,
  follow   => true,
  target   => 'SYSTEM_ERR',
  ignoreexceptions => true,
  layout   => '%m%n',
}
```

The `RollingFile` appender is similar to the `File`, except that you can control *when*
the file is rolled using the 3 `policy` parameters, and *how* the file is renamed using
the 4 `strategy parameters`.

It's worth noting that the `policy` parameters can be combined.

```
log4j::appenders::rollingfile {'rollbaby':
  path                 => '/tmp/config.xml,
  filename             => '/tmp/somelog.log',
  append               => true,
  bufferedio           => true,
  buffersize           => '8192',
  immediateflush       => true,
  ignoreexceptions     => true,
  layout               => '%d{ISO8601} [%t] %-2p %c{1} %m%n',
  filepattern          => 'logs/$${date:yyyy-MM}/app-%d{MM-dd-yyyy}-%i.log',
  strategy_compression => '0',
  strategy_min         => '1',
  strategy_max         => '10',
  strategy_fileindex   => 'max',
  policy_startup       => true,
  policy_size          => '',
  policy_time          => '',
}
```

The `GELF` appender connects to a Graylog server on a GELF TCP or GELF UDP input.
Only `path` is required.
```
log4j::appenders::gelf {'example':
  path             => '/tmp/config.xml,
  protocol         => 'TCP',
  server           => 'somegraylogserver.somedomain',
  port             => '12201',
  layout           => '%m%n',
  hostname         => 'myserver.somedomain',
  additionalfields => 'key1=value1,key2=value2',
}
```

#### Add Loggers ####
To To add a logger for a specific class, use the name of the class as the name of the `logger`.

```
log4j::logger {'my.class':
  path       => '/tmp/config.xml',
  level      => 'INFO',
  additivity => true,
}
```

## Limitations

1. Supported appenders: `Console`, `File`, `RollingFile` and `Gelf`.
2. For now, `File` and `RollingFile` only use `PatternLayout` and do not accept `Filters`.

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
