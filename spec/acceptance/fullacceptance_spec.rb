require 'spec_helper_acceptance'

describe 'A server where we run the log4j Puppet module' do

      it 'should generate the log4j configuration with no errors' do
        pp = <<-EOS
          $allow_virtual_packages = false

          $xmlpath = '/tmp/test.xml'

          log4j::configfile {'/tmp/test.xml':
            user            => 'root',
            group           => 'root',
            mode            => '0644',
            monitorInterval => '40',
            rootLevel       => 'INFO',
            replace         => false,
          }

          log4j::appenders::file {'somefile':
            path     => $xmlpath,
            filename => '/tmp/somelog.log',
            layout   => '%d{ISO8601} [%t] %-2p %c{1} %m%n',
          }

          log4j::appenders::console {'stdout':
            path     => $xmlpath,
            target   => 'SYSTEM_OUT',
            ignoreexceptions => false,
            layout   => '%L - %m%n',
          }

          log4j::appenders::rollingfile {'rollbaby':
            path                 => $xmlpath,
            filename             => '/tmp/somelog.log',
            layout               => '%d{ISO8601} [%t] %-2p %c{1} %m%n',
            strategy_compression => '5',
            policy_startup       => true,
            policy_size          => '250 MB',
            policy_time          => '1',
          }

          log4j::appenders::gelf {'gelfy':
            path     => $xmlpath,
            protocol   => 'TCP',
            server     => 'someserver.somedomain',
            hostname   => 'localhost.localdomain',
            layout   => '%L - %m%n',
          }

          log4j::logger {'first.test':
            path       => $xmlpath,
            level      => 'INFO',
            additivity => true,
          }

          log4j::logger {'second.test':
            path       => $xmlpath,
            level      => 'ERROR',
            additivity => false,
          }

          $data = {
             '/tmp/somefile.xml' => {
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
                },
                'gelfyappender' => {
                    'type'           => 'gelf',
                    'protocol'       => 'TCP',
                    'layout'         => '%-2p %c{1} %m%n',
                }
              }
            }
          }

          class {log4j:
              data => $data
          }

        EOS

        expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq 2
        # Test twice for idempotency
        expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq 0
      end
end
