# ms_dotnet45 Cookbook
[![Build Status](https://travis-ci.org/chef-cookbooks/ms_dotnet45.svg?branch=master)](https://travis-ci.org/chef-cookbooks/ms_dotnet45)
[![Cookbook Version](https://img.shields.io/cookbook/v/ms_dotnet45.svg)](https://supermarket.chef.io/cookbooks/ms_dotnet45)

This cookbook installs the Microsoft .NET Framework 4.5

## Requirements
### Platforms
- Windows Vista SP1 or later
- Windows Server 2008 (not supported on Server Core)
- Windows 7
- Windows Server 2008 R2 (not supported on Server Core )

### Chef
- Chef 11+

### Cookbooks
- windows


## Attributes
- `default['ms_dotnet45']['http_url']`: Download URL for MS .NET 4.5 MSI
- `default['ms_dotnet45']['timeout']`: Timeout for completing the installation


## Usage
Include the default recipe on a node's runlist to ensure that .NET Framework 4.5 is installed on the system


# License & Authors
**Author:** Tim Smith ([tsmith@chef.io](mailto:tsmith@chef.io))

**Copyright:** 2011-2015, Webtrends, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```