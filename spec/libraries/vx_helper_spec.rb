require 'spec_helper'

UNSUPPORTED_VERSIONS = %w[0.42.unsupported].freeze
FAUXHAI_WINDOWS_VERSIONS.keys.each do |windows_version|
  describe "On Windows#{windows_version}" do
    let(:node) { init_node fauxhai_data('windows', windows_version) }

    SUPPORTED_MAJOR_VERSIONS.each do |major_version|
      describe ::MSDotNet.const_get("V#{major_version}Helper") do
        # Small lambda to check if a hash looks like a package
        let(:package_like) { ->(hash) { %w[name url checksum].all? { |k| hash.key? k } } }
        let(:version_helper) { ::MSDotNet.version_helper node, major_version }

        describe 'installed_version' do
          it 'checks the registry to detect the latest version installed' do
            expect(version_helper).to receive(:registry_key_exists?).at_least :once
            expect { version_helper.installed_version }.to_not raise_error
          end
        end

        describe 'features' do
          it 'returns a - possibly empty - array of feature names' do
            (version_helper.supported_versions + UNSUPPORTED_VERSIONS).each do |version|
              expect(version_helper.features(version)).to be_an(Array).and all be_a(String)
            end
          end
        end

        describe 'package' do
          it 'returns a hash with package info or nil' do
            (version_helper.supported_versions + UNSUPPORTED_VERSIONS).each do |version|
              expect(version_helper.package(version)).to be_nil.or satisfy(&package_like)
            end
          end
        end

        describe 'patches' do
          it 'returns a - possibly empty - array of patch packages' do
            (version_helper.supported_versions + UNSUPPORTED_VERSIONS).each do |version|
              expect(version_helper.patches(version)).to be_an(Array).and all satisfy(&package_like)
            end
          end
        end

        describe 'supported_versions' do
          it 'returns a non-empty String array parsable by Gem::Version' do
            result = version_helper.supported_versions
            expect(result).to be_an Array
            expect(result).to_not be_empty
            expect(result).to all(be_a(String).and(satisfy { |version| ::Gem::Version.new version }))
          end
        end
      end
    end
  end
end
