class RegistryMock
  def initialize(hash)
    @data = hash
  end

  def fetch(key_path)
    key_path.split(%r{\\|\/}).inject(@data) do |root, key|
      break unless root.is_a? Hash

      root[key.to_s]
    end
  end

  def key_exists?(key_path)
    fetch(key_path).is_a? Hash
  end

  def get_values(key_path)
    fetch(key_path).reject { |_, v| v.is_a? Hash }.map { |k, v| { name: k, data: v } }
  end

  def has_subkeys?(key_path)
    fetch(key_path).values.any? { |v| v.is_a? Hash }
  end

  def get_subkeys(key_path)
    fetch(key_path).select { |_, v| v.is_a? Hash }.keys
  end

  def value_exists?(key_path, value)
    fetch(key_path).key? value
  end

  def data_exists?(key_path, value)
    fetch(key_path)[value[:name]] == value[:data]
  end
end
