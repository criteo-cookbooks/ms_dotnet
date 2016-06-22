#
# Cookbook Name:: ms_dotnet
# Resource:: framework
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
actions :install
default_action :install
# The provides method is available on chef >= 12.0 only
provides :ms_dotnet_framework, os: 'windows' if respond_to?(:provides)

attribute :feature_source,  default: nil,         kind_of: [String, nil]
attribute :include_patches, default: true,        kind_of: [TrueClass, FalseClass]
attribute :package_sources, default: {}.freeze,   kind_of: Hash
attribute :require_support, default: false,       kind_of: [TrueClass, FalseClass]
attribute :timeout,         default: 600,         kind_of: Fixnum
attribute :version,         name_attribute: true, kind_of: String
