# puppet-log4j

This is a puppet module to manage your log4j2 configuration programatically.
It provides types for loggers and appenders so that your final log4j config can be generated
either from Hiera data or from Puppet manifests.

## Installation

From the Forge:
```
puppet module install danielgil-log4j
```

Cloning from Github into your **$MODULEPATH** directory:
```
git clone https://github.com/danielgil/log4j.git /etc/puppetlabs/puppet/modules/log4j
```

## Usage

TBD

## Limitations

1. For now, log4j::appenders::file only uses 'PatternLayout' and does not accept Filters.


## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
