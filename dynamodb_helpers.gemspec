
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dynamodb_helpers/version"

Gem::Specification.new do |spec|
  spec.name          = "dynamodb_helpers"
  spec.version       = DynamodbHelpers::VERSION
  spec.authors       = ["Damir Roso"]
  spec.email         = ["damir.roso@nih.gov"]

  spec.summary       = %q{Utility methods for dynamodb}
  spec.description   = %q{Lightweight wrapper for some aws-sdk-dynamodb features}
  spec.homepage      = "https://github.com/damir/dynamodb_helpers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  # spec.add_dependency "aws-sdk-dynamodb", ">= 1.2.0"
  # spec.add_dependency "aws-sdk", "~> 2.0"
end
