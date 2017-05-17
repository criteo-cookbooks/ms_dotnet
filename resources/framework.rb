#
# Cookbook Name:: ms_dotnet
# Resource:: framework
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

# The provides method is available on chef >= 12.0 only
provides :ms_dotnet_framework, os: 'windows' if respond_to?(:provides)

property :feature_source,  String
property :include_patches, [true, false], default: true
property :package_sources, Hash, default: lazy { ::Mash.new }
property :perform_reboot, [true, false], default: false
property :require_support, [true, false], default: false
property :timeout, Integer, default: 600
property :version, String, name_property: true

load_current_value do |desired|
  version_helper = ::MSDotNet.version_helper node, desired.version.to_i

  version_helper.installed_version.tap do |installed_version|
    # Indicate the value does not exist when there is no installed version
    current_value_does_not_exist! if installed_version.nil?
    # Otherwise set it to current_value
    version installed_version
  end
end

action :install do
  if unsupported?
    ::Chef::Log.info "Unsupported .NET version: #{new_resource.version}"
    raise "Can't install unsupported .NET version `#{new_resource.version}'" if new_resource.require_support
  elsif superseded?
    ::Chef::Log.info ".NET `#{new_resource.version}' has been superseded by .NET `#{current_resource.version}'. Nothing to do!"
  else
    # Handle features
    install_features

    # Handle packages (prerequisites + main setup + patches)
    install_packages
  end
end

action_class.class_eval do
  def whyrun_supported?
    true
  end

  def reboot_resource
    @reboot_resource ||= ms_dotnet_reboot "Reboot for ms_dotnet[#{new_resource.name}]" do
      action :nothing
    end
  end

  def install_features
    features.each do |feature|
      windows_feature feature do
        action        :install
        all           version_helper.nt_version >= 6.2
        source        new_resource.feature_source unless new_resource.feature_source.nil?
        # Perform automatic reboot now, if required
        notifies :reboot_if_pending, reboot_resource, :immediately if new_resource.perform_reboot
      end
    end
  end

  def install_packages
    [*prerequisites, package, *patches].compact.each do |pkg|
      windows_package pkg[:name] do # ~FC009 ~FC022
        action          :install
        installer_type  :custom
        success_codes   [0, 3010] if respond_to? :success_codes
        returns         [0, 3010] if respond_to? :returns
        options         pkg[:options] || '/q /norestart'
        timeout         new_resource.timeout
        # Package specific info
        checksum        pkg[:checksum]
        source          new_resource.package_sources[pkg[:checksum]] || pkg[:url]
        # Handle not_if guards
        case pkg[:not_if]
          when String # Execute the given string guard
            not_if      pkg[:not_if]
          when Array # Ensure given array of QFE KB is not installed
            # Some packages are installed as QFE updates on 2012, 2012R2 & 10 or may have been superseded by other updates
            not_if do
              require 'wmi-lite'
              filter = pkg[:not_if].map { |kb| " HotFixID='#{kb}'" }.join(' OR')
              !filter.empty? && ::WmiLite::Wmi.new.query("SELECT HotFixID FROM Win32_QuickFixEngineering WHERE #{filter}").any?
            end
        end
        # Perform automatic reboot now, if required
        notifies :reboot_if_pending, reboot_resource, :immediately if new_resource.perform_reboot
      end
    end
  end

  def version_helper
    @version_helper ||= ::MSDotNet.version_helper node, new_resource.version.to_i
  end

  def unsupported?
    !version_helper.supported_versions.include?(new_resource.version)
  end

  # This method determines whether a more recent minor version of .NET is present
  # In this case, there is no need to do anything.
  def superseded?
    !current_resource.nil? && ::Gem::Version.new(new_resource.version) < ::Gem::Version.new(current_resource.version)
  end

  def package
    version_helper.package new_resource.version
  end

  def prerequisites
    version_helper.prerequisites new_resource.version
  end

  def features
    version_helper.features new_resource.version
  end

  def patches
    new_resource.include_patches ? version_helper.patches(new_resource.version) : []
  end
end
