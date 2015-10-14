#
# Cookbook Name:: ms_dotnet
# Recipe:: ms_dotnet4
# Author:: Tim Smith (<tsmith@llnw.com>)
#
# Copyright 2012, Webtrends, Inc.
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
if platform? 'windows'
  include_recipe 'ms_dotnet'

  version = node['ms_dotnet']['v4']['version']
  version_info = node['ms_dotnet']['versions'][version]
  fail("The version of Microsoft .NET specified is not supported: '#{version}'\n => Supported versions are: #{node['ms_dotnet']['versions'].keys}") unless version_info

  feature_name = version_info['feature']
  if feature_name == :builtin
    Chef::Log.info "Microsoft .NET Framework #{version} is builtin on your version of Windows."
  elsif feature_name
    windows_feature feature_name do
      action :install
    end
  else
    package_info = version_info['package']
    windows_package package_info['name'] do # ~FC009
      source          package_info['url']
      checksum        package_info['checksum']
      installer_type  :custom
      options         '/q /norestart'
      success_codes   [0, 3010]
      timeout         node['ms_dotnet']['timeout']
      action          :install
      not_if          package_info['not_if'] if package_info['not_if']
    end
  end

  # Install patch if available
  if version_info['patch']
    patch_info = version_info['patch']
    windows_package patch_info['name'] do # ~FC009
      source          patch_info['url']
      checksum        patch_info['checksum']
      installer_type  :custom
      options         '/q /norestart'
      success_codes   [0, 3010]
      timeout         node['ms_dotnet']['timeout']
      action          :install
    end
  end
else
  Chef::Log.info 'Microsoft .NET Framework can only be installed on the Windows platform.'
end
