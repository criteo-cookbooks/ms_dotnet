#
# Cookbook Name:: ms_dotnet
# Library:: v3_helper
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
#
# Copyright (C) 2015-2016, Criteo.
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
  # Provides information about .NET 3 setup
  class V3Helper < VersionHelper
    def installed_version
      # Order is important because we want the maximum version
      %w(3.5 3.0).map do |version|
        registry_key = "HKLM\\Software\\Microsoft\\Net Framework Setup\\NDP\\v#{version}"
        next unless registry_key_exists? registry_key

        values = ::Mash[registry_get_values(registry_key).map { |e| [e[:name], e[:data]] }]
        next if values[:Install].to_i != 1

        values[:SP].to_i == '0' ? version : "#{version}.SP#{values[:SP]}"
      end.compact.first
    end

    def supported_versions
      @supported_versions ||= %w(3.0 3.5 3.5.SP1)
    end

    protected

    def feature_names
      @feature_names ||= nt_version >= 6.0 ? %w(NetFx3) : []
    end

    def feature_setup
      @feature_setup ||= case nt_version
        # Vista & Server 2008
        when 6.0 then %w(3.0)
        # 7, 8, 8.1, 10 & Server 2008R2, 2012, 2012R2
        when 6.1, 6.2, 6.3, 10 then %(3.0 3.5 3.5.SP1)
        # Other versions
        else []
      end
    end

    def patch_names
      @patch_names ||= {}
    end

    def package_setup
      @package_setup ||= case nt_version
        # Windows XP & Server 2003
        when 5.2, 5.3 then %w(3.0 3.5 3.5.SP1)
        # Vista & Server 2008
        when 6.0 then %w(3.5 3.5.SP1)
        # Other versions
        else []
      end
    end

    def prerequisite_names
      @patch_names ||= {}
    end
  end
end
