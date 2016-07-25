name             'ms_dotnet'
maintainer       'Criteo'
maintainer_email 'b.courtois@criteo.com'
license          'Apache 2.0'
description      'Installs/Configures ms_dotnet'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.0.0'
supports         'windows'
depends          'windows', '>= 1.36.1'

chef_version '>= 11.10' if respond_to?(:chef_version)
source_url 'https://github.com/criteo-cookbooks/ms_dotnet' if respond_to?(:source_url)
issues_url 'https://github.com/criteo-cookbooks/ms_dotnet/issues' if respond_to?(:issues_url)
