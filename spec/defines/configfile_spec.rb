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
      :monitorInterval => '60',
  }}

  it { should compile.with_all_deps }
  it { should contain_log4j__configfile('test')}

  it { should contain_file('/tmp/test.xml').with({
     'ensure' => 'present',
     'owner'  => 'batman',
     'group'  => 'heroes',
     'mode'   => '0644',
     })}

  it { should contain_file('/tmp/test.xml').with_content(/monitorInterval="60"/)}

  context 'when the path is invalid' do
    let(:params) {{
        :path => '/tmp/'
    }}
    it { should_not compile }
  end
end