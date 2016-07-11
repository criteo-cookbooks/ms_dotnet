#
# Cookbook Name:: ms_dotnet
# Provider:: framework
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
use_inline_resources
# The provides method is available on chef >= 12.0 only
provides :ms_dotnet_framework, os: 'windows' if respond_to?(:provides)

def whyrun_supported?
  true
end

def load_current_resource
  installed_version = version_helper.installed_version
  return unless installed_version

  @current_resource = ::Chef::Resource::MsDotnetFramework.new new_resource.name, run_context
  @current_resource.version installed_version
end

action :install do
  if unsupported?
    ::Chef::Log.info "Unsupported .NET version: #{version}"
    raise "Can't install unsupported .NET version `#{version}'" if new_resource.require_support
  elsif install_required?
    # Handle features
    features.each do |feature|
      windows_feature feature do
        action        :install
        all           version_helper.nt_version >= 6.2
        source        new_resource.feature_source unless new_resource.feature_source.nil?
      end
    end

    # Handle packages (prerequisites + main setup + patches)
    (prerequisites + [package] + patches).each do |pkg|
      next if pkg.nil?
      windows_package pkg[:name] do # ~FC009 ~FC022
        action          :install
        installer_type  :custom
        success_codes   [0, 3010]
        options         pkg[:options] || '/q /norestart'
        timeout         new_resource.timeout
        # Package specific info
        checksum        pkg[:checksum]
        source          new_resource.package_sources[pkg[:checksum]] || pkg[:url]
        not_if          pkg[:not_if] unless pkg[:not_if].nil?
      end
    end
  else
    ::Chef::Log.info ".NET `#{version}' is not needed because .NET `#{@current_resource.version}' is already installed"
  end
end

def version
  @version ||= new_resource.version
end

def major_version
  @major_version ||= version.to_i
end

def version_helper
  @version_helper ||= ::MSDotNet.version_helper node, major_version
end

def unsupported?
  !version_helper.supported_versions.include?(version)
end

def install_required?
  # If current version == desired version; we need to pass by install steps to ensure everything is OK
  @current_resource.nil? || ::Gem::Version.new(version) >= ::Gem::Version.new(@current_resource.version)
end

def package
  version_helper.package version
end

def prerequisites
  version_helper.prerequisites version
end

def features
  version_helper.features version
end

def patches
  new_resource.include_patches ? version_helper.patches(version) : []
end
