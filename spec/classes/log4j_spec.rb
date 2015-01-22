require 'spec_helper'

describe 'log4j' do
  let(:facts) {
    {:operatingsystemrelease => '6.5',
     :osfamily               => 'RedHat',
     :operatingsystem        => 'CentOS',
     :kernel                 => 'Linux',
    } }
  let(:params) {{
      :path => '/tmp/test.xml'
  }}

   it { should compile.with_all_deps }

   it { should contain_file('/tmp/test.xml')}

  context 'when the path is invalid' do
    let(:params) {{
        :path => '/tmp/'
    }}
    it { should_not compile }
  end
end