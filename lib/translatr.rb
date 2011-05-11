require 'core_ext/hash'
require 'translatr/merger'
require 'translatr/railtie' if defined?(Rails::Railtie)

Dir["tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)

module Translatr
end
