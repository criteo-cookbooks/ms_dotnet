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
property :package_sources, Hash, default: {}.freeze
property :perform_reboot, [true, false], default: false
property :require_support, [true, false], default: false
property :timeout, Integer, default: 600
property :version, String, name_property: true

load_current_value do |desired|
  version_helper = ::MSDotNet.version_helper node, desired.version.to_i
  version version_helper.installed_version unless version_helper.installed_version.nil?
end

action :install do
  if unsupported?
    ::Chef::Log.info "Unsupported .NET version: #{new_resource.version}"
    raise "Can't install unsupported .NET version `#{new_resource.version}'" if new_resource.require_support
  elsif install_required?
    # Handle features
    install_features

    # Handle packages (prerequisites + main setup + patches)
    install_packages
  else
    ::Chef::Log.info ".NET `#{new_resource.version}' is not needed because .NET `#{current_resource.version}' is already installed"
  end
end

action_class do
  def whyrun_supported?
    true
  end

  def install_features
    features.each do |feature|
      windows_feature feature do
        action        :install
        all           version_helper.nt_version >= 6.2
        source        new_resource.feature_source unless new_resource.feature_source.nil?
      end

      # Perform automatic reboot now, if required
      reboot "Reboot for ms_dotnet feature '#{feature}'" do
        action   :reboot_now
        reason   new_resource.name
        only_if  { should_reboot? }
      end
    end
  end

  def install_packages
    (prerequisites + [package] + patches).each do |pkg|
      next if pkg.nil?
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
        not_if          pkg[:not_if] unless pkg[:not_if].nil?
      end

      # Perform automatic reboot now, if required
      reboot "Reboot for ms_dotnet package '#{pkg[:name]}'" do
        action   :reboot_now
        reason   new_resource.name
        only_if  { should_reboot? }
      end
    end
  end

  def should_reboot?
    new_resource.perform_reboot && reboot_pending?
  end

  def version
    @version ||= new_resource.version
  end

  def major_version
    @major_version ||= new_resource.version.to_i
  end

  def version_helper
    @version_helper ||= ::MSDotNet.version_helper node, major_version
  end

  def unsupported?
    !version_helper.supported_versions.include?(new_resource.version)
  end

  def install_required?
    # If current version == desired version; we need to pass by install steps to ensure everything is OK
    current_resource.nil? || ::Gem::Version.new(new_resource.version) > ::Gem::Version.new(current_resource.version)
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
