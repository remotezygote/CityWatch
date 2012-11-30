# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
	s.name        = "city_watch"
	s.version     = CityWatch::VERSION
	s.platform    = Gem::Platform::RUBY
	s.authors     = ["John Bragg"]
	s.email       = ["john@cozy.co"]
	s.homepage    = "http://cozy.co"
	s.summary     = %q{Server/process monitoring}
	s.description = %q{}
	
	s.rubyforge_project = "city_watch"
	
	s.files         = `git ls-files`.split("\n")
	s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
	s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
	s.require_paths = ["lib"]
	s.required_ruby_version = '>= 1.9.2'
	s.add_dependency "redis"
	s.add_dependency "rspec"
end
