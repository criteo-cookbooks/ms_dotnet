require 'spec_helper'

describe ::MSDotNet::VersionHelper do
  class TestVersionHelper < ::MSDotNet::VersionHelper; end
  let(:node) { init_node fauxhai_data }
  subject(:test_helper) { TestVersionHelper.new node }

  describe 'initialize' do
    it 'fails when called not inherited' do
      expect { ::MSDotNet::VersionHelper.new node }.to raise_error(TypeError, /abstract/i)
    end
  end

  %w[
    installed_version
    supported_versions
    feature_names
    feature_setup
    patch_names
    package_setup
  ].each do |abstract_method|
    describe abstract_method do
      it 'fails with NotImplementedError' do
        expect { test_helper.send abstract_method.to_sym }.to raise_error NotImplementedError
      end
    end
  end
end
