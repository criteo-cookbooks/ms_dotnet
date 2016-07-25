ms_dotnet Cookbook
==================
[![Cookbook Version][cookbook_version]][cookbook]
[![Build Status][build_status]][build_status]

Install the Microsoft .NET Framework.

Requirements
------------
This cookbook supports Chef 11.10.0+

### Platforms
* Windows XP
* Windows Vista
* Windows Server 2003 R2
* Windows 7
* Windows Server 2008 (R1, R2)
* Windows 8 and 8.1
* Windows Server 2012 (R1, R2)

### Cookbooks
The following cookbook is required as noted:

* [windows](windows_cookbook) (> 1.36.1)

    `ms_dotnet_framework` LWRP leverage the windows_package LWRP

Known Issues
------------
Here are the known issues you can encounter with ms_dotnet recipes:
* "Access denied" error on windows_package when running chef via WinRM
  * `Cause`: winrm limitation
  * `Common environment`: knife windows bootstrap, chef-provisioning, test-kitchen
  * `Theoretical solution`: try to simulate a local session by wrapping your chef-client call in psexec or a schedule task.
  * `Test-Kitchen solution`: with v1.8.0 you can use [the winrm-elevated feature](issue_winrm_elevated) that'll run chef via a schedule task

Usage
-----
This cookbook provides you two methods to install the major versions of .NET framework.

### Common case - Recipes
In common cases you can use the attributes driven recipes provided by this cookbook to setup .NET.
### Custom case - LWRP
In more custom cases, you might need to control in your own cookbook which .NET version should be installed and when the setup should be performed.
You just need to use the `ms_dotnet_framework` LWRP  which handles for you the setup mode - feature vs package - and may also install all known patches.

Resource/Provider
-----------------
### ms_dotnet_framework
#### Actions
* `:install` - Install a specific .NET framework

#### Attribute Parameters
* `version` - Name attribute. Specify the .NET version to install.
* `include_patches` - Determine whether patches should also be applied (default: `true`)
* `feature_source` - Specify custom source for windows features. Only avaiable on NT Version 6.2 (Windows 8/2012) or newer. (default: `nil`)
* `package_sources` - Specify custom sources URL for windows packages. URL are indexed by their content SHA256 checkum.  (default: `{}`)
* `require_support` - Determine whether chef should fail when given version is not supported on the current OS (default: `false`)

> NB: `feature_source` works only on NT Version 6.2 (Windows 8/2012) or newer.

#### Examples
Install .NET 4.5.2 from custom sources

```ruby
ms_dotnet_framework '4.5.2' do
  action            :install
  include_patches   true
  package_sources   { '6c2c589132e830a185c5f40f82042bee3022e721a216680bd9b3995ba86f3781' => 'http://my-own.site.com/NetFx452.exe' }
  require_support   true
end
```

Attributes
----------
This cookbook is mostly attributes driven, default values should be enough for common cases.
> NB: because this cookbook is usefull only for windows, attributes are not available on other platforms

### Common attributes
Below attributes are accessible via `node['ms_dotnet']['ATTRIBUTE_NAME']` and are common to all recipes:
* `timeout` - Control the execution timeout in seconds of .NET setup packages (default: `600`)

### .NET recipes attributes
Recipes `ms_dotnet2`, `ms_dotnet3` and `ms_dotnet4` are controlled by the following attributes accessible via `node['ms_dotnet']['vX']['ATTRIBUTE_NAME']` - where `X` is the .NET major version:

* `version` - Specify the .NET version to install (default: `2.0.SP2`, `3.5.SP1`, `4.0`)
* `include_patches` - Determine whether patches should also be applied (default: `true`)
* `feature_source` - Specify custom source for windows features. Only avaiable on NT Version 6.2 (Windows 8/2012) or newer. (default: `nil`)
* `package_sources` - Specify custom sources URL for windows packages. URL are indexed by their content SHA256 checkum.  (default: `{}`)
* `require_support` - Determine whether chef should fail when given version is not supported on the current OS (default: `false`)

> NB: `feature_source` works only on NT Version 6.2 (Windows 8/2012) or newer.

### Examples
#### Install .NET 3.5 SP1 using a Windows UNC Share
Custom node file to install .NET 3.5 SP1 with no patch on a Windows Server 2012R2, using a Windows share for features binaries:
```json
{
  "name": "my-node.examples.com",
  "run_list": [ "recipe[ms_dotnet::ms_dotnet3" ],
  "normal": {
    "ms_dotnet": {
      "v3": {
        "include_patches": "false",
        "feature_source": "\\ShareSvr\sxs"
      }
    }
  }
}
```

#### Install .NET 4.5.2 using a package hosted on a custom site
Custom node file to install .NET 4.5.2 from a custom site:
```json
{
  "name": "my-node.examples.com",
  "run_list": [ "recipe[ms_dotnet::ms_dotnet4" ],
  "normal": {
    "ms_dotnet": {
      "v4": {
        "version": "4.5.2",
        "package_sources": {
          "6c2c589132e830a185c5f40f82042bee3022e721a216680bd9b3995ba86f3781": "://my-own.site.com/NetFx452.exe"
        }
      }
    }
  }
}
```

Recipes
-------
#### ms_dotnet::default
This recipe does nothing.

#### ms_dotnet::ms_dotnet2, ms_dotnet::ms_dotnet3, ms_dotnet::ms_dotnet4
Each of these recipes allow you to install a specific major version of .NET Framework, just by including the recipe in your node `run_list`.
They are attribute driven recipes, please referes to the `Attributes` section of this README to know how to control their behavior.

### ms_dotnet::regiis
This recipe register .NET 4 to IIS once and only if IIS service exist.

Libraries
---------
### Default
Provides convenients method for the `ms_dotnet` cookbook.

#### version_helper
Provides a factory to get specific VersionHelper instance.

### PackageHelper
References all official .NET setup & patches packages supported by this cookbook.

#### packages
Retrieve a Hash containing .NET setup packages info - `name`, `checksum`, `url` & `not_if` guard.

#### core?
Determine whether the current node is running on a Core version of Windows.

#### server?
Determine whether the current node is running on a Server version of Windows.

#### x64?
Determine whether the architecture of the current node is 64-bits.

### VersionHelper
Base abstract class inheriting from `PackageHelper` and providing convenient methods to determine which .NET version the current node supports, and how the setup should be handled.

#### features
Get windows features required by the given .NET version

#### installed_version
Get installed .NET version on the current node

#### package
Get windows package required by the given .NET version

#### patches
Get windows patches required by the given .NET version

#### prerequisites
Get windows packages required before installing the given .NET version

#### supported_versions
Get all .NET versions supported on the current node OS

### V2Helper, V3Helper, V4Helper
Subclass of the `VersionHelper`, providing helpers for a specific major version of the .NET Framework.

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: [Baptiste Courtois][annih] (<b.courtois@criteo.com>), [Jeremy Mauro][jmauro] (<j.mauro@criteo.com>)

```text
Copyright 2014-2015, Criteo.

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
[annih]:                    https://github.com/Annih
[jmauro]:                   https://github.com/jmauro
[repository]:               https://github.com/criteo-cookbooks/ms_dotnet
[build_status]:             https://api.travis-ci.org/criteo-cookbooks/ms_dotnet.svg?branch=master
[cookbook_version]:         https://img.shields.io/cookbook/v/ms_dotnet.svg
[cookbook]:                 https://supermarket.chef.io/cookbooks/ms_dotnet
[winrm_elevated_issue]:     https://github.com/test-kitchen/test-kitchen/issues/876#issuecomment-222006913
