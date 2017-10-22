# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'fluent-plugin-viaq_docker_audit_log_parser'
  spec.version       = '0.0.5'
  spec.authors       = ['Josef Karasek']
  spec.email         = ['jkarasek@redhat.com']
  spec.summary       = %q{Fluentd plugin for parsing atomic-project docker auditd logs}
  spec.homepage      = 'https://github.com/viaq/fluent-plugin-viaq_docker_audit_log_parser'
  spec.license       = 'Apache-2.0'

  spec.files         = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'test-unit', '>= 3.1.5'
  spec.add_runtime_dependency 'fluentd', '>= 0.12.0'
end
