require 'spec_helper'

describe 'ms_dotnet::ms_dotnet2' do
  describe 'On windows platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2').converge(described_recipe)
    end

    it 'installs .NET framework v2' do
      expect(chef_run).to install_ms_dotnet_framework('2.0.SP2').with(DEFAULT_FRAMEWORK_ATTRIBUTES)
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
