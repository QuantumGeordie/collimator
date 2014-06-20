# -*- encoding: utf-8 -*-
require File.expand_path('../lib/collimator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["geordie"]
  gem.email         = ["george.speake@gmail.com"]
  gem.description   = %q{Collimator}
  gem.summary       = %q{Easy to use tabulation for displaying data in command line scripts}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "collimator"
  gem.require_paths = ["lib"]
  gem.version       = Collimator::VERSION

  gem.add_development_dependency('rake', '~> 0.9.2')
  gem.add_dependency('colored')
end
