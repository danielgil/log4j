require 'spec_helper_acceptance'

describe 'A server where we run the log4j Puppet module' do

      it 'should generate the log4j configuration with no errors' do
        pp = <<-EOS
          $allow_virtual_packages = false

          $xmlpath = '/tmp/test.xml'

          log4j::configfile {'test':
            path            => $xmlpath,
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
            require  => Log4j::Configfile['test']
          }

          log4j::appenders::console {'stdout':
            path     => $xmlpath,
            target   => 'SYSTEM_OUT',
            ignoreexceptions => false,
            layout   => '%L - %m%n',
            require  => Log4j::Configfile['test']
          }

          log4j::appenders::rollingfile {'rollbaby':
            path                 => $xmlpath,
            filename             => '/tmp/somelog.log',
            layout               => '%d{ISO8601} [%t] %-2p %c{1} %m%n',
            strategy_compression => '5',
            policy_startup       => true,
            policy_size          => '250 MB',
            policy_time          => '1',
            require              => Log4j::Configfile['test']
          }

          log4j::logger {'first.test':
            path       => $xmlpath,
            level      => 'INFO',
            additivity => true,
            require  => Log4j::Configfile['test']
          }

          log4j::logger {'second.test':
            path       => $xmlpath,
            level      => 'ERROR',
            additivity => false,
            require  => Log4j::Configfile['test']
          }

        EOS

        expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq 2
        # Test twice for idempotency
        expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq 0
      end
end
