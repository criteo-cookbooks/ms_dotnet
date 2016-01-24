# frozen_string_literal: true
#
# Cookbook Name:: ms_dotnet
# Library:: v1_helper
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
  # Provides information about .NET 1 setup
  class V1Helper < VersionHelper
    REGISTRY_KEY = 'HKLM\\Software\\Microsoft\\Net Framework Setup\\NDP\\v1.1.4322'.freeze unless defined? REGISTRY_KEY

    def installed_version
      # TODO: FORCE 32bit!
      return unless registry_key_exists? REGISTRY_KEY

      values = ::Mash[registry_get_values(REGISTRY_KEY).map { |e| [e[:name], e[:data]] }]
      case values[:SP].to_i
        when 0 then version
        when 1 then "#{version}.SP1"
      end if values[:Install].to_i == 1
    end

    def supported_versions
      @supported_versions ||= ['1.1']
    end

    protected

    def feature_names
      @feature_names ||= []
    end

    def feature_setup
      @feature_setup ||= []
    end

    def patch_names
      @patch_names ||= case nt_version
        # Windows XP & Windows Server 2003, Vista & Windows Server 2008
        when 5.1, 5.2, 6.0
          { '1.1' => 'KB867460' }
        else
          {}
      end
    end

    def package_setup
      @package_setup ||= case nt_version
        # Windows XP & Windows Server 2003, Vista & Windows Server 2008
        when 5.1, 5.2, 6.0 then ['1.1']
        # Other versions
        else []
      end
    end
  end
end
