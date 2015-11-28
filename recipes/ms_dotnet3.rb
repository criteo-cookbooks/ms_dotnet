#
# Cookbook Name:: ms_dotnet35
# Recipe:: default
#
# Copyright 2012, Webtrends, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Install .NET 3.5 Feature if we don't find part of the package already installed

if platform?('windows')
  include_recipe 'ms_dotnet'

  nt_version = ::Windows::VersionHelper.nt_version(node)

  if nt_version >= 6.0
    # Windows Server 2012 and earlier have Server features
    if nt_version >= 6.2 && ::Windows::VersionHelper.server_version?(node)
      feature_name = 'NetFx3ServerFeatures'
    else
      feature_name = 'NetFx3'
    end

    windows_feature feature_name do
      action :install

      # Below attributes are not supported before NT 6.2
      if nt_version >= 6.2
        source node['ms_dotnet']['v3']['source']
        all node['ms_dotnet']['v3']['enable_all_features']
      end
    end
  else
    Chef::Log.warn('The Microsoft .NET Framework 3.5 Chef recipe does not support version older than Windows Vista/2008.')
  end
else
  Chef::Log.warn('Microsoft Framework .NET 3.5 can only be installed on the Windows platform.')
end
