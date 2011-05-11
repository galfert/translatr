require 'core_ext/hash'
require 'translatr/merger'

Dir["tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)

module Translatr
end
