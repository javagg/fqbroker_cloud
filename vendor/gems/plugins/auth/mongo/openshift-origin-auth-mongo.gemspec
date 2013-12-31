# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "openshift-origin-auth-mongo"
  s.version = "1.15.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Krishna Raman"]
  s.date = "2013-12-31"
  s.description = "Provides"
  s.email = ["kraman@gmail.com"]
  s.executables = ["oo-register-user"]
  s.files = ["lib/openshift-origin-auth-mongo.rb", "lib/mongo_auth_engine.rb", "lib/openshift/mongo_auth_service.rb", "bin/oo-register-user", "conf/openshift-origin-auth-mongo.conf.example", "config/initializers/openshift-origin-auth-mongo.rb", "config/routes.rb", "app/controllers/account_controller.rb", "app/models/rest_account.rb", "app/models/user_account.rb", "test/test_helper.rb", "test/dummy/script/rails", "test/dummy/db/seeds.rb", "test/dummy/test/test_helper.rb", "test/dummy/test/performance/browsing_test.rb", "test/dummy/app/helpers/application_helper.rb", "test/dummy/app/controllers/application_controller.rb", "test/dummy/app/views/layouts/application.html.erb", "test/dummy/README", "test/dummy/config.ru", "test/dummy/doc/README_FOR_APP", "test/dummy/public/404.html", "test/dummy/public/500.html", "test/dummy/public/images/rails.png", "test/dummy/public/422.html", "test/dummy/public/favicon.ico", "test/dummy/public/index.html", "test/dummy/public/robots.txt", "test/dummy/public/javascripts/controls.js", "test/dummy/public/javascripts/rails.js", "test/dummy/public/javascripts/effects.js", "test/dummy/public/javascripts/dragdrop.js", "test/dummy/public/javascripts/prototype.js", "test/dummy/public/javascripts/application.js", "test/dummy/config/database.yml", "test/dummy/config/environment.rb", "test/dummy/config/environments/test.rb", "test/dummy/config/initializers/session_store.rb", "test/dummy/config/initializers/inflections.rb", "test/dummy/config/initializers/secret_token.rb", "test/dummy/config/initializers/backtrace_silencers.rb", "test/dummy/config/initializers/mime_types.rb", "test/dummy/config/application.rb", "test/dummy/config/locales/en.yml", "test/dummy/config/boot.rb", "test/dummy/config/routes.rb", "test/dummy/Rakefile", "test/dummy/Gemfile", "test/functional/account_controller_test.rb", "README.md", "Rakefile", "Gemfile", "rubygem-openshift-origin-auth-mongo.spec", "openshift-origin-auth-mongo.gemspec", "LICENSE", "COPYRIGHT"]
  s.homepage = "http://www.openshift.com"
  s.licenses = ["ASL"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "openshift-origin-auth-mongo"
  s.rubygems_version = "2.0.14"
  s.summary = "Provides"
  s.test_files = ["test/test_helper.rb", "test/dummy/script/rails", "test/dummy/db/seeds.rb", "test/dummy/test/test_helper.rb", "test/dummy/test/performance/browsing_test.rb", "test/dummy/app/helpers/application_helper.rb", "test/dummy/app/controllers/application_controller.rb", "test/dummy/app/views/layouts/application.html.erb", "test/dummy/README", "test/dummy/config.ru", "test/dummy/doc/README_FOR_APP", "test/dummy/public/404.html", "test/dummy/public/500.html", "test/dummy/public/images/rails.png", "test/dummy/public/422.html", "test/dummy/public/favicon.ico", "test/dummy/public/index.html", "test/dummy/public/robots.txt", "test/dummy/public/javascripts/controls.js", "test/dummy/public/javascripts/rails.js", "test/dummy/public/javascripts/effects.js", "test/dummy/public/javascripts/dragdrop.js", "test/dummy/public/javascripts/prototype.js", "test/dummy/public/javascripts/application.js", "test/dummy/config/database.yml", "test/dummy/config/environment.rb", "test/dummy/config/environments/test.rb", "test/dummy/config/initializers/session_store.rb", "test/dummy/config/initializers/inflections.rb", "test/dummy/config/initializers/secret_token.rb", "test/dummy/config/initializers/backtrace_silencers.rb", "test/dummy/config/initializers/mime_types.rb", "test/dummy/config/application.rb", "test/dummy/config/locales/en.yml", "test/dummy/config/boot.rb", "test/dummy/config/routes.rb", "test/dummy/Rakefile", "test/dummy/Gemfile", "test/functional/account_controller_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<openshift-origin-controller>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<openshift-origin-controller>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<openshift-origin-controller>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rake>, ["<= 0.9.6", ">= 0.8.7"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end

