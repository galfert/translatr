require 'translatr'

namespace :translatr do
  desc "Merge source into target"
  task :merge do |t|
    unless ENV.include?("source") && ENV.include?("target")
      raise "usage: rake #{t} source=SOURCEFILE target=TARGETFILE [dest=DESTINATIONFILE]"
    end

    merger = Translatr::Merger.new(ENV["source"], ENV["target"])
    merger.merge
    merger.store(ENV["dest"])
  end
end
