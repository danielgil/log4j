require 'spec_helper'

describe 'log4j::logger' do
  let(:title) { 'test.class' }
  let(:facts) {
    {:operatingsystemrelease => '6.5',
     :osfamily               => 'RedHat',
     :operatingsystem        => 'CentOS',
     :kernel                 => 'Linux',
    } }
  let(:params) {{
      :path       => '/tmp/test.xml',
      :level      => 'ERROR',
      :additivity => true,
  }}

  it { should contain_log4j__logger('test.class')}

  it { should contain_augeas('test.class').with({
      'incl'    => '/tmp/test.xml',
      'lens'    => 'Xml.lns',
      'changes' => [
          "set Configuration/Loggers/Logger[./#attribute/name = 'test.class']/#attribute/name test.class",
          "set Configuration/Loggers/Logger[./#attribute/name = 'test.class']/#attribute/level ERROR",
          "set Configuration/Loggers/Logger[./#attribute/name = 'test.class']/#attribute/additivity true",
      ]

  })}

  context 'when additivity is not a bool' do
    let(:params) {{
        :path       => '/tmp/test.xml',
        :level      => 'ERROR',
        :additivity => 'notabool',
    }}
    it { should_not compile }
  end

  context 'when level is not one of the log4j levels' do
    let(:params) {{
        :path       => '/tmp/test.xml',
        :level      => 'NOTALEVEL',
        :additivity => true,
    }}
    it { should_not compile }
  end

end