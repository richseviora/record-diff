# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'record_diff/version'

Gem::Specification.new do |spec|
  spec.name          = 'record_diff'
  spec.version       = RecordDiff::VERSION
  spec.authors       = ['Rich Seviora']
  spec.email         = ['richard.seviora@gmail.com']

  spec.summary       = 'Reconciles items'
  spec.homepage      = 'http://www.canada.com'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'http://canada.com'
  spec.metadata['changelog_uri'] = 'http://canada.com'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry', '~> 0.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop', '~> 0.74'
  spec.add_development_dependency 'rubocop-junit-formatter', '~> 0.1.4'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.35'
end
