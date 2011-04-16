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

    def merge
      target.merge(source).select do |key, value|
        target.has_key? key
      end
    end
  end
end
