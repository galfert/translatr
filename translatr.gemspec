# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "translatr/version"

Gem::Specification.new do |s|
  s.name        = "translatr"
  s.version     = Translatr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Garret Alfert"]
  s.email       = ["alfert@wevelop.de"]
  s.homepage    = ""
  s.summary     = %q{Some i18n helpers for handling translations.}
  s.description = %q{Some i18n helpers for handling translations.}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "i18n",    ">= 0.4.2"
  s.add_dependency "ya2yaml", ">= 0.30"

  s.add_development_dependency "rspec",       ">= 2.5.0"
  s.add_development_dependency "guard",       ">= 0.3.0"
  s.add_development_dependency "guard-rspec", ">= 0.2.0"
  s.add_development_dependency "guard-spork", ">= 0.1.6"
  s.add_development_dependency "growl",       ">= 1.0.3"
end
