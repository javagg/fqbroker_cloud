# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "openshift-origin-common"
  s.version = "1.18.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Krishna Raman"]
  s.date = "2013-12-23"
  s.description = "This"
  s.email = ["kraman@gmail.com"]
  s.files = ["lib/openshift-origin-common.rb", "lib/openshift-origin-common/exceptions/oo_exception.rb", "lib/openshift-origin-common/config.rb", "lib/openshift-origin-common/models/model.rb", "lib/openshift-origin-common/models/profile.rb", "lib/openshift-origin-common/models/component.rb", "lib/openshift-origin-common/models/endpoint.rb", "lib/openshift-origin-common/models/manifest.rb", "lib/openshift-origin-common/models/connection.rb", "lib/openshift-origin-common/models/scaling.rb", "lib/openshift-origin-common/models/cartridge.rb", "lib/openshift-origin-common/models/connector.rb", "lib/openshift-origin-common/utils/file_needs_sync.rb", "lib/openshift-origin-common/utils/git.rb", "lib/openshift-origin-common/utils/path_utils.rb", "lib/openshift-origin-common/utils/etc_utils.rb", "test/test_helper.rb", "test/coverage_helper.rb", "test/unit/manifest_test.rb", "test/unit/etc_utils_test.rb", "README.md", "Rakefile", "Gemfile", "rubygem-openshift-origin-common.spec", "openshift-origin-common.gemspec", "LICENSE", "COPYRIGHT"]
  s.homepage = "http://www.openshift.com"
  s.licenses = ["ASL"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "openshift-origin-common"
  s.rubygems_version = "2.0.14"
  s.summary = "This"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<safe_yaml>, [">= 0"])
      s.add_runtime_dependency(%q<activemodel>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["= 1.1.12"])
      s.add_development_dependency(%q<mocha>, ["= 0.9.8"])
      s.add_development_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<safe_yaml>, [">= 0"])
      s.add_dependency(%q<activemodel>, [">= 0"])
      s.add_dependency(%q<rspec>, ["= 1.1.12"])
      s.add_dependency(%q<mocha>, ["= 0.9.8"])
      s.add_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<safe_yaml>, [">= 0"])
    s.add_dependency(%q<activemodel>, [">= 0"])
    s.add_dependency(%q<rspec>, ["= 1.1.12"])
    s.add_dependency(%q<mocha>, ["= 0.9.8"])
    s.add_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
  end
end

