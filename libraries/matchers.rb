if defined?(ChefSpec)
  ChefSpec.define_matcher :ms_dotnet_framework
  def install_ms_dotnet_framework(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:ms_dotnet_framework, :install, resource)
  end
end
