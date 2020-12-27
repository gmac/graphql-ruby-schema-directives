# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'graphql/schema_directives/version'

Gem::Specification.new do |spec|
  spec.name          = 'graphql-schema_directives'
  spec.version       = GraphQL::SchemaDirectives::VERSION
  spec.authors       = ['Greg MacWilliam']
  spec.summary       = 'Schema directives for graphql-ruby'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/gmac/graphql-schema-directives-ruby'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.2.0'

  spec.metadata    = {
    'homepage_uri' => 'https://github.com/gmac/graphql-schema-directives-ruby',
    'changelog_uri' => 'https://github.com/gmac/graphql-schema-directives-ruby/releases',
    'source_code_uri' => 'https://github.com/gmac/graphql-schema-directives-ruby',
    'bug_tracker_uri' => 'https://github.com/gmac/graphql-schema-directives-ruby/issues',
  }

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^test/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'graphql', '~> 1.9'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'minitest', '~> 5.12'
  spec.add_development_dependency 'warning', '~> 1.1'
end
