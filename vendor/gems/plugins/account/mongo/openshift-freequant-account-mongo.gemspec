# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "openshift-freequant-account-mongo"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Krishna Raman"]
  s.date = "2013-12-30"
  s.description = "Provides"
  s.email = ["kraman@gmail.com"]
  s.files = ["lib/openshift-freequant-account-mongo.rb", "conf/openshift-freequant-account-mongo.conf.example", "config/initializers/openshift-freequant-account-mongo.rb", "config/routes.rb", "app/controllers/accounts_controller.rb", "app/controllers/authentications_controller.rb", "app/controllers/account_controller.rb", "app/models/fq_account.rb", "app/models/rest_authentication.rb", "app/models/rest_account.rb", "app/models/authentication.rb", "app/models/user_account.rb", "app/models/rest_fq_account.rb", "Gemfile", "rubygem-openshift-freequant-account-mongo.spec", "openshift-freequant-account-mongo.gemspec"]
  s.homepage = "http://www.openshift.com"
  s.licenses = ["ASL"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "openshift-freequant-account-mongo"
  s.rubygems_version = "2.0.14"
  s.summary = "Provides"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<openshift-origin-controller>, [">= 0"])
      s.add_runtime_dependency(%q<psych>, [">= 0"])
      s.add_runtime_dependency(%q<parseconfig>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<openshift-origin-controller>, [">= 0"])
      s.add_dependency(%q<psych>, [">= 0"])
      s.add_dependency(%q<parseconfig>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<openshift-origin-controller>, [">= 0"])
    s.add_dependency(%q<psych>, [">= 0"])
    s.add_dependency(%q<parseconfig>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end

