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
      :path => '/tmp/test.xml',
  }}

  it { should compile.with_all_deps }
  it { should contain_log4j__appenders__rollingfile('test')}

  it { should contain_augeas('appender-test') }

  it { should contain_augeas('appenderref-test').with({
         'incl'    => '/tmp/test.xml',
         'lens'    => 'Xml.lns',
         'changes' => [
            "set Configuration/Loggers/Root/AppenderRef[./#attribute/ref = 'test']/#attribute/ref test",
         ]
      })}

end