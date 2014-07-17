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

  nt_version = node['platform_version'].to_f

  if nt_version >= node['ms_dotnet4']['min_nt_version']
    windows_package node['ms_dotnet4']['name'] do
      source          node['ms_dotnet4']['url']
      checksum        node['ms_dotnet4']['checksum']
      installer_type  :custom
      options         '/q /norestart'
      timeout         node['ms_dotnet']['timeout']
      action          :install
      not_if          nt_version > node['ms_dotnet4']['max_nt_version']
      notifies        :request, 'windows_reboot[ms_dotnet]', :immediately
    end
  else
    Chef::Log.warn('This version of Windows is not supported by .NET ' + node['ms_dotnet4']['version'])
  end
else
  Chef::Log.warn 'Microsoft .NET Framework can only be installed on the Windows platform.'
end
