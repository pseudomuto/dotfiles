# frozen_string_literal: true

require_relative "lib/dotfiles/version"

Gem::Specification.new do |spec|
  spec.name          = "dotfiles"
  spec.version       = Dotfiles::VERSION
  spec.authors       = ["David Muto (pseudomuto)"]
  spec.email         = ["david.muto@gmail.com"]

  spec.summary       = "A little app for my dotfiles and some common applications"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/pseudomuto/dotfiles"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["allowed_push_host"] = "https://notreal.example.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # to be kept up to date with exe/dotfiles
  spec.add_dependency("cli-kit", "~> 3.3.0")
end
