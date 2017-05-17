# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acbaker/version'

Gem::Specification.new do |s|
  s.name        = "acbaker"
  s.version     = Acbaker::VERSION
  s.licenses    = ["BSD-3-Clause"]
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tobias Strebitzer"]
  s.email       = ["tobias.strebitzer@magloft.com"]
  s.homepage    = "http://www.magloft.com"
  s.summary     = "Convert any source images into xcode asset catalogs."
  s.description = "This gem allows easy conversion and management of xcode asset catalogs."
  s.required_rubygems_version = '>= 1.3.6'
  s.add_dependency "commander", '~> 4.1'
  s.add_dependency 'json', '~> 1.8'
  s.add_dependency 'rmagick', '~> 2.13', '>= 2.13.4'
  s.add_development_dependency "rake", '~> 10.0'
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path = 'lib'
end
