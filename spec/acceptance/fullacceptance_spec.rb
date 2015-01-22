require 'spec_helper_acceptance'

describe 'A server where we run the ELK Puppet module' do

    context 'during the installation' do
      it 'should install ELK with no errors' do
        pp = <<-EOS
          $allow_virtual_packages = false
          include ::role::skye::test
        EOS

        expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq 2
        # Test twice for idempotency
        expect(apply_manifest(pp, :catch_failures => true).exit_code).to eq 0
      end
    end

end
