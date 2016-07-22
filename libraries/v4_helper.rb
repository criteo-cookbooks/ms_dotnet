# frozen_string_literal: true
#
# Cookbook Name:: ms_dotnet
# Library:: v4_helper
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
  # Provides information about .NET 4 setup
  class V4Helper < VersionHelper
    REGISTRY_KEY = 'HKLM\Software\Microsoft\Net Framework Setup\NDP\v4\Full'.freeze unless defined? REGISTRY_KEY

    def installed_version
      return unless registry_key_exists? REGISTRY_KEY

      values = ::Mash[registry_get_values(REGISTRY_KEY).map { |e| [e[:name], e[:data]] }]

      case values[:Release].to_i
        when 0 then '4.0'
        when 378_389 then '4.5'
        when 378_675, 378_758 then '4.5.1'
        when 379_893 then '4.5.2'
        when 393_295, 393_297 then '4.6'
        when 394_254, 394_271 then '4.6.1'
      end if values[:Install].to_i == 1
    end

    def supported_versions
      @supported_versions ||= %w(4.0 4.5 4.5.1 4.5.2 4.6 4.6.1)
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
      @feature_setup ||= case nt_version
        # Windows 8 & Server 2012
        when 6.2 then %(4.0 4.5)
        # Windows 8.1 & Server 2012R2
        when 6.3 then %(4.0 4.5 4.5.1)
        # Windows 10
        when 10 then %(4.0 4.5 4.5.1 4.5.2)
        # Other versions
        else []
      end
    end

    def patch_names
      @patch_names ||= case nt_version
        when 5.1, 5.2
          { '4.0' => %w(KB2468871) }
        when 6.0, 6.1, 6.2, 6.3, 10
          { '4.6' => %w(KB3083186) }
        else
          {}
      end
    end

    def package_setup
      @package_setup ||= case nt_version
        # Windows XP & Windows Server 2003
        when 5.1, 5.2 then %w(4.0)
        # Windows Vista & Server 2008
        when 6.0 then %w(4.0 4.5 4.5.1 4.5.2 4.6)
        # Windows 7 & Server 2008R2
        when 6.1 then %w(4.0 4.5 4.5.1 4.5.2 4.6 4.6.1)
        # Windows 8 & Server 2012
        when 6.2 then %w(4.5.1 4.5.2 4.6 4.6.1)
        # Windows 8.1 & Server 2012R2
        when 6.3 then %w(4.5.2 4.6 4.6.1)
        # Windows 10
        when 10 then %w(4.6.1)
        # Other versions
        else []
      end
    end

    def prerequisite_names
      @patch_names ||= case nt_version
        when 6.3
          prerequisites_46 = %w(KB2919442 KB2919355)
          { '4.6' => prerequisites_46, '4.6.1' => prerequisites_46 }
        else
          {}
      end
    end
  end
end
