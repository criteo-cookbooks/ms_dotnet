require 'spec_helper'

describe 'ms_dotnet::regiis' do
  describe 'On windows platform' do
    let(:windows_chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2').converge(described_recipe)
    end

    before do
      stub_command('sc.exe query W3SVC').and_return 1
    end

    it 'registers ASP.NET to IIS' do
      expect(windows_chef_run).to run_execute('aspnet_regiis')
    end
  end
  describe 'On non-windows platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.3.1611').converge(described_recipe)
    end

    it 'does nothing' do
      expect(chef_run.resource_collection).to be_empty
    end
  end
end
