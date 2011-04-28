module Translatr
  class Merger
    attr_accessor :target, :target_filename,
                  :source, :source_filename

    def load_target(filename)
      self.target_filename = filename
      self.target = YAML.load_file(filename)
    end

    def load_source(filename)
      self.source_filename = filename
      self.source = YAML.load_file(filename)
    end

    def merge(target_hash=nil, source_hash=nil)
      target_hash ||= target
      source_hash ||= source
      source_hash.each_pair do |key, value|
        if target_hash.has_key?(key)
          if value.is_a?(Hash)
            merge(target_hash[key], source_hash[key])
          else
            unless variables_mismatch?(target_hash[key], value)
              target_hash[key] = value
            end
          end
        end
      end
      target_hash
    end

    def has_variables?(text_string)
      !text_string.gsub(/%\{(\w+)\}/).to_a.empty?
    end

    def variables_in(text_string)
      vars = text_string.gsub(/%\{(\w+)\}/).to_a
      return nil if vars.empty?
      return [vars[0]] if vars.size == 1
      vars
    end

    def variables_mismatch?(target_string, source_string)
      has_variables?(source_string) &&
        (variables_in(target_string) & variables_in(source_string) != variables_in(source_string))
    end
  end
end
