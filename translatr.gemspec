# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "translatr/version"

Gem::Specification.new do |s|
  s.name        = "translatr"
  s.version     = Translatr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "translatr"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "i18n", ">= 0.5.0"

  s.add_development_dependency "rspec",       ">= 2.5.0"
  s.add_development_dependency "guard",       ">= 0.3.0"
  s.add_development_dependency "guard-rspec", ">= 0.2.0"
  s.add_development_dependency "guard-spork", ">= 0.1.6"
  s.add_development_dependency "growl",       ">= 1.0.3"
end
