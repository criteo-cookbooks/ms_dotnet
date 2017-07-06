require 'spec_helper'

describe 'ms_dotnet::default' do
  describe 'On windows platform' do
    let(:windows_chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2').converge(described_recipe)
    end

    it 'does nothing' do
      expect(windows_chef_run.resource_collection).to be_empty
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
