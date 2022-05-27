# frozen_string_literal: true

#
# Cookbook:: ms_dotnet
# Library:: v4_helper
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
#
# Copyright:: (C) 2015-2016, Criteo.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require_relative 'version_helper'

module MSDotNet
  # Provides information about .NET 4 setup
  class V4Helper < VersionHelper
    REGISTRY_KEY = 'HKLM\Software\Microsoft\Net Framework Setup\NDP\v4\Full' unless defined? REGISTRY_KEY

    def installed_version
      return unless registry_key_exists? REGISTRY_KEY

      values = ::Mash[registry_get_values(REGISTRY_KEY).map { |e| [e[:name], e[:data]] }]

      return if values[:Install].to_i != 1

      release = values[:Release].to_i
      if release >= 528_040
        '4.8'
      elsif release >= 461_808
        '4.7.2'
      elsif release >= 461_308
        '4.7.1'
      elsif release >= 460_798
        '4.7'
      elsif release >= 394_802
        '4.6.2'
      end
    end

    def supported_versions
      @supported_versions ||= %w(4.6.2 4.7 4.7.1 4.7.2 4.8)
    end

    protected

    def feature_names
      @feature_names ||= case nt_version
        when 6.2, 6.3, 10
          # TODO: check 2012R2 Core feature name
          core? ? %w(netFx4-Server-Core) : %w(NetFx4)
        else
          []
      end
    end

    def feature_setup
      @feature_setup ||= [].tap do |result|
        version = ::Gem::Version.new(full_version)
        # Windows 10 & Server 2016 v1607 (RS1) & newer
        result << '4.6.2' if version >= ::Gem::Version.new('10.0.14393')
        # Windows 10 v1703 (RS2) & newer
        result << '4.7' if version >= ::Gem::Version.new('10.0.15063')
        # Windows 10 & Server 2016 v1709 (RS3) & newer
        result << '4.7.1' if version >= ::Gem::Version.new('10.0.16299')
        # Windows 10 & Server 2016 v1803 (RS4) & newer
        result << '4.7.2' if version >= ::Gem::Version.new('10.0.17134')
        # Windows 10 v1903 (19H1) & newer
        result << '4.8' if version >= ::Gem::Version.new('10.0.18362')
      end
    end

    def patch_names
      @patch_names ||= case full_version
        when /^6\.2/ # TODO: remove after 2023-10-10
          { '4.7.1' => %w(KB4054853) }
        when /^6\.3/ # TODO: remove after 2023-10-10
          { '4.7.1' => %w(KB4054854) }
        when '10.0.10240', '10.0.10586', '10.0.14393', '10.0.15063'
          { '4.7.1' => %w(KB4054855) }
        when '10.0.16299'
          { '4.7.2' => %w(KB4073120) }
        else
          {}
      end
    end

    def package_setup
      @package_setup ||= [].tap do |result|
        version = ::Gem::Version.new(full_version)
        # Up to Windows 10 v1903, Server 2022
        result << '4.8' if version < ::Gem::Version.new('10.0.18362')
        # Up to Windows 10 v1803, Server 2019
        result << '4.7.2' if version < ::Gem::Version.new('10.0.17763')
        # Up to Windows 10 & Server 2016 v1709 (RS3)
        result << '4.7.1' if version < ::Gem::Version.new('10.0.16299')
        # Up to Windows 10 v1703 (RS2)
        result << '4.7' if version < ::Gem::Version.new('10.0.15063')
        # Up to Windows 10 & Server 2016 v1607 (RS1)
        result << '4.6.2' if version < ::Gem::Version.new('10.0.14393')
      end
    end

    def prerequisite_names
      @prerequisite_names ||= case nt_version
        when 6.2 # TODO: remove after 2023-10-10
          { '4.7' => ['KB4019990-6.2'] }
        when 6.3 # TODO: remove after 2023-10-10
          prerequisites46 = %w(KB2919442 KB2919355 KB3173424)
          {
            '4.6.2' => prerequisites46,
          }
        else
          {}
      end
    end
  end
end
