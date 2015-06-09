ms_dotnet CHANGELOG
===================

This file is used to list changes made in each version of the ms_dotnet cookbook.
2.3.0
-----
- b.courtois - Register aspnet to iis once and only if ISS is present.
2.2.1
-----
- minkaotic  - Fix .NET 3.5 install guard clause.
2.2.0
-----
- b.courtois - Do not use the windows_reboot resource and its request action.
2.1.1
-----
- b.courtois - Update constraint to leverage windows cookbook >=1.36.1
2.1.0
-----
- b.courtois - Fix .NET4.5 support on windows 7/Server 2008R2
2.0.0
-----
- b.courtois - Fail chef run when an invalid .NET4 version is specified
- b.courtois - Better support of recents windows version for .NET4
- b.courtois - Add ms_dotnet3 recipe
- b.courtois - Fix ms_dotnet2 recipe and stop to use ms_dotnet2 attributes
1.2.0
-----
- b.courtois - Fail chef run when an invalid .NET4 version is specified
1.1.0
-----
- b.courtois - Fix attributes computation
1.0.0
-----
- b.courtois - Merge recipes ms_dotnet4 and ms_dotnet45
- b.courtois - Add basic support for Server 2012 & 2012R2
0.2.0
-----
- b.courtois - include default recipe on msdotnet2 core install
0.1.0
-----
- j.mauro - Initial release of ms_dotnet

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
