# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pathfinder_common/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Conrad Taylor"]
  gem.email         = ["conradwt@gmail.com"]
  gem.description   = %q{Write a gem description}
  gem.summary       = %q{Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pathfinder_common"
  gem.require_paths = ["lib"]
  gem.version       = PathfinderCommon::VERSION

  # specify any dependencies here; for example:

  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'minitest-reporters'

  # gem.add_runtime_dependency "rest-client"
  gem.add_runtime_dependency 'actionpack', '>= 3.2.9'
end
