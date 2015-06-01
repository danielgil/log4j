require 'spec_helper'

describe 'log4j' do
  let(:facts) {
    {:operatingsystemrelease => '6.5',
     :osfamily               => 'RedHat',
     :operatingsystem        => 'CentOS',
     :kernel                 => 'Linux',
    } }
  let(:params) {{
    :data => {
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
            'gelfappender' => {
                'type'           => 'gelf',
                'protocol'       => 'UDP',
                'layout'         => '%-2p %c{1} %m%n',
            }
          }
        }
    }
  }}

  it { should contain_log4j__configfile('/tmp/somefile.xml')}
  it { should contain_log4j__configfile('/tmp/otherfile.xml')}
  it { should contain_log4j__logger('com.example.my.class').with({
         'path'       => '/tmp/somefile.xml',
         'level'      => 'INFO',
         'additivity' => true,
     })}
  it { should contain_log4j__logger('com.example.my.other.class') }
  it { should contain_log4j__logger('com.someorg.some.class') }
  it { should contain_log4j__logger('com.someorg.another.class') }
  it { should contain_log4j__appenders__console('appender1') }
  it { should contain_log4j__appenders__file('otherappender').with({
         'path'     => '/tmp/otherfile.xml',
         'filename' => '/opt/otherapp/logs/access.log',
         'layout'   => '%-2p %c{1} %m%n'
     })}
  it { should contain_log4j__appenders__rollingfile('someappender') }
  it { should contain_log4j__appenders__gelf('gelfappender') }
end