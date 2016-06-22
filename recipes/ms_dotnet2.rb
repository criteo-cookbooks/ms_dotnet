#
# Cookbook Name:: ms_dotnet
# Recipe:: ms_dotnet2
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
return unless platform? 'windows'

v2_info = node['ms_dotnet']['v2']

ms_dotnet_framework v2_info['version'] do
  timeout           node['ms_dotnet']['timeout']
  include_patches   v2_info['include_patches']
  feature_source    v2_info['feature_source'] unless v2_info['feature_source'].nil?
  package_sources   v2_info['package_sources']
  require_support   v2_info['require_support']
end
