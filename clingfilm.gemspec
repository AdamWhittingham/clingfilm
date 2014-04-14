# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "clingfilm"
  spec.version       = '0.4.1'
  spec.authors       = ["Adam Whittingham"]
  spec.email         = ["adam.whittingham@gmail.com"]
  spec.description   = %q{A light and easy way of working concurrently with Ruby, built on top of Celluloid}
  spec.summary       = %q{A light, thin wrapper made of Celluloid}
  spec.homepage      = "http://github.com/AdamWhittingham/clingfilm"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "celluloid", ">= 0.14.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
