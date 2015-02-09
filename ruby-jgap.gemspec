# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "ruby-jgap"
  spec.version       = "0.0.1"
  spec.platform      = "java"
  spec.authors       = ["William Chen"]
  spec.email         = ["wchen298@gmail.com"]
  spec.summary       = %q{Ruby DSL for Genetic Algorithms using JGAP as a backend.} 
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
