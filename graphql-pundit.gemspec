# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphql-pundit/version'

Gem::Specification.new do |spec|
  spec.name          = 'graphql-pundit2'
  spec.version       = GraphQL::Pundit::VERSION
  spec.authors       = ['Lubomir Vnenk']
  spec.email         = ['lubomir.vnenk@zoho.com']

  spec.summary       = 'Pundit authorization support for new graphql interpreter'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/lubosch/graphql-pundit'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'graphql', '>= 1.6.4', '< 1.13.0'
  spec.add_dependency 'pundit', '~> 2.1.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'codecov', '~> 0.1.10'
  spec.add_development_dependency 'fuubar', '~> 2.5.0'
  spec.add_development_dependency 'pry', '~> 0.13.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.9.0'
  spec.add_development_dependency 'pry-rescue', '~> 1.5.0'
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.4.9.2'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop', '>= 0.83.0'
  spec.add_development_dependency 'simplecov', '~> 0.18.5'
end
