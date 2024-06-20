module OutputFormatter
    module_function
  
    def exclude_keys(data, keys)
      output = {}
      data.each do |key, value|
        output[key] = value unless keys.include?(key)
      end
      output
    end
  
    def exclude_array_keys(data, keys)
      data.map { |element| exclude_keys(element, keys) }
    end
  
    def exclude_array_keys_unique(data, keys)
      exclude_keys(data, keys)
    end
end