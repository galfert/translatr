require 'i18n'
require 'ya2yaml'

module Translatr
  class Merger
    attr_accessor :target, :target_filename, :target_locale,
                  :source, :source_filename, :source_locale

    def initialize(source_filename = nil, target_filename = nil)
      load_source(source_filename) if source_filename
      load_target(target_filename) if target_filename
    end

    def load_source(filename)
      self.source_filename = filename
      I18n.backend.reload!
      I18n.backend.load_translations(filename)
      self.source_locale = I18n.backend.available_locales.first
      self.source = I18n.backend.send(:translations)[source_locale]
    end

    def load_target(filename)
      self.target_filename = filename
      I18n.backend.reload!
      I18n.backend.load_translations(filename)
      self.target_locale = I18n.backend.available_locales.first
      self.target = I18n.backend.send(:translations)[target_locale]
    end

    def merge(target_hash = nil, source_hash = nil)
      target_hash ||= target
      source_hash ||= source
      source_hash.each_pair do |key, value|
        if target_hash.has_key?(key)
          if value.is_a?(Hash)
            merge(target_hash[key], source_hash[key])
          else
            if matching_variables?(target_hash[key], value)
              target_hash[key] = value
            end
          end
        end
      end
      target_hash
    end

    def store(filename = nil)
      filename ||= target_filename
      data = Hash.new
      data[target_locale] = merge
      data = data.deep_stringify_keys
      File.open(filename, "w") do |file|
        if data.respond_to?(:ya2yaml)
          file.write(data.ya2yaml(:syck_compatible => true))
        else
          YAML.dump(data, file)
        end
      end
    end

    def has_variables?(text_string)
      !text_string.gsub(/%\{(\w+)\}/).to_a.empty?
    end

    def variables_in(text_string)
      vars = text_string.gsub(/%\{(\w+)\}/).to_a
      return nil if vars.empty?
      return [vars[0]] if vars.size == 1
      vars.uniq
    end

    def matching_variables?(target_string, source_string)
      return true unless has_variables?(source_string)
      variables_in(target_string) & variables_in(source_string) == variables_in(source_string)
    end
  end
end
