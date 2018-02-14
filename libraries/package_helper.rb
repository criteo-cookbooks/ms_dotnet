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
module MSDotNet
  # References the main official .NET setup and patch packages
  class PackageHelper
    attr_reader :arch, :full_version, :nt_version, :is_core, :is_server, :machine_type

    def initialize(node)
      @arch = node['kernel']['machine'] == 'x86_64' ? 'x64' : 'x86'
      @full_version = node['platform_version']
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
          not_if: %w(KB2901982 KB2934520),
        },
        '4.6' => {
          name:     'Microsoft .NET Framework 4.6',
          url:      'https://download.microsoft.com/download/C/3/A/C3A5200B-D33C-47E9-9D70-2F7C65DAAD94/NDP46-KB3045557-x86-x64-AllOS-ENU.exe',
          checksum: 'b21d33135e67e3486b154b11f7961d8e1cfd7a603267fb60febb4a6feab5cf87',
          not_if: %w(KB3045562 KB3045563),
        },
        '4.6.1' => {
          name:     'Microsoft .NET Framework 4.6.1',
          url:      'https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe',
          checksum: 'beaa901e07347d056efe04e8961d5546c7518fab9246892178505a7ba631c301',
          not_if: %w(KB3102439 KB3102467 KB3102495),
        },
        '4.6.2' => {
          name:     'Microsoft .NET Framework 4.6.2',
          url:      'https://download.microsoft.com/download/F/9/4/F942F07D-F26F-4F30-B4E3-EBD54FABA377/NDP462-KB3151800-x86-x64-AllOS-ENU.exe',
          checksum: '28886593e3b32f018241a4c0b745e564526dbb3295cb2635944e3a393f4278d4',
          not_if: %w(KB3151804 KB3151864 KB3151900),
        },
        '4.7' => {
          name:     'Microsoft .NET Framework 4.7',
          url:      'https://download.microsoft.com/download/D/D/3/DD35CC25-6E9C-484B-A746-C5BE0C923290/NDP47-KB3186497-x86-x64-AllOS-ENU.exe',
          checksum: '24762159579ec9763baec8c23555464360bd31677ee8894a58bdb67262e7e470',
          not_if: %w(KB3186505 KB3186539 KB3186568),
        },
        '4.7.1' => {
          name:     'Microsoft .NET Framework 4.7.1',
          url:      'https://download.microsoft.com/download/9/E/6/9E63300C-0941-4B45-A0EC-0008F96DD480/NDP471-KB4033342-x86-x64-AllOS-ENU.exe',
          checksum: '63dc850df091f3f137b5d4392f47917f847f8926dc8af1da9bfba6422e495805',
          not_if: %w(KB4033342 KB4033345 KB4033369 KB4033393),
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
        'KB3083184' => {
          name:     'Update for Microsoft .NET Framework 4.6 (KB3083184)',
          url:      "https://download.microsoft.com/download/C/2/8/C28720A0-2970-47F2-B7CF-E054FABCE6C0/Windows8-RT-KB3083184-#{arch}.msu",
          options:  '/norestart /quiet',
          checksum: x64? ? '6b685ecd2c996ff55265f53994fb53063a2665257fa194afa2fc14c3974b574c' : 'f59208f6e9c1e45c099f59e78d69c0354e2a9b9012bf345b7e3940ff1743a7b6',
          not_if:   %w(KB3083184),
        },
        'KB3083185' => {
          name:     'Update for Microsoft .NET Framework 4.6 (KB3083185)',
          url:      "https://download.microsoft.com/download/1/B/1/1B153916-43F3-4DD8-AD60-27F157E70149/Windows8.1-KB3083185-#{arch}.msu",
          options:  '/norestart /quiet',
          checksum: x64? ? '7f75909608907749c6b1de4f1ee461ae937772145a0921b32ab8b78af790a1bf' : '359d741ed99a5b3e846221099c2aaa67c7a8b1e599e7597531a84806ce68d987',
          not_if:   %w(KB3083185),
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
          not_if: %w(KB2919442 KB3173424 KB3021910 KB3012199 KB2989647 KB2975061 KB2969339 KB2904440),
        },
        'KB3173424' => {
          name:     'Update for Microsoft Windows (KB3173424)',
          url:      if x64?
                      'https://download.microsoft.com/download/E/2/C/E2CA92A3-8D60-4702-98E2-2AB396FEA1BC/Windows8.1-KB3173424-x64.msu'
                    else
                      'https://download.microsoft.com/download/4/5/F/45F8AA2A-1C72-460A-B9E9-83D3966DDA46/Windows8.1-KB3173424-x86.msu'
                    end,
          options:  '/norestart /quiet',
          checksum: x64? ? '2c6c577e4e231ce6b020e5b9a2766154f474c6ecae82735ba5ec03875d64895b' : '91bf481343be03cc310c50167be8ea1af92113048c99b7b91f1b2b03628b0dcd',
          not_if: %w(KB3173424),
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
          not_if: %w(KB2919355),
        },
        'KB4019990-6.1' => {
          name:     'Update for Microsoft Windows (KB4019990)',
          url:      "https://download.microsoft.com/download/2/F/4/2F4F48F4-D980-43AA-906A-8FFF40BCB832/Windows6.1-KB4019990-#{arch}.msu",
          options:  '/norestart /quiet',
          checksum: x64? ? '4ee562192cf21716f3c38cac3c2b17ef73b76708001d8a075d31df0996f0c6b3' : '62101125e4619575a55a4ff63d049debd33e04b485b6616058862c525050e210',
          not_if: %w(KB4019990),
        },
        'KB4019990-6.2' => {
          name:     'Update for Microsoft Windows (KB4019990)',
          url:      'https://download.microsoft.com/download/2/F/4/2F4F48F4-D980-43AA-906A-8FFF40BCB832/Windows8-RT-KB4019990-x64.msu',
          options:  '/norestart /quiet',
          checksum: 'f50efbd614094ebe84b0bccb0f89903e5619e5a380755d0e8170e8e893af7a9f',
          not_if: %w(KB4019990),
        },
        'KB4054856' => {
          name:     'Update for Microsoft Windows (KB4054856)',
          url:      'https://download.microsoft.com/download/8/5/E/85E5D4E2-7D95-40F7-AB83-9DBFCFBDBE6E/NDP471-KB4054856-x86-x64-AllOS.exe',
          options:  '/norestart /quiet',
          checksum: 'f98d12d84c803699d149a254ada3dd5dc0698307638e1baae209cc6f3a729e29',
          not_if:   %w(KB4054852 KB4054853 KB4054854 KB4054855),
        },
      )
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
