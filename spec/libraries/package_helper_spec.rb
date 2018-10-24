require 'spec_helper'

shared_examples 'package_helper' do |data, conf|
  describe ::MSDotNet::PackageHelper do
    let(:package_helper) do
      # Set Core SKU
      data['kernel']['os_info']['operating_system_sku'] = conf[:core?] ? 0x0D : 0x00
      # Set arch
      data['kernel']['machine'] = conf[:x64?] ? 'x86_64' : 'x86'
      ::MSDotNet::PackageHelper.new init_node(data)
    end

    describe 'packages' do
      it 'returns a Mash' do
        expect(package_helper.packages).to be_a(Mash)
      end
      it 'returns always the same Mash' do
        expect(package_helper.packages).to be package_helper.packages
      end
    end

    %i[x64? core? server?].each do |function|
      describe function do
        it "returns #{conf[function]}" do
          expect(package_helper.send(function)).to be conf[function]
        end
      end
    end
  end
end

FAUXHAI_WINDOWS_VERSIONS.each do |windows_version, version_support|
  # load the data
  data = fauxhai_data 'windows', windows_version
  is_server = version_support[:server]

  version_support[:arch].each do |arch|
    is_arch64 = arch == '64'

    describe "On Windows#{windows_version}-#{arch}" do
      include_examples 'package_helper', data, x64?: is_arch64, server?: is_server, core?: false
    end

    next unless version_support[:core]

    describe "On Windows#{windows_version}-#{arch}-CORE" do
      include_examples 'package_helper', data, x64?: is_arch64, server?: is_server, core?: true
    end
  end
end
