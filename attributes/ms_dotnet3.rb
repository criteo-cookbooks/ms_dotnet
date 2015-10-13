#
# Cookbook Name:: ms_dotnet
# Attributes:: ms_dotnet3
# Author:: Jeremy MAURO (<j.mauro@criteo.com>)
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

if platform? 'windows'
  # DISM /all is only available on NT Version 6.2 (Windows 8/2012) or newer.
  default['ms_dotnet']['v3']['enable_all_features'] = true

  # DISM /source is only available on NT Version 6.2 (Windows 8/2012) or newer.
  # It can be used to use custom source folder e.g:
  # * Mounted Windows ISO: 'd:\sources\sxs'
  # * Windows share of a sxs folder: '\\servername\sxs'
  default['ms_dotnet']['v3']['source'] = nil
end
