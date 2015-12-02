name              'ms_dotnet45'
maintainer        'Tim Smith'
maintainer_email  'tsmith@chef.io'
license           'Apache 2.0'
description       'Installs Microsoft .NET 4.5'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '2.0.0'
supports          'windows'
depends           'windows'

source_url 'https://github.com/tas50/ms_dotnet45' if respond_to?(:source_url)
issues_url 'https://github.com/tas50/ms_dotnet45/issues' if respond_to?(:issues_url)
