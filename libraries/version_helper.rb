#
# Cookbook Name:: ms_dotnet
# Library:: version_helper
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
require_relative 'package_helper'

module MSDotNet
  # Base "abstract" class for .NET version helper
  # Provides method to easily determine how to setup a .NET version
  class VersionHelper < PackageHelper
    # Used to detect installed version
    include ::Chef::DSL::RegistryHelper

    attr_reader :run_context

    def initialize(node)
      raise TypeError, 'MSDotNet::VersionHelper is an "abstract" class and must not be instanciated directly.' if self.class == ::MSDotNet::VersionHelper
      super

      # run_context is required by ::Chef::DSL::RegistryHelper
      @run_context = node.run_context
    end

    # Get windows features required by the given .NET version
    def features(version)
      feature_setup.include?(version) ? feature_names : []
    end

    # Get installed .NET version on the current node
    # Returns a String or nil
    def installed_version
      raise NotImplementedError
    end

    # Get windows package required by the given .NET version
    def package(version)
      packages[version] if package_setup.include? version
    end

    # Get windows patches required by the given .NET version
    def patches(version)
      (patch_names[version] || []).map { |patch| packages[patch] }
    end

    # Get windows packages required prior to install the given .NET version
    def prerequisites(version)
      (prerequisite_names[version] || []).map { |package| packages[package] }
    end

    # Get all .NET versions supported on the current node OS
    # Returns an Array<string>
    def supported_versions
      raise NotImplementedError
    end

    protected

    # Get windows feature's names for the major .NET version on the current node OS
    # Returns an Array<string>
    def feature_names
      raise NotImplementedError
    end

    # Get all .NET versions requiring windows feature activation on the current node OS
    # Returns an Array<string>
    def feature_setup
      raise NotImplementedError
    end

    # Get patch package's names for each minor .NET versions on the current node OS
    # Returns a Hash<string,Array<string>> with .NET version as key, and package names as value
    def patch_names
      raise NotImplementedError
    end

    # Get all .NET versions requiring windows package install on the current node OS
    # Returns an Array<string>
    def package_setup
      raise NotImplementedError
    end

    # Get prerequisite package's names for each minor .NET versions on the current node OS
    # Returns a Hash<string,Array<string>> with .NET version as key, and package names as value
    def prerequisites_names
      raise NotImplementedError
    end
  end
end
