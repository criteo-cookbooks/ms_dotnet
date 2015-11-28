#
# Author:: Timothy Smith (<tim.smith@webtrends.com>)
# Cookbook Name:: ms_dotnet4
# Attribute:: default
#
# Copyright:: Copyright (c) 2012 Webtrends Inc
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
  nt_version = ::Windows::VersionHelper.nt_version(node)
  default['ms_dotnet']['v4']['version']                                   = '4.0'
  if nt_version >= 5.1 && nt_version <= 6.1
    default['ms_dotnet']['versions']['4.0']['package']['name']            = 'Microsoft .NET Framework 4 Extended'
    default['ms_dotnet']['versions']['4.0']['package']['url']             = 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe'
    default['ms_dotnet']['versions']['4.0']['package']['checksum']        = '65e064258f2e418816b304f646ff9e87af101e4c9552ab064bb74d281c38659f'

    # There is a patch for .NET4
    default['ms_dotnet']['versions']['4.0']['patch']['name']              = 'Update for Microsoft .NET Framework 4 Extended (KB2468871)'
    if node['kernel']['machine'] == 'x86_64'
      default['ms_dotnet']['versions']['4.0']['patch']['url']             = 'http://download.microsoft.com/download/2/B/F/2BF4D7D1-E781-4EE0-9E4F-FDD44A2F8934/NDP40-KB2468871-v2-x64.exe'
      default['ms_dotnet']['versions']['4.0']['patch']['checksum']        = 'b1b53c3953377b111fe394dd57592d342cfc8a3261a5575253b211c1c2e48ff8'
    else
      default['ms_dotnet']['versions']['4.0']['patch']['url']             = 'http://download.microsoft.com/download/2/B/F/2BF4D7D1-E781-4EE0-9E4F-FDD44A2F8934/NDP40-KB2468871-v2-x86.exe'
      default['ms_dotnet']['versions']['4.0']['patch']['checksum']        = '8822672fc864544e0766c80b635973bd9459d719b1af75f51483ff36cfb26f03'
    end
  end

  if nt_version >= 6.0
    if nt_version < 6.2
      default['ms_dotnet']['versions']['4.5']['package']['name']          = 'Microsoft .NET Framework 4.5'
      default['ms_dotnet']['versions']['4.5']['package']['url']           = 'http://download.microsoft.com/download/B/A/4/BA4A7E71-2906-4B2D-A0E1-80CF16844F5F/dotNetFx45_Full_x86_x64.exe'
      default['ms_dotnet']['versions']['4.5']['package']['checksum']      = 'a04d40e217b97326d46117d961ec4eda455e087b90637cb33dd6cc4a2c228d83'
    end

    if nt_version < 6.3
      default['ms_dotnet']['versions']['4.5.1']['package']['name']        = 'Microsoft .NET Framework 4.5.1'
      default['ms_dotnet']['versions']['4.5.1']['package']['url']         = 'http://download.microsoft.com/download/1/6/7/167F0D79-9317-48AE-AEDB-17120579F8E2/NDP451-KB2858728-x86-x64-AllOS-ENU.exe'
      default['ms_dotnet']['versions']['4.5.1']['package']['checksum']    = '5ded8628ce233a5afa8e0efc19ad34690f05e9bb492f2ed0413508546af890fe'
    end

    default['ms_dotnet']['versions']['4.5.2']['package']['name']          = 'Microsoft .NET Framework 4.5.2'
    default['ms_dotnet']['versions']['4.5.2']['package']['url']           = 'http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe'
    default['ms_dotnet']['versions']['4.5.2']['package']['checksum']      = '6c2c589132e830a185c5f40f82042bee3022e721a216680bd9b3995ba86f3781'

    # Starting with windows 8 and Server 2012 old version of .NET Framework 4 are builtin or included as feature
    if nt_version >= 6.2
      if ::Windows::VersionHelper.workstation_version?(node)
        feature_name = :builtin # .NET 4 can't be disabled on windows 8 and windows 8.1
      else
        feature_name = ::Windows::VersionHelper.core_version?(node) && nt_version != 6.3 ? 'netFx4-Server-Core' : 'netFx4'
      end

      default['ms_dotnet']['versions']['4.0']['feature']                  = feature_name
      default['ms_dotnet']['versions']['4.5']['feature']                  = feature_name
      default['ms_dotnet']['versions']['4.5.1']['feature']                = feature_name if nt_version == 6.3

      # .NET 4.5.2 is installed as an update on 2012 & 2012R2
      hotfix_id = nt_version == 6.3 ? 'KB2934520' : 'KB2901982'
      default['ms_dotnet']['versions']['4.5.2']['package']['not_if']      = "wmic path Win32_QuickFixEngineering WHERE HotFixID='#{hotfix_id}' | FindStr #{hotfix_id}"
    end
  end
end
