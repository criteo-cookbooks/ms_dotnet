#
# Cookbook Name:: ms_dotnet
# Library:: package_helper
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
require_relative 'windows_version_helper.rb'

module MSDotNet
  # References the main official .NET setup and patch packages
  class PackageHelper
    attr_reader :arch, :nt_version, :is_core, :is_server, :machine_type

    def initialize(node)
      @arch = node['kernel']['machine'] == 'x86_64' ? 'x64' : 'x86'
      @nt_version = ::Windows::VersionHelper.nt_version(node)
      @is_core = ::Windows::VersionHelper.core_version?(node)
      @is_server = ::Windows::VersionHelper.server_version?(node)

      @machine_type = if core?
        :core
      elsif server?
        :server
      else
        :workstation
      end
    end

    def packages
      @packages ||= ::Mash.new(
        '2.0.SP2' => {
          name:     'Microsoft .NET Framework 2.0 Service Pack 2',
          url:      "https://download.microsoft.com/download/C/6/E/C6E88215-0178-4C6C-B5F3-158FF77B1F38/NetFx20SP2_#{arch}.exe",
          checksum: x64? ? '430315c97c57ac158e7311bbdbb7130de3e88dcf5c450a25117c74403e558fbe' : '6e3f363366e7d0219b7cb269625a75d410a5c80d763cc3d73cf20841084e851f',
        },
        '3.5' => {
          name:     'Microsoft .NET Framework 3.5',
          url:      'https://download.microsoft.com/download/6/0/F/60FC5854-3CB8-4892-B6DB-BD4F42510F28/dotnetfx35.exe',
          checksum: '3e3a4104bad9a0c270ed5cbe8abb986de9afaf0281a98998bdbdc8eaab85c3b6',
        },
        '3.5.SP1' => {
          name:     'Microsoft .NET Framework 3.5 Service Pack 1',
          url:      'https://download.microsoft.com/download/2/0/E/20E90413-712F-438C-988E-FDAA79A8AC3D/dotnetfx35.exe',
          checksum: '0582515bde321e072f8673e829e175ed2e7a53e803127c50253af76528e66bc1',
        },
        '4.0' => {
          name:     'Microsoft .NET Framework 4 Extended',
          url:      'https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
          checksum: '65e064258f2e418816b304f646ff9e87af101e4c9552ab064bb74d281c38659f',
        },
        '4.5' => {
          name:     'Microsoft .NET Framework 4.5',
          url:      'https://download.microsoft.com/download/B/A/4/BA4A7E71-2906-4B2D-A0E1-80CF16844F5F/dotNetFx45_Full_x86_x64.exe',
          checksum: 'a04d40e217b97326d46117d961ec4eda455e087b90637cb33dd6cc4a2c228d83',
        },
        '4.5.1' => {
          name:     'Microsoft .NET Framework 4.5.1',
          url:      'https://download.microsoft.com/download/1/6/7/167F0D79-9317-48AE-AEDB-17120579F8E2/NDP451-KB2858728-x86-x64-AllOS-ENU.exe',
          checksum: '5ded8628ce233a5afa8e0efc19ad34690f05e9bb492f2ed0413508546af890fe',
        },
        '4.5.2' => {
          name:     'Microsoft .NET Framework 4.5.2',
          url:      'https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe',
          checksum: '6c2c589132e830a185c5f40f82042bee3022e721a216680bd9b3995ba86f3781',
        },
        '4.6' => {
          name:     'Microsoft .NET Framework 4.6',
          url:      'https://download.microsoft.com/download/C/3/A/C3A5200B-D33C-47E9-9D70-2F7C65DAAD94/NDP46-KB3045557-x86-x64-AllOS-ENU.exe',
          checksum: 'b21d33135e67e3486b154b11f7961d8e1cfd7a603267fb60febb4a6feab5cf87',
        },
        '4.6.1' => {
          name:     'Microsoft .NET Framework 4.6.1',
          url:      'https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe',
          checksum: 'beaa901e07347d056efe04e8961d5546c7518fab9246892178505a7ba631c301',
        },
        ###########
        # Patches
        ###########
        # TODO: handle theses patches
        # http://www.microsoft.com/en-us/download/details.aspx?id=10006
        # http://www.microsoft.com/en-us/download/details.aspx?id=1055
        # http://www.microsoft.com/en-us/download/details.aspx?id=16211
        # http://www.microsoft.com/en-us/download/details.aspx?id=16921
        'KB2468871' => {
          name:     'Update for Microsoft .NET Framework 4 Extended (KB2468871)',
          url:      "https://download.microsoft.com/download/2/B/F/2BF4D7D1-E781-4EE0-9E4F-FDD44A2F8934/NDP40-KB2468871-v2-#{arch}.exe",
          checksum: x64? ? 'b1b53c3953377b111fe394dd57592d342cfc8a3261a5575253b211c1c2e48ff8' : '8822672fc864544e0766c80b635973bd9459d719b1af75f51483ff36cfb26f03',
        },
        'KB3083186' => {
          name:     'Update for Microsoft .NET Framework 4.6 (KB3083186)',
          url:      "https://download.microsoft.com/download/3/E/C/3EC59EE9-5699-4159-9691-E04E38D677CC/NDP46-KB3083186-#{arch}.exe",
          checksum: x64? ? 'bf850afc7e7987d513fd2c19c9398d014bcbaaeb1691357fa0400529975edace' : '41e675937d023828d648c7a245e19695ed12f890c349d8b6f2b620e6e58e038e',
          not_if:   'reg query "HKLM\SOFTWARE\Microsoft\Updates\Microsoft .NET Framework 4.6\KB3083186" | FindStr /Ec:"ThisVersionInstalled +REG_SZ +Y"',
        },
        'KB2919442' => {
          name:     'Update for Microsoft Windows (KB2919442)',
          url:      if x64?
                      'https://download.microsoft.com/download/D/6/0/D60ED3E0-93A5-4505-8F6A-8D0A5DA16C8A/Windows8.1-KB2919442-x64.msu'
                    else
                      'https://download.microsoft.com/download/9/D/A/9DA6C939-9E65-4681-BBBE-A8F73A5C116F/Windows8.1-KB2919442-x86.msu'
                    end,
          options:  '/norestart /quiet',
          checksum: x64? ? 'c10787e669b484674584a990e069295e8b81b5366f98508010a3ae181b729482' : '3368c3a329f402fd982b15b399368627b96973f008a5456b5286bdfc10c1169b',
        },
        'KB2919355' => {
          name:     'Update for Microsoft Windows (KB2919355)',
          url:      if x64?
                      'https://download.microsoft.com/download/2/5/6/256CCCFB-5341-4A8D-A277-8A81B21A1E35/Windows8.1-KB2919355-x64.msu'
                    else
                      'https://download.microsoft.com/download/4/E/C/4EC66C83-1E15-43FD-B591-63FB7A1A5C04/Windows8.1-KB2919355-x86.msu'
                    end,
          options:  '/norestart /quiet',
          checksum: x64? ? 'b0c9ada530f5ee90bb962afa9ed26218c582362315e13b1ba97e59767cb7825d' : 'f8beca5b463a36e1fef45ad0dca6a0de7606930380514ac1852df5ca6e3f6c1d',
        },
      ).tap do |packages|
        # Some packages are installed as QFE updates on 2012, 2012R2 & 10
        case nt_version
          when 6.2
            { '4.5.2' => 'KB2901982', '4.6' => 'KB3045562', '4.6.1' => 'KB3102439' }
          when 6.3
            { '4.5.2' => 'KB2934520', '4.6' => 'KB3045563', '4.6.1' => 'KB3102467', 'KB2919442' => 'KB2919442', 'KB2919355' => 'KB2919355' }
          when 10
            { '4.6.1' => 'KB3102495' }
          else
            {}
        end.each { |v, kb| packages[v][:not_if] = "C:\\Windows\\System32\\wbem\\wmic.exe QFE where HotFixID='#{kb}' | FindStr #{kb}" }
      end
    end

    protected

    def core?
      is_core
    end

    def server?
      is_server
    end

    def x64?
      arch == 'x64'
    end
  end
end
