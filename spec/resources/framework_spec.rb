# frozen_string_literal: true

require 'spec_helper'

describe 'ms_dotnet_framework' do
  describe 'action install' do
    def run_chef(platform = 'windows', version = '2019', framework_info = { version: '4.7.2' })
      ChefSpec::SoloRunner.new(platform: platform, version: version, log_level: :fatal, step_into: ['ms_dotnet_framework']) do |node|
        framework_info.each do |key, value|
          node.default['ms_dotnet_test']['framework_install'][key] = value
        end
      end.converge 'ms_dotnet-test::framework_install'
    end

    context 'on non Windows platform' do
      it 'fails' do
        expect { run_chef 'centos', '7.8.2003' }.to raise_error(/Cannot find a resource for ms_dotnet_framework/)
      end
    end

    context 'on Windows' do
      before do
        mock_registry '2019'
        stub_const('WmiLite::Wmi', Class.new)
        allow(::WmiLite::Wmi).to receive_message_chain(:new, :query).and_return double('WmiQuery', any?: false)
      end

      it 'tries to install a .NET framework' do
        expect(run_chef).to install_ms_dotnet_framework('install')
      end

      context 'when newer minor version is installed' do
        it 'does not update the resource' do
          chef_run = run_chef('windows', '2019', version: '4.6.2')
          expect(chef_run).to_not install_windows_feature(/.*/)
          expect(chef_run).to_not install_windows_package(/.*/)
          expect(chef_run.ms_dotnet_framework('install').updated_by_last_action?).to be false
        end

        it 'logs an information message' do
          allow(::Chef::Log).to receive(:info)
          expect(::Chef::Log).to receive(:info).with '.NET `4.6.2\' has been superseded by .NET `4.7.2\'. Nothing to do!'
          run_chef('windows', '2019', version: '4.6.2')
        end
      end

      context 'when no version or an older version is installed' do
        it 'does install packages or features' do
          chef_run = run_chef('windows', '2019', version: '4.8')
          # ChefSpec matchers doesn't allow `.or`
          expect(chef_run).to install_windows_package('Microsoft .NET Framework 4.8')
        end
        it 'does not reboot if not asked' do
          chef_run = run_chef('windows', '2019', version: '4.8', perform_reboot: false)
          expect(chef_run).not_to reboot_if_pending_ms_dotnet_reboot('Reboot for ms_dotnet[install]')
          expect(chef_run.windows_package('Microsoft .NET Framework 4.8')).not_to notify('ms_dotnet_reboot[Reboot for ms_dotnet[install]]')
        end
        it 'reboots if asked' do
          chef_run = run_chef('windows', '2019', version: '4.8', perform_reboot: true)
          expect(chef_run.windows_package('Microsoft .NET Framework 4.8')).to notify('ms_dotnet_reboot[Reboot for ms_dotnet[install]]')
        end
      end

      context 'when expected version is already installed' do
        it 'does nothing' do
          chef_run = run_chef('windows', '2019', version: '4.7.2')
          expect(chef_run.ms_dotnet_framework('install').updated_by_last_action?).to be false
        end
      end

      context 'when expected major version is not supported' do
        it 'raises an ArgumentError' do
          expect { run_chef('windows', '2019', version: '42') }.to raise_error(ArgumentError, /Unsupported version '42'/)
        end
      end

      context 'when expected minor version is not supported' do
        it 'logs an information message and does nothing else' do
          allow(::Chef::Log).to receive(:info)
          expect(::Chef::Log).to receive(:info).with 'Unsupported .NET version: 4.42'
          expect(run_chef('windows', '2019', version: '4.42', require_support: false).ms_dotnet_framework('install').updated_by_last_action?).to be false
        end

        it 'fails if support required' do
          expect { run_chef('windows', '2019', version: '4.42', require_support: true) }.to raise_error(/Can't install unsupported .NET version `4.42'/)
        end
      end
    end
  end
end
