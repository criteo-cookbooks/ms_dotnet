# frozen_string_literal: true
#
# Cookbook Name:: ms_dotnet
# Library:: v2_helper
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
  # Provides information about .NET 2 setup
  class V2Helper < VersionHelper
    REGISTRY_KEY = 'HKLM\Software\Microsoft\Net Framework Setup\NDP\v2.0.50727'.freeze unless defined? REGISTRY_KEY

    def installed_version
      return unless registry_key_exists? REGISTRY_KEY

      values = ::Mash[registry_get_values(REGISTRY_KEY).map { |e| [e[:name], e[:data]] }]
      case sp = values[:SP].to_i
        when 0 then '2.0'
        else "2.0.SP#{sp}"
      end if values[:Install].to_i == 1
    end

    def supported_versions
      @supported_versions ||= %w(2.0.SP2)
    end

    protected

    def feature_names
      @feature_names ||= if 6.0 == nt_version && server?
        %w(NET-Framework-Core)
      elsif nt_version.between?(6.0, 6.1) && core?
        x64? ? %w(NetFx2-ServerCore NetFx2-ServerCore-WOW64) : %w(NetFx2-ServerCore)
      else
        []
      end
    end

    def feature_setup
      @feature_setup ||= case nt_version
        # Windows Vista & Server 2008
        when 6.0, 6.1 then %w(2.0.SP2)
        # Other versions
        else []
      end
    end

    def patch_names
      @patch_names ||= {}
    end

    def package_setup
      @package_setup ||= case nt_version
        # Windows XP & Windows Server 2003
        when 5.1, 5.2 then %w(2.0.SP2)
        # Other versions
        else []
      end
    end

    def prerequisite_names
      @patch_names ||= {}
    end
  end
end
