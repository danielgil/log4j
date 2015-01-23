require 'spec_helper'

describe 'log4j::configfile' do
  let(:title) { 'test' }
  let(:facts) {
    {:operatingsystemrelease => '6.5',
     :osfamily               => 'RedHat',
     :operatingsystem        => 'CentOS',
     :kernel                 => 'Linux',
    } }
  let(:params) {{
      :path            => '/tmp/test.xml',
      :user            => 'batman',
      :group           => 'heroes',
      :mode            => '0644',
      :replace         => true,
      :monitorInterval => '60',
      :rootLevel       => 'INFO',
  }}

  it { should compile.with_all_deps }
  it { should contain_log4j__configfile('test')}

  it { should contain_file('/tmp/test.xml').with({
     'ensure'  => 'present',
     'owner'   => 'batman',
     'group'   => 'heroes',
     'mode'    => '0644',
     'replace' => true,
     })}

  it { should contain_file('/tmp/test.xml').with_content(/monitorInterval="60"/)}
  it { should contain_file('/tmp/test.xml').with_content(/Root level="INFO"/)}


  context 'when the path is invalid' do
    let(:params) {{
        :path => '/tmp/'
    }}
    it { should_not compile }
  end

  context 'when monitorInterval is not a digit' do
    let(:params) {{
        :path            => '/tmp/',
        :monitorInterval => 'notadigit',
    }}
    it { should_not compile }
  end

  context 'when rootLevel is not a log4j level' do
    let(:params) {{
        :path      => '/tmp/',
        :rootLevel => 'NOTALEVEL',
    }}
    it { should_not compile }
  end

end