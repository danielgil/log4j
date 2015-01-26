require 'spec_helper'

describe 'yaml_to_log4j' do

    # Empty hash as argument
    it { should run.with_params({}).and_return([{},{},{},{},{}]) }

    # Argument that is not a hash
    it { should run.with_params('notahash').and_raise_error(Puppet::ParseError) }

    # Full check
    input = {
        '/tmp/somefile.xml' => {
            'user'    => 'tomcat',
            'group'   => 'tomcat',
            'loggers' => {
                'com.example.my.class' => {
                    'level'      => 'INFO',
                    'additivity' => true
                },
                'com.example.my.other.class' => {
                    'level'      => 'ERROR',
                    'additivity' => true
                }
            },
            'appenders' => {
                'appender1' => {
                    'type'   => 'console',
                    'follow' => true,
                    'layout' => '%m%n'
                }
            }
        },
        '/tmp/otherfile.xml' => {
            'loggers' => {
                'com.someorg.some.class' => {
                    'level'      => 'ERROR',
                    'additivity' => true
                },
                'com.someorg.another.class' => {
                    'level'      => 'ERROR',
                    'additivity' => false
                }
            },
            'appenders' => {
                'someappender' => {
                    'type'           => 'rollingfile',
                    'filename'       => '/opt/someapp/logs/error.log',
                    'layout'         => '%d{ISO8601} [%t] %-2p %c{1} %m%n',
                    'policy_startup' => false,
                    'policy_size'    => '200 Mb'
                },
                'otherappender' => {
                    'type'           => 'file',
                    'filename'       => '/opt/otherapp/logs/access.log',
                    'layout'         => '%-2p %c{1} %m%n',
                }
            }
        }
    }

    output = [
        # log4j::configfile
        {'/tmp/somefile.xml' => {'user' => 'tomcat', 'group' => 'tomcat'},
         '/tmp/otherfile.xml'=> {}},
        # log4j::logger
        {'com.example.my.class'       => {'path' => '/tmp/somefile.xml', 'level' => 'INFO', 'additivity' => true},
         'com.example.my.other.class' => {'path' => '/tmp/somefile.xml', 'level' => 'ERROR', 'additivity' => true},
         'com.someorg.some.class'     => {'path' => '/tmp/otherfile.xml', 'level' => 'ERROR', 'additivity' => true},
         'com.someorg.another.class'  => {'path' => '/tmp/otherfile.xml', 'level' => 'ERROR', 'additivity' => false}},
        # log4j::appenders::console
        {'appender1' => {'path' => '/tmp/somefile.xml',
                         'follow' => true,
                         'layout' => '%m%n'}},
        # log4j::appenders::file
        {'otherappender' => { 'path'     => '/tmp/otherfile.xml',
                              'filename' => '/opt/otherapp/logs/access.log',
                              'layout'   => '%-2p %c{1} %m%n'

        }},
        # log4j::appenders::rollingfile
        {'someappender' => {'path'           => '/tmp/otherfile.xml',
                            'filename'       => '/opt/someapp/logs/error.log',
                            'layout'         => '%d{ISO8601} [%t] %-2p %c{1} %m%n',
                            'policy_startup' => false,
                            'policy_size'    => '200 Mb'}}
    ]

    it { should run.with_params(input).and_return(output) }
end