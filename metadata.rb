name             'ms_dotnet'
maintainer       'Criteo'
maintainer_email 'b.courtois@criteo.com'
license          'Apache 2.0'
description      'Installs/Configures ms_dotnet'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.1.1'
supports         'windows'
depends          'windows', '>= 3.0'

chef_version '>= 12.1' if respond_to?(:chef_version)
source_url 'https://github.com/criteo-cookbooks/ms_dotnet' if respond_to?(:source_url)
issues_url 'https://github.com/criteo-cookbooks/ms_dotnet/issues' if respond_to?(:issues_url)
