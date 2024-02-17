# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "redwood"
  spec.version = "0.1.0"
  spec.summary = "a ruby wrapper for the cedar policy language"

  spec.authors = ["Matthew Healy"]
  spec.email = ["no@example.com"]

  spec.files = Dir["lib/**/*.rb"].concat(Dir["ext/redwood/src/**/*.rs"]) << 
    "ext/redwood/Cargo.toml" << 
    "Cargo.toml" << 
    "Cargo.lock" << 
    "README.md"
  spec.extensions = ["ext/redwood/Cargo.toml"]

  spec.requirements = ["Rust >= 1.75"]
  spec.required_ruby_version = ">= 3.0.0"
  spec.required_rubygems_version = ">= 3.3.26"

  spec.add_development_dependency "rake-compiler", "~> 1.2"
  spec.add_development_dependency "rb_sys", "~> 0.9"
  spec.add_development_dependency "test-unit", "~> 3.5"
end
