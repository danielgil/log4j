require 'spec_helper'

describe 'log4j::appenders::rollingfile' do
  let(:title) { 'test' }
  let(:facts) {
    {:operatingsystemrelease => '6.5',
     :osfamily               => 'RedHat',
     :operatingsystem        => 'CentOS',
     :kernel                 => 'Linux',
    } }
  let(:params) {{
      :path           => '/tmp/test.xml',
      :filename       => '/tmp/somelog.log',
      :policy_startup => false,
      :policy_size    => '',
      :policy_time    => '',
  }}

  it { should contain_log4j__appenders__rollingfile('test')}

  it { should_not contain_augeas('appender-test-timepolicy')}
  it { should_not contain_augeas('appender-test-sizepolicy')}
  it { should_not contain_augeas('appender-test-startuppolicy')}

  it { should contain_augeas('appender-test').with({
         'incl'    => '/tmp/test.xml',
         'lens'    => 'Xml.lns',
         'changes' => [
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/#attribute/name 'test'",
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/#attribute/append true",
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/#attribute/bufferedIO true",
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/#attribute/bufferSize 8192",
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/#attribute/fileName '/tmp/somelog.log'",
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/#attribute/immediateFlush true",
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/#attribute/ignoreExceptions true",
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/DefaultRolloverStrategy/#attribute/fileIndex max",
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/DefaultRolloverStrategy/#attribute/min 1",
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/DefaultRolloverStrategy/#attribute/max 10",
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/DefaultRolloverStrategy/#attribute/compressionLevel 0",
             "set Configuration/Appenders/RollingFile[./#attribute/name = 'test']/PatternLayout/#attribute/pattern '%d{ISO8601} [%t] %-2p %c{1} %m%n'",
         ]
      })}
  it { should contain_augeas('appenderref-test').with({
         'incl'    => '/tmp/test.xml',
         'lens'    => 'Xml.lns',
         'changes' => [
             "set Configuration/Loggers/Root/AppenderRef[./#attribute/ref = 'test']/#attribute/ref test",
         ]
     })}

  context 'when time policy is enabled' do
    let(:params) {{
        :path           => '/tmp/test.xml',
        :filename       => '/tmp/somelog.log',
        :policy_time    => '1',
    }}
    it { should contain_augeas('appender-test-timepolicy')}
  end

  context 'when startup policy is enabled' do
    let(:params) {{
        :path           => '/tmp/test.xml',
        :filename       => '/tmp/somelog.log',
        :policy_startup => true,
    }}
    it { should contain_augeas('appender-test-startuppolicy')}
  end

  context 'when size policy is enabled' do
    let(:params) {{
        :path           => '/tmp/test.xml',
        :filename       => '/tmp/somelog.log',
        :policy_size    => '200 MB',
    }}
    it { should contain_augeas('appender-test-sizepolicy')}
  end

end