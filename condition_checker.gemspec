require_relative "lib/condition_checker/version"

Gem::Specification.new do |spec|
  spec.name = "condition_checker"
  spec.version = ConditionChecker::VERSION
  spec.authors = ["Jared Fraser"]
  spec.email = ["dev@jsf.io"]

  spec.summary = "A gem for checking conditions for things like healthchecks and complicated statuses"
  spec.description = "condition_checker provides a way to define and check conditions on objects"
  spec.homepage = "https://github.com/yourusername/condition_checker"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
