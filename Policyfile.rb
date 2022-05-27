name 'ms_dotnet'

run_list ['ms_dotnet']

cookbook 'ms_dotnet', path: '.'
cookbook 'ms_dotnet-test', path: 'test/cookbooks/ms_dotnet-test'
