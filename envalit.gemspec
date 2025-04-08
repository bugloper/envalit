# frozen_string_literal: true

require_relative "lib/envalit/version"

Gem::Specification.new do |spec|
  spec.name          = "envalit"
  spec.version       = Envalit::VERSION
  spec.authors       = ["bugloper"]
  spec.email         = ["bugloper@gmail.com"]

  spec.summary       = "A simple Ruby gem for validating environment variables"
  spec.description   = "Envalit provides a straightforward way to ensure all required environment variables are present, with options to warn or crash when they're missing."
  spec.homepage      = "https://github.com/bugloper/envalit"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bugloper/envalit"
  spec.metadata["changelog_uri"] = "https://github.com/bugloper/envalit/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "dotenv", "~> 3.1"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rubocop", "~> 1.60"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"
  spec.add_development_dependency "rubocop-rspec", "~> 2.26"
  spec.add_development_dependency "yard", "~> 0.9"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
