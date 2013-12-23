# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "openshift-origin-msg-broker-mcollective"
  s.version = "1.19.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Krishna Raman"]
  s.date = "2013-12-23"
  s.description = "OpenShift"
  s.email = ["kraman@gmail.com"]
  s.files = ["lib/openshift-origin-msg-broker-mcollective.rb", "lib/mcollective_msg_broker_engine.rb", "lib/openshift/mcollective_application_container_proxy.rb", "conf/openshift-origin-msg-broker-mcollective.conf.example", "config/initializers/openshift-origin-msg-broker-mcollective.rb", "README.md", "Rakefile", "Gemfile", "rubygem-openshift-origin-msg-broker-mcollective.spec", "openshift-origin-msg-broker-mcollective.gemspec", "LICENSE", "COPYRIGHT"]
  s.homepage = "http://www.openshift.com"
  s.licenses = ["ASL"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "msg-broker-mcollective-plugin"
  s.rubygems_version = "2.0.14"
  s.summary = "OpenShift"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<openshift-origin-controller>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<systemu>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_runtime_dependency(%q<stomp>, [">= 0"])
    else
      s.add_dependency(%q<openshift-origin-controller>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<systemu>, [">= 0"])
      s.add_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<stomp>, [">= 0"])
    end
  else
    s.add_dependency(%q<openshift-origin-controller>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<systemu>, [">= 0"])
    s.add_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<stomp>, [">= 0"])
  end
end

