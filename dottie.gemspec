require_relative "./lib/dottie.rb"

Gem::Specification.new do |s|
  s.name = "dottie"
  s.version = Dottie::VERSION
  s.license = "AGPL-3.0-or-later"
  s.summary = "A test runner for PHPT-like tests"
  s.authors = ["Joe Haines"]
  s.files = Dir["lib/**/*.rb"]
  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/imjoehaines/dottie/issues",
    "source_code_uri"   => "https://github.com/imjoehaines/dottie",
  }
end
