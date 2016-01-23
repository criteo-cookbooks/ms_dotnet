require 'spec_helper'

describe ::MSDotNet do
  let(:node) { init_node fauxhai_data }

  describe 'version_helper' do
    it 'returns a new instance of MSDotNet::VersionHelper\'s subclass' do
      SUPPORTED_MAJOR_VERSIONS.each do |major_version|
        helper1 = ::MSDotNet.version_helper node, major_version
        helper2 = ::MSDotNet.version_helper node, major_version

        expect(helper1).to_not eql helper2
        expect(helper1.is_a?(::MSDotNet::VersionHelper)).to be true
        expect(helper2.is_a?(::MSDotNet::VersionHelper)).to be true
      end
    end

    it 'fails with unsupported version' do
      expect { ::MSDotNet.version_helper node, -42 }.to raise_error(ArgumentError, /unsupported/i)
    end
  end
end
