# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'utf8mb4rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'utf8mb4rails'
  spec.version       = Utf8mb4rails::VERSION
  spec.authors       = ['Jose Fernandez (magec)']
  spec.email         = ['joseferper@gmail.com']

  spec.summary       = 'Adds a task to migrate mysql utf8 tables to utf8mb4 (emojis)'
  spec.description   = 'Poetry is so XIX century, nowadays we express ourselves using emojis. This gem adds a task to migrate mysql utf8 tables to utf8mb4 in rails projects.'
  spec.homepage      = 'https://github.com/magec/utf8mb4rails'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'departure', '~> 4.0', '>= 4.0.1'
  spec.add_runtime_dependency 'mysql2', '~> 0.4.0'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
