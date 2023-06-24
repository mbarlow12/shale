# frozen_string_literal: true

require_relative 'lib/fido/version'

Gem::Specification.new do |spec|
  spec.name = 'fido'
  spec.version = Fido::VERSION
  spec.authors = ['Kamil Giszczak']
  spec.email = ['beerkg@gmail.com']

  spec.summary = 'Ruby object mapper and serializer for XML, JSON, TOML, CSV and YAML.'
  spec.description = 'Ruby object mapper and serializer for XML, JSON, TOML, CSV and YAML.'
  spec.homepage = 'https://fidorb.org'
  spec.license = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = 'https://fidorb.org'
  spec.metadata['source_code_uri'] = 'https://github.com/kgiszczak/fido'
  spec.metadata['changelog_uri'] = 'https://github.com/kgiszczak/fido/blob/master/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/kgiszczak/fido/issues'

  spec.files = Dir['CHANGELOG.md', 'LICENSE.txt', 'README.md', 'fido.gemspec', 'lib/**/*']
  spec.require_paths = ['lib']

  spec.bindir = 'exe'
  spec.executables = 'fidob'

  spec.required_ruby_version = '>= 2.6.0'
end
