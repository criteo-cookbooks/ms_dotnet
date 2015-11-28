#
# Cookbook Name:: ms_dotnet
# Recipe:: ms_dotnet2
# Author:: Julian C. Dunn (<jdunn@getchef.com>)
#
# Copyright (C) 2014 Chef Software, Inc.
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

case node['platform']
when 'windows'

  include_recipe 'ms_dotnet'
  nt_version = ::Windows::VersionHelper.nt_version(node)

  if nt_version < 6.2 && ::Windows::VersionHelper.core_version?(node)
  # Windows Server 2008 & 2008R2 Core does not come with .NET or Powershell 2.0 enabled
    windows_feature 'NetFx2-ServerCore' do
      action :install
    end
    windows_feature 'NetFx2-ServerCore-WOW64' do
      action :install
      only_if { node['kernel']['machine'] == 'x86_64' }
    end
  elsif nt_version == 6.0 && ::Windows::VersionHelper.server_version?(node)
    # Windows PowerShell 2.0 requires version 2.0 of the common language runtime (CLR).
    # CLR 2.0 is included with the Microsoft .NET Framework versions 2.0, 3.0, or 3.5 with Service Pack 1.
    windows_feature 'NET-Framework-Core' do
      action :install
    end
  elsif nt_version.between? 5.1, 5.2
    # XP, 2003 and 2003R2 don't have DISM or servermanagercmd, so download .NET 2.0 manually
    windows_package node['ms_dotnet']['v2']['name'] do # ~FC009
      source node['ms_dotnet']['v2']['url']
      checksum node['ms_dotnet']['v2']['checksum']
      installer_type :custom
      options '/quiet /norestart'
      success_codes [0, 3010]
      timeout node['ms_dotnet']['timeout']
      action :install
    end
  else
    log '.NET Framework 2.0 is already enabled on this version of Windows' do
      level :warn
    end
  end
else
  log '.NET Framework 2.0 cannot be installed on platforms other than Windows' do
    level :warn
  end
end
