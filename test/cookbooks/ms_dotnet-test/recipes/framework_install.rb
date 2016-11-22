#
# Cookbook Name:: ms_dotnet-test
# Recipe:: framework_install
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
fwk_info = node['ms_dotnet_test']['framework_install']
ms_dotnet_framework 'install' do
  version           fwk_info['version']
  timeout           fwk_info['timeout']         unless fwk_info['timeout'].nil?
  include_patches   fwk_info['include_patches'] unless fwk_info['include_patches'].nil?
  feature_source    fwk_info['feature_source']  unless fwk_info['feature_source'].nil?
  perform_reboot    fwk_info['perform_reboot']  unless fwk_info['perform_reboot'].nil?
  package_sources   fwk_info['package_sources'] unless fwk_info['package_sources'].nil?
  require_support   fwk_info['require_support'] unless fwk_info['require_support'].nil?
end
