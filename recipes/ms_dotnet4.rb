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

if platform? 'windows'
  include_recipe 'ms_dotnet'

  version = node['ms_dotnet4']['version']
  nt_version = node['platform_version'].to_f
  package_info = node['ms_dotnet']['v4'][version]

  fail("The version of Microsoft .NET 4 specified is not supported: '#{version}'\n => Supported versions are: #{node['ms_dotnet']['v4'].keys}") unless package_info

  if nt_version >= package_info['min_nt_version']
    windows_package package_info['name'] do
      source          package_info['url']
      checksum        package_info['checksum']
      installer_type  :custom
      options         '/q /norestart'
      timeout         node['ms_dotnet']['timeout']
      action          :install
      not_if          nt_version > package_info['max_nt_version']
      notifies        :request, 'windows_reboot[ms_dotnet]', :immediately
    end
  else
    Chef::Log.warn('This version of Windows is not supported by .NET ' + version)
  end
else
  Chef::Log.warn 'Microsoft .NET Framework can only be installed on the Windows platform.'
end
