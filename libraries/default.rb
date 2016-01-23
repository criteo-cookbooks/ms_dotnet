#
# Cookbook Name:: ms_dotnet
# Library:: default
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
require_relative 'v2_helper'
require_relative 'v3_helper'
require_relative 'v4_helper'

# Library module for cookbook ms_dotnet
module MSDotNet
  # Factory method to get VersionHelper for a given major .NET version
  def self.version_helper(node, major_version)
    case major_version
      when 2
        V2Helper.new node
      when 3
        V3Helper.new node
      when 4
        V4Helper.new node
      else
        raise ArgumentError, "Unsupported version '#{major_version}'"
    end
  end
end
