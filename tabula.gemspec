# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tabula/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["geordie"]
  gem.email         = ["george.speake@gmail.com"]
  gem.description   = %q{Tabula}
  gem.summary       = %q{Easy to use tabulation for displaying data in command line scripts}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tabula"
  gem.require_paths = ["lib"]
  gem.version       = Tabula::VERSION
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('rake', '~> 0.9.2')
  gem.add_dependency('colored')
end
