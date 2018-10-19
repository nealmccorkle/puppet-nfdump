require 'spec_helper_acceptance'

describe 'nfdump class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-PUPPET
      class { 'nfdump': }

      nfdump::sfcapd { 'sw1':
        repeater_host => '192.168.0.1',
        repeater_port => '9995',
      }
      PUPPET

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
