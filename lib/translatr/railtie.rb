require 'translatr'
require 'rails'

module Translatr
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/translatr.rake"
    end
  end
end
