require 'spec_helper'

describe 'log4j::appenders::console' do
  let(:title) { 'test' }
  let(:facts) {
    {:operatingsystemrelease => '6.5',
     :osfamily               => 'RedHat',
     :operatingsystem        => 'CentOS',
     :kernel                 => 'Linux',
    } }
  let(:params) {{
      :path => '/tmp/test.xml',
      :target => 'SYSTEM_OUT',
      :ignoreexceptions => false,
  }}

  it { should compile.with_all_deps }
  it { should contain_log4j__appenders__console('test')}

  it { should contain_augeas('appender-test').with({
       'incl'    => '/tmp/test.xml',
       'lens'    => 'Xml.lns',
       'changes' => [
         "set Configuration/Appenders/Console[./#attribute/name = 'test']/#attribute/name 'test'",
         "set Configuration/Appenders/Console[./#attribute/name = 'test']/#attribute/follow true",
         "set Configuration/Appenders/Console[./#attribute/name = 'test']/#attribute/target SYSTEM_OUT",
         "set Configuration/Appenders/Console[./#attribute/name = 'test']/#attribute/ignoreExceptions false",
         "set Configuration/Appenders/Console[./#attribute/name = 'test']/PatternLayout/#attribute/pattern '%m%n'",
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