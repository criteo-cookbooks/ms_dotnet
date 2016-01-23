#
# Cookbook Name:: ms_dotnet
# Attributes:: default
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

default['ms_dotnet']['timeout'] = 600

# .NET 2 attributes
default['ms_dotnet']['v2']['version']         = '2.0.SP2'
default['ms_dotnet']['v2']['include_patches'] = true
default['ms_dotnet']['v2']['feature_source']  = nil
default['ms_dotnet']['v2']['package_sources'] = {}
default['ms_dotnet']['v2']['require_support'] = false

# .NET 3 attributes
default['ms_dotnet']['v3']['version']         = '3.5.SP1'
default['ms_dotnet']['v3']['include_patches'] = true
default['ms_dotnet']['v3']['feature_source']  = nil
default['ms_dotnet']['v3']['package_sources'] = {}
default['ms_dotnet']['v3']['require_support'] = false

# .NET 4 attributes
default['ms_dotnet']['v4']['version']         = '4.0'
default['ms_dotnet']['v4']['include_patches'] = true
default['ms_dotnet']['v4']['feature_source']  = nil
default['ms_dotnet']['v4']['package_sources'] = {}
default['ms_dotnet']['v4']['require_support'] = false
