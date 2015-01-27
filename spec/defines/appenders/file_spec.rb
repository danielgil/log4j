require 'spec_helper'

describe 'log4j::appenders::file' do
  let(:title) { 'test' }
  let(:facts) {
    {:operatingsystemrelease => '6.5',
     :osfamily               => 'RedHat',
     :operatingsystem        => 'CentOS',
     :kernel                 => 'Linux',
    } }
  let(:params) {{
    :path => '/tmp/test.xml',
    :filename => '/tmp/somelog.log',
  }}

  it { should contain_log4j__appenders__file('test')}

  it { should contain_augeas('appender-test').with({
       'incl'    => '/tmp/test.xml',
       'lens'    => 'Xml.lns',
       'changes' => [
           "set Configuration/Appenders/File[./#attribute/name = 'test']/#attribute/name 'test'",
           "set Configuration/Appenders/File[./#attribute/name = 'test']/#attribute/append true",
           "set Configuration/Appenders/File[./#attribute/name = 'test']/#attribute/bufferedIO true",
           "set Configuration/Appenders/File[./#attribute/name = 'test']/#attribute/bufferSize 8192",
           "set Configuration/Appenders/File[./#attribute/name = 'test']/#attribute/fileName '/tmp/somelog.log'",
           "set Configuration/Appenders/File[./#attribute/name = 'test']/#attribute/immediateFlush true",
           "set Configuration/Appenders/File[./#attribute/name = 'test']/#attribute/locking false",
           "set Configuration/Appenders/File[./#attribute/name = 'test']/#attribute/ignoreExceptions true",
           "set Configuration/Appenders/File[./#attribute/name = 'test']/PatternLayout/#attribute/pattern '%d{ISO8601} [%t] %-2p %c{1} %m%n'",
       ]
     })}

  it { should contain_augeas('appenderref-test').with({
       'incl'    => '/tmp/test.xml',
       'lens'    => 'Xml.lns',
       'changes' => [
           "set Configuration/Loggers/Root/AppenderRef[./#attribute/ref = 'test']/#attribute/ref test",
       ]
      })}

end