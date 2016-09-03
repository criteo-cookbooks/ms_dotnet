name              'ms_dotnet4'
maintainer        'Chef Software, Inc.'
maintainer_email  'cookbooks@chef.io'
license           'Apache 2.0'
description       'Installs Microsoft .NET 4.0'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.0.3'
supports          'windows'

source_url 'https://github.com/chef-cookbooks/ms_dotnet4'
issues_url 'https://github.com/chef-cookbooks/ms_dotnet4/issues'
chef_version     '>= 12.1' if respond_to?(:chef_version)
