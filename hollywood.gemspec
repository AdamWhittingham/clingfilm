# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hollywood'

Gem::Specification.new do |spec|
  spec.name          = "hollywood"
  spec.version       = Hollywood::VERSION
  spec.authors       = ["Adam Whittingham"]
  spec.email         = ["adam.whittingham@gmail.com"]
  spec.description   = %q{A light framework for concurrency in Ruby, built on top of Celluloid}
  spec.summary       = %q{Hollywood- a nice place for Ruby actors to live}
  spec.homepage      = "http://github.com/AdamWhittingham/hollywood"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
