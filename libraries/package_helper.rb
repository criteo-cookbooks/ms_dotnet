# frozen_string_literal: true

#
# Cookbook:: ms_dotnet
# Library:: package_helper
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
#
# Copyright:: (C) 2015-2016, Criteo.
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
      @nt_version = @full_version.to_f
      @is_core = ::MSDotNet::WindowsVersionHelper.core_version?(node)
      @is_server = ::MSDotNet::WindowsVersionHelper.server_version?(node)

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
        '3.5.SP1' => {
          name: 'Microsoft .NET Framework 3.5 Service Pack 1',
          url: 'https://download.microsoft.com/download/2/0/E/20E90413-712F-438C-988E-FDAA79A8AC3D/dotnetfx35.exe',
          checksum: '0582515bde321e072f8673e829e175ed2e7a53e803127c50253af76528e66bc1',
        },
        '4.6.2' => {
          name: 'Microsoft .NET Framework 4.6.2',
          url: 'https://download.visualstudio.microsoft.com/download/pr/8e396c75-4d0d-41d3-aea8-848babc2736a/80b431456d8866ebe053eb8b81a168b3/ndp462-kb3151800-x86-x64-allos-enu.exe',
          checksum: 'b4cbb4bc9a3983ec3be9f80447e0d619d15256a9ce66ff414ae6e3856705e237',
          not_if: %w(KB3151804 KB3151864 KB3151900),
        },
        '4.7' => {
          name: 'Microsoft .NET Framework 4.7',
          url: 'https://download.visualstudio.microsoft.com/download/pr/2dfcc711-bb60-421a-a17b-76c63f8d1907/e5c0231bd5d51fffe65f8ed7516de46a/ndp47-kb3186497-x86-x64-allos-enu.exe',
          checksum: 'd9690c83d7ce56b2804ea34aef79ce34b242d60b9cec16385bce1340cfe00883',
          not_if: %w(KB3186505 KB3186539 KB3186568),
        },
        '4.7.1' => {
          name: 'Microsoft .NET Framework 4.7.1',
          url: 'https://download.visualstudio.microsoft.com/download/pr/4312fa21-59b0-4451-9482-a1376f7f3ba4/9947fce13c11105b48cba170494e787f/ndp471-kb4033342-x86-x64-allos-enu.exe',
          checksum: 'df6e700d37ff416e2e1d8463dededdf76522ceaf5bb4cc3f197a7f2b9eccc4ad',
          not_if: %w(KB4033342 KB4033345 KB4033369 KB4033393),
        },
        '4.7.2' => {
          name: 'Microsoft .NET Framework 4.7.2',
          url: 'https://download.visualstudio.microsoft.com/download/pr/1f5af042-d0e4-4002-9c59-9ba66bcf15f6/089f837de42708daacaae7c04b7494db/ndp472-kb4054530-x86-x64-allos-enu.exe',
          checksum: '5cb624b97f9fd6d3895644c52231c9471cd88aacb57d6e198d3024a1839139f6',
          not_if: %w(KB4054542 KB4054566 KB4054590 KB4073120),
        },
        '4.8' => {
          name: 'Microsoft .NET Framework 4.8',
          url: 'https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe',
          checksum: '68c9986a8dcc0214d909aa1f31bee9fb5461bb839edca996a75b08ddffc1483f',
          not_if: %w(KB4503548 KB4486081 KB4486105 KB4486129 KB4486153),
        },
        ###########
        # Patches
        ###########
        'KB2919442' => {
          name: 'Update for Microsoft Windows (KB2919442)',
          url: if x64?
                 'https://download.microsoft.com/download/D/6/0/D60ED3E0-93A5-4505-8F6A-8D0A5DA16C8A/Windows8.1-KB2919442-x64.msu'
               else
                 'https://download.microsoft.com/download/9/D/A/9DA6C939-9E65-4681-BBBE-A8F73A5C116F/Windows8.1-KB2919442-x86.msu'
               end,
          options: '/norestart /quiet',
          checksum: x64? ? 'c10787e669b484674584a990e069295e8b81b5366f98508010a3ae181b729482' : '3368c3a329f402fd982b15b399368627b96973f008a5456b5286bdfc10c1169b',
          not_if: %w(KB2919442 KB3173424 KB3021910 KB3012199 KB2989647 KB2975061 KB2969339 KB2904440),
        },
        'KB3173424' => {
          name: 'Update for Microsoft Windows (KB3173424)',
          url: if x64?
                 'https://download.microsoft.com/download/E/2/C/E2CA92A3-8D60-4702-98E2-2AB396FEA1BC/Windows8.1-KB3173424-x64.msu'
               else
                 'https://download.microsoft.com/download/4/5/F/45F8AA2A-1C72-460A-B9E9-83D3966DDA46/Windows8.1-KB3173424-x86.msu'
               end,
          options: '/norestart /quiet',
          checksum: x64? ? '2c6c577e4e231ce6b020e5b9a2766154f474c6ecae82735ba5ec03875d64895b' : '91bf481343be03cc310c50167be8ea1af92113048c99b7b91f1b2b03628b0dcd',
          not_if: %w(KB3173424),
        },
        'KB2919355' => {
          name: 'Update for Microsoft Windows (KB2919355)',
          url: if x64?
                 'https://download.microsoft.com/download/2/5/6/256CCCFB-5341-4A8D-A277-8A81B21A1E35/Windows8.1-KB2919355-x64.msu'
               else
                 'https://download.microsoft.com/download/4/E/C/4EC66C83-1E15-43FD-B591-63FB7A1A5C04/Windows8.1-KB2919355-x86.msu'
               end,
          options: '/norestart /quiet',
          checksum: x64? ? 'b0c9ada530f5ee90bb962afa9ed26218c582362315e13b1ba97e59767cb7825d' : 'f8beca5b463a36e1fef45ad0dca6a0de7606930380514ac1852df5ca6e3f6c1d',
          not_if: %w(KB2919355),
        },
        'KB4019990-6.2' => {
          name: 'Update for Microsoft Windows (KB4019990)',
          url: 'https://download.microsoft.com/download/2/F/4/2F4F48F4-D980-43AA-906A-8FFF40BCB832/Windows8-RT-KB4019990-x64.msu',
          options: '/norestart /quiet',
          checksum: 'f50efbd614094ebe84b0bccb0f89903e5619e5a380755d0e8170e8e893af7a9f',
          not_if: %w(KB4019990),
        },
        'KB4054852' => {
          name: 'Update for Microsoft .NET Framework 4.7.1 (KB4054852)',
          url: 'https://download.microsoft.com/download/8/5/E/85E5D4E2-7D95-40F7-AB83-9DBFCFBDBE6E/NDP471-KB4054856-x86-x64-AllOS.exe',
          options: '/norestart /quiet',
          checksum: 'f98d12d84c803699d149a254ada3dd5dc0698307638e1baae209cc6f3a729e29',
        },
        'KB4054853' => {
          name: 'Update for Microsoft Windows (KB4054853)', # Cosmetic name
          url: 'https://download.microsoft.com/download/8/5/E/85E5D4E2-7D95-40F7-AB83-9DBFCFBDBE6E/NDP471-KB4054856-x86-x64-AllOS.exe',
          options: '/norestart /quiet',
          checksum: 'f98d12d84c803699d149a254ada3dd5dc0698307638e1baae209cc6f3a729e29',
          not_if: %w(KB4054853),
        },
        'KB4054854' => {
          name: 'Update for Microsoft Windows (KB4054854)', # Cosmetic name
          url: 'https://download.microsoft.com/download/8/5/E/85E5D4E2-7D95-40F7-AB83-9DBFCFBDBE6E/NDP471-KB4054856-x86-x64-AllOS.exe',
          options: '/norestart /quiet',
          checksum: 'f98d12d84c803699d149a254ada3dd5dc0698307638e1baae209cc6f3a729e29',
          not_if: %w(KB4054854),
        },
        'KB4054855' => {
          name: 'Update for Microsoft Windows (KB4054855)', # Cosmetic name
          url: 'https://download.microsoft.com/download/8/5/E/85E5D4E2-7D95-40F7-AB83-9DBFCFBDBE6E/NDP471-KB4054856-x86-x64-AllOS.exe',
          options: '/norestart /quiet',
          checksum: 'f98d12d84c803699d149a254ada3dd5dc0698307638e1baae209cc6f3a729e29',
          not_if: %w(KB4054855),
        },
        'KB4073120' => {
          name: 'Update for Microsoft Windows (KB4073120)', # Cosmetic name
          url: 'http://download.windowsupdate.com/d/msdownload/update/software/ftpk/2018/07/windows10.0-kb4073120-x64_3ec6124b919d92627020d226bdcc34695c7c7080.msu',
          options: '/norestart /quiet',
          checksum: 'b029cfe1d1995009c856a147560b35ed858faf1f300fd42c0a0b4e0df99bfcfa',
          not_if: %w(KB4073120),
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
