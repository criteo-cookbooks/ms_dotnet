require 'spec_helper'

describe 'ms_dotnet_reboot' do
  describe 'action reboot_if_pending' do
    def run_chef(platform = 'windows', version = '2012R2', reboot_info = { action: 'reboot_if_pending' })
      ::ChefSpec::SoloRunner.new(platform: platform, version: version, log_level: :fatal, step_into: ['ms_dotnet_reboot']) do |node|
        reboot_info.each do |key, value|
          node.default['ms_dotnet_test']['reboot'][key] = value
        end
      end.converge 'ms_dotnet-test::reboot'
    end

    context 'on non Windows platform' do
      it 'fails' do
        expect { run_chef 'centos', '7.3.1611' }.to raise_error(/Cannot find a resource for ms_dotnet_reboot/)
      end
    end

    context 'on Windows' do
      it 'does nothing if no reboot is pending' do
        expect_any_instance_of(::Chef::DSL::RebootPending).to receive(:reboot_pending?).and_return false
        expect(run_chef).not_to reboot_now_reboot('Reboot for ms_dotnet_framework')
      end
      it 'triggers the reboot if reboot was pending' do
        expect_any_instance_of(::Chef::DSL::RebootPending).to receive(:reboot_pending?).and_return true
        expect(run_chef).to reboot_now_reboot('Reboot for ms_dotnet_framework')
      end
      it 'automatically computes the source when notified' do
        expect_any_instance_of(::Chef::DSL::RebootPending).to receive(:reboot_pending?).and_return false
        reboot_resource = run_chef.ms_dotnet_reboot('now')
        expect(reboot_resource.source).to be_nil
        # Trigger notification manually, because Chefspec disable them
        reboot_resource.run_action :reboot_if_pending, :immediately, 'notifying_resource1'

        expect(reboot_resource.source).to eq 'notifying_resource1'
      end
    end
  end
end
