# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "landingman-deploy"
  s.version     = "0.0.2"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Snider"]
  s.email       = ["matt@cleanenergyexperts.com"]
  s.homepage    = "https://www.cleanenergyexperts.com"
  s.summary     = %q{Deploys a middleman site to S3 by setting defaults on the s3_sync extension}
  # s.description = %q{A longer description of your extension}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  # The version of middleman-core your extension depends on
  s.add_runtime_dependency("middleman-core", [">= 4.1.1"])
  
  # Additional dependencies
  s.add_runtime_dependency("middleman-s3_sync", ['~> 4.0', '>= 4.0.2'])
  s.add_runtime_dependency("mime-types", ['~> 3.0'])
end
