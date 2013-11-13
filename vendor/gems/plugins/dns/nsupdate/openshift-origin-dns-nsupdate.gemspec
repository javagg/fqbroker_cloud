# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "openshift-origin-dns-nsupdate"
  s.version = "1.15.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Krishna Raman"]
  s.date = "2013-11-13"
  s.description = "Provides"
  s.email = ["kraman@gmail.com"]
  s.files = ["lib/openshift-origin-dns-nsupdate.rb", "lib/nsupdate_dns_engine.rb", "lib/openshift/nsupdate_plugin.rb", "conf/openshift-origin-dns-nsupdate.conf.example", "config/initializers/openshift-origin-dns-nsupdate.rb", "README.md", "Rakefile", "Gemfile", "rubygem-openshift-origin-dns-nsupdate.spec", "openshift-origin-dns-nsupdate.gemspec", "LICENSE", "COPYRIGHT"]
  s.homepage = "http://www.openshift.com"
  s.licenses = ["ASL"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "openshift-origin-dns-nsupdate"
  s.rubygems_version = "2.0.13"
  s.summary = "Provides"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<openshift-origin-controller>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<openshift-origin-controller>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<openshift-origin-controller>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end

