require 'spec_helper'

describe 'nfdump::install' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'nfdump::install class without any parameters' do
          let(:pre_condition) do
            'class { "::nfdump": }'
          end
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('nfdump::install') }

          it { is_expected.to contain_user('sflow') }
          it { is_expected.to contain_file('/home/sflow') }
          it { is_expected.to contain_file('/home/sflow').with_ensure('directory') }
          it { is_expected.to contain_file('/home/sflow/.ssh') }
          it { is_expected.to contain_file('/home/sflow/.ssh').with_ensure('directory') }

          it { is_expected.to contain_exec('create-data-folder') }
          it { is_expected.to contain_exec('create-data-folder').with_command('mkdir -p /data/nfdump') }
          it { is_expected.to contain_exec('create-data-folder').with_creates('/data/nfdump') }

          it { is_expected.to contain_file('/data/nfdump') }
          it { is_expected.to contain_file('/data/nfdump').with_owner('sflow') }
          it { is_expected.to contain_file('/data/nfdump').with_group('sflow') }
          it { is_expected.to contain_file('/data/nfdump').that_requires('Exec[create-data-folder]') }
          it { is_expected.to contain_file('/data/nfdump').that_requires('User[sflow]') }

          it { is_expected.to contain_file('/data/nfdump/sources') }
          it { is_expected.to contain_file('/data/nfdump/sources').with_owner('sflow') }
          it { is_expected.to contain_file('/data/nfdump/sources').with_group('sflow') }
          it { is_expected.to contain_file('/data/nfdump/sources').that_requires('Exec[create-data-folder]') }
          it { is_expected.to contain_file('/data/nfdump/sources').that_requires('User[sflow]') }

          case facts[:osfamily]
          when 'RedHat'
            it { is_expected.to contain_package('nfdump').with_ensure('present') }
            it { is_expected.to contain_class('epel') }
          when 'Debian'
            it { is_expected.to contain_package('nfdump-sflow').with_ensure('present') }
          end
        end
      end
    end
  end
end
