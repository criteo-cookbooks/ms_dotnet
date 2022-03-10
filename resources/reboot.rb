# frozen_string_literal: true

#
# Cookbook:: ms_dotnet
# Resource:: reboot
# Author:: Baptiste Courtois (<b.courtois@criteo.com>)
#
# Copyright:: (C) 2017, Criteo.
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

# The provides method is available on chef >= 12.0 only
provides :ms_dotnet_reboot, os: 'windows'
unified_mode true if respond_to?(:provides)

property :source, [String, Resource], desired_state: false

action :reboot_if_pending do
  source_name = new_resource.source || 'ms_dotnet_framework'
  reboot "Reboot for #{source_name}" do
    action :reboot_now
    delay_mins node['ms_dotnet']['reboot']['delay']
    reason "Reboot by chef for #{source_name}"
    only_if { reboot_pending? }
  end
end

# Override run_action to store the notifying_resource!
def run_action(action, notification_type = nil, notifying_resource = nil)
  source(notifying_resource) if source.nil? && !notifying_resource.nil?
  super
end

action_class do
end
