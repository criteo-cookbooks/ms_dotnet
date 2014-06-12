#
# Cookbook Name:: ms_dotnet
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'windows' if platform?('windows')
include_recipe 'windows::reboot_handler'

windows_reboot 'ms_dotnet' do
  timeout 60
  reason 'Microsoft DotNet Installation'
  action :nothing
end
