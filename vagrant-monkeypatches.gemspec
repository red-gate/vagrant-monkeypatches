# coding: utf-8
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "vagrant-monkeypatches"
  spec.version       = VagrantPlugins::VagrantMonkeyPatches::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Nico Vanelslande"]
  spec.email         = ["nico.vanelslande@red-gate.com"]

  spec.summary       = %q{plugin to quickly monkeypatch vagrant}
  spec.homepage      = "https://github.com/red-gate"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "Do not want to push this anywhere."
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = `git ls-files`.split("\n").map { |f| f =~ /^bin\/(.*)/ ? $1 : nil }.compact
  spec.require_paths = ["lib"]

  spec.add_dependency('win32-ipc', '~> 0.7.0')
  spec.add_dependency('win32-mutex', '~> 0.4.3')

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 12"
end
