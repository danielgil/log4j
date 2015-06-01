require 'spec_helper'

describe 'log4j::appenders::gelf' do
  let(:title) { 'test' }
  let(:facts) {
    {:operatingsystemrelease => '6.5',
     :osfamily               => 'RedHat',
     :operatingsystem        => 'CentOS',
     :kernel                 => 'Linux',
    } }
  let(:params) {{
      :path     => '/tmp/test.xml',
      :server   => 'someserver.somedomain',
      :port     => '1234',
      :protocol => 'TCP',
      :layout   => '%m abcd%n',
  }}

  it { should contain_log4j__appenders__gelf('test')}

  it { should contain_augeas('appender-test').with({
       'incl'    => '/tmp/test.xml',
       'lens'    => 'Xml.lns',
       'changes' => [
         "set Configuration/Appenders/GELF[./#attribute/name = 'test']/#attribute/name 'test'",
         "set Configuration/Appenders/GELF[./#attribute/name = 'test']/#attribute/server someserver.somedomain",
         "set Configuration/Appenders/GELF[./#attribute/name = 'test']/#attribute/port 1234",
         "set Configuration/Appenders/GELF[./#attribute/name = 'test']/#attribute/hostName localhost",
         "set Configuration/Appenders/GELF[./#attribute/name = 'test']/#attribute/protocol TCP",
         "set Configuration/Appenders/GELF[./#attribute/name = 'test']/#attribute/additionalFields ''",
         "set Configuration/Appenders/GELF[./#attribute/name = 'test']/#attribute/layout '%m abcd%n'",
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