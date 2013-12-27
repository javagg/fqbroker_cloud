# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "openshift-origin-admin-console"
  s.version = "1.17.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jessica Forrester", "Luke Meyer", "Steve Goodwin"]
  s.date = "2013-12-27"
  s.description = "The OpenShift Origin admin console is a Rails engine that provides an easy-to-use interface for administering OpenShift Origin."
  s.email = ["jforrest@redhat.com", "lmeyer@redhat.com", "sgoodwin@redhat.com"]
  s.files = ["app/helpers/admin_console/application_helper.rb", "app/helpers/admin_console/layout_helper.rb", "app/helpers/admin_console/capacity_planning_helper.rb", "app/helpers/admin_console/statistic_generator.rb", "app/helpers/admin_console/suggestion_helper.rb", "app/helpers/admin_console/html5_boilerplate_helper.rb", "app/controllers/admin_console/applications_controller.rb", "app/controllers/admin_console/gears_controller.rb", "app/controllers/admin_console/stats_controller.rb", "app/controllers/admin_console/rescue.rb", "app/controllers/admin_console/suggestions_controller.rb", "app/controllers/admin_console/nodes_controller.rb", "app/controllers/admin_console/profiles_controller.rb", "app/controllers/admin_console/application_controller.rb", "app/controllers/admin_console/users_controller.rb", "app/controllers/admin_console/search_controller.rb", "app/controllers/admin_console/index_controller.rb", "app/assets/images/admin_console/icon-warning-sign.png", "app/assets/images/admin_console/web-stack-lg.svg", "app/assets/images/admin_console/origin-admin-console-title.png", "app/assets/images/admin_console/loader-dark.gif", "app/assets/images/admin_console/stars-trees-silhoutte.png", "app/assets/images/admin_console/openshift-logo-horizontal.svg", "app/assets/images/admin_console/gear-group.svg", "app/assets/images/admin_console/favicon-32.png", "app/assets/images/admin_console/user.svg", "app/assets/images/admin_console/gear-lg.svg", "app/assets/stylesheets/admin_console/_rcue.scss", "app/assets/stylesheets/admin_console/_navbar.scss", "app/assets/stylesheets/admin_console/_tooltip.scss", "app/assets/stylesheets/admin_console/_responsive-utilities.scss", "app/assets/stylesheets/admin_console/_sprites.scss", "app/assets/stylesheets/admin_console/_variables.scss", "app/assets/stylesheets/admin_console/_graph.scss", "app/assets/stylesheets/admin_console/_type.scss", "app/assets/stylesheets/admin_console/_core.scss", "app/assets/stylesheets/admin_console/_forms.scss", "app/assets/stylesheets/admin_console/_capacity.scss", "app/assets/stylesheets/admin_console/_labels-badges.scss", "app/assets/stylesheets/admin_console/_tile.scss", "app/assets/stylesheets/admin_console/_buttons.scss", "app/assets/stylesheets/admin_console/_hero-unit.scss", "app/assets/stylesheets/admin_console/_progress-bars.scss", "app/assets/stylesheets/admin_console.css.scss", "app/assets/javascripts/admin_console/graph_generator.js", "app/assets/javascripts/admin_console/util.js", "app/assets/javascripts/admin_console.js", "app/views/layouts/admin_console/_identity.html.haml", "app/views/layouts/admin_console/_javascripts.html.haml", "app/views/layouts/admin_console/_head.html.haml", "app/views/layouts/admin_console/_stylesheets.html.haml", "app/views/layouts/admin_console/_header.html.haml", "app/views/layouts/admin_console.html.haml", "app/views/admin_console/stats/index.html.haml", "app/views/admin_console/users/show.html.haml", "app/views/admin_console/applications/show.html.haml", "app/views/admin_console/nodes/show.html.haml", "app/views/admin_console/profiles/show.html.haml", "app/views/admin_console/application/error.html.haml", "app/views/admin_console/application/not_found.html.haml", "app/views/admin_console/suggestions/_error.html.haml", "app/views/admin_console/suggestions/index.html.haml", "app/views/admin_console/suggestions/capacity/_add.html.haml", "app/views/admin_console/suggestions/capacity/remove/_compact_district.html.haml", "app/views/admin_console/suggestions/capacity/remove/_node.html.haml", "app/views/admin_console/suggestions/_base.html.haml", "app/views/admin_console/suggestions/_missing_nodes.html.haml", "app/views/admin_console/suggestions/config/_fix_val.html.haml", "app/views/admin_console/suggestions/config/_fix_gear_down.html.haml", "app/views/admin_console/index/_suggestions.html.haml", "app/views/admin_console/index/index.html.haml", "app/views/admin_console/index/_welcome.html.haml", "app/views/admin_console/index/_profile.html.haml", "app/views/admin_console/gears/show.html.haml", "app/views/admin_console/search/index.html.haml", "app/models/admin_console/application_stats.rb", "app/models/admin_console/domain_stats.rb", "app/models/admin_console/bin.rb", "app/models/admin_console/stats.rb", "app/models/admin_console/cloud_user_stats.rb", "conf/openshift-origin-admin-console.conf", "config/initializers/openshift-origin-admin-console.rb", "config/routes.rb", "lib/admin_console/engine.rb", "lib/admin_console/version.rb", "lib/tasks/admin_console_tasks.rake", "lib/openshift-origin-admin-console.rb", "LICENSE", "Rakefile", "README.md", "test/admin_console_test.rb", "test/test_helper.rb", "test/dummy/script/rails", "test/dummy/app/helpers/application_helper.rb", "test/dummy/app/controllers/application_controller.rb", "test/dummy/app/assets/stylesheets/application.css", "test/dummy/app/assets/javascripts/application.js", "test/dummy/app/views/layouts/application.html.erb", "test/dummy/README.rdoc", "test/dummy/config.ru", "test/dummy/public/404.html", "test/dummy/public/500.html", "test/dummy/public/422.html", "test/dummy/public/favicon.ico", "test/dummy/config/database.yml", "test/dummy/config/environment.rb", "test/dummy/config/environments/test.rb", "test/dummy/config/environments/production.rb", "test/dummy/config/environments/development.rb", "test/dummy/config/initializers/session_store.rb", "test/dummy/config/initializers/wrap_parameters.rb", "test/dummy/config/initializers/inflections.rb", "test/dummy/config/initializers/secret_token.rb", "test/dummy/config/initializers/backtrace_silencers.rb", "test/dummy/config/initializers/mime_types.rb", "test/dummy/config/application.rb", "test/dummy/config/locales/en.yml", "test/dummy/config/boot.rb", "test/dummy/config/routes.rb", "test/dummy/Rakefile", "test/fixtures/admin_console/district_with_node_and_undistricted_node.json", "test/fixtures/admin_console/overactive_node.json", "test/fixtures/admin_console/no_profiles.json", "test/fixtures/admin_console/empty_district_and_node.json", "test/fixtures/admin_console/empty_node_only.json", "test/support/base.rb", "test/support/capybara.rb", "test/support/errors.rb", "test/integration/admin_console/web_flows_test.rb", "test/unit/helpers/admin_console/home_helper_test.rb", "test/functional/admin_console/profiles_controller_test.rb", "test/functional/admin_console/users_controller_test.rb", "test/functional/admin_console/suggestions_controller_test.rb", "test/functional/admin_console/index_controller_test.rb", "test/functional/admin_console/gears_controller_test.rb", "test/functional/admin_console/applications_controller_test.rb"]
  s.homepage = "https://github.com/openshift/origin-server/tree/master/admin-console"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "OpenShift Origin Admin Console"
  s.test_files = ["test/admin_console_test.rb", "test/test_helper.rb", "test/dummy/script/rails", "test/dummy/app/helpers/application_helper.rb", "test/dummy/app/controllers/application_controller.rb", "test/dummy/app/assets/stylesheets/application.css", "test/dummy/app/assets/javascripts/application.js", "test/dummy/app/views/layouts/application.html.erb", "test/dummy/README.rdoc", "test/dummy/config.ru", "test/dummy/public/404.html", "test/dummy/public/500.html", "test/dummy/public/422.html", "test/dummy/public/favicon.ico", "test/dummy/config/database.yml", "test/dummy/config/environment.rb", "test/dummy/config/environments/test.rb", "test/dummy/config/environments/production.rb", "test/dummy/config/environments/development.rb", "test/dummy/config/initializers/session_store.rb", "test/dummy/config/initializers/wrap_parameters.rb", "test/dummy/config/initializers/inflections.rb", "test/dummy/config/initializers/secret_token.rb", "test/dummy/config/initializers/backtrace_silencers.rb", "test/dummy/config/initializers/mime_types.rb", "test/dummy/config/application.rb", "test/dummy/config/locales/en.yml", "test/dummy/config/boot.rb", "test/dummy/config/routes.rb", "test/dummy/Rakefile", "test/fixtures/admin_console/district_with_node_and_undistricted_node.json", "test/fixtures/admin_console/overactive_node.json", "test/fixtures/admin_console/no_profiles.json", "test/fixtures/admin_console/empty_district_and_node.json", "test/fixtures/admin_console/empty_node_only.json", "test/support/base.rb", "test/support/capybara.rb", "test/support/errors.rb", "test/integration/admin_console/web_flows_test.rb", "test/unit/helpers/admin_console/home_helper_test.rb", "test/functional/admin_console/profiles_controller_test.rb", "test/functional/admin_console/users_controller_test.rb", "test/functional/admin_console/suggestions_controller_test.rb", "test/functional/admin_console/index_controller_test.rb", "test/functional/admin_console/gears_controller_test.rb", "test/functional/admin_console/applications_controller_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.2.8"])
      s.add_runtime_dependency(%q<formtastic>, ["~> 1.2.3"])
      s.add_runtime_dependency(%q<jquery-rails>, ["~> 2.0.2"])
      s.add_runtime_dependency(%q<compass-rails>, ["~> 1.0.3"])
      s.add_runtime_dependency(%q<coffee-rails>, ["~> 3.2.2"])
      s.add_runtime_dependency(%q<sass-rails>, ["~> 3.2.5"])
      s.add_runtime_dependency(%q<haml>, ["< 4.1", ">= 3.1.7"])
      s.add_runtime_dependency(%q<uglifier>, [">= 1.2.6"])
      s.add_runtime_dependency(%q<net-http-persistent>, [">= 2.7"])
      s.add_runtime_dependency(%q<sass-twitter-bootstrap>, ["~> 2.0.1"])
      s.add_runtime_dependency(%q<openshift-origin-common>, [">= 0"])
      s.add_runtime_dependency(%q<openshift-origin-controller>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["~> 3.2.8"])
      s.add_dependency(%q<formtastic>, ["~> 1.2.3"])
      s.add_dependency(%q<jquery-rails>, ["~> 2.0.2"])
      s.add_dependency(%q<compass-rails>, ["~> 1.0.3"])
      s.add_dependency(%q<coffee-rails>, ["~> 3.2.2"])
      s.add_dependency(%q<sass-rails>, ["~> 3.2.5"])
      s.add_dependency(%q<haml>, ["< 4.1", ">= 3.1.7"])
      s.add_dependency(%q<uglifier>, [">= 1.2.6"])
      s.add_dependency(%q<net-http-persistent>, [">= 2.7"])
      s.add_dependency(%q<sass-twitter-bootstrap>, ["~> 2.0.1"])
      s.add_dependency(%q<openshift-origin-common>, [">= 0"])
      s.add_dependency(%q<openshift-origin-controller>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.2.8"])
    s.add_dependency(%q<formtastic>, ["~> 1.2.3"])
    s.add_dependency(%q<jquery-rails>, ["~> 2.0.2"])
    s.add_dependency(%q<compass-rails>, ["~> 1.0.3"])
    s.add_dependency(%q<coffee-rails>, ["~> 3.2.2"])
    s.add_dependency(%q<sass-rails>, ["~> 3.2.5"])
    s.add_dependency(%q<haml>, ["< 4.1", ">= 3.1.7"])
    s.add_dependency(%q<uglifier>, [">= 1.2.6"])
    s.add_dependency(%q<net-http-persistent>, [">= 2.7"])
    s.add_dependency(%q<sass-twitter-bootstrap>, ["~> 2.0.1"])
    s.add_dependency(%q<openshift-origin-common>, [">= 0"])
    s.add_dependency(%q<openshift-origin-controller>, [">= 0"])
  end
end

