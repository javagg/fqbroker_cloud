# -*- encoding: utf-8 -*-
config_dir  = File.join(File.join("config", "**"), "*")
app_dir  = File.join(File.join("app", "**"), "*")
$:.push File.expand_path("../lib", __FILE__)
lib_dir  = File.join(File.join("lib", "**"), "*")
test_dir  = File.join(File.join("test", "**"), "*")
bin_dir  = File.join("bin","*")
conf_dir  = File.join(File.join("conf", "**"), "*")
spec_file = "rubygem-openshift-freequant-account-mongo.spec"

Gem::Specification.new do |s|
  s.name        = "openshift-freequant-account-mongo"
  s.version     = `rpm -q --define 'rhel 7' --qf "%{version}\n" --specfile #{spec_file}`.split[0]
  s.license     = `rpm -q --define 'rhel 7' --qf "%{license}\n" --specfile #{spec_file}`.split[0]
  s.authors     = ["Krishna Raman"]
  s.email       = ["kraman@gmail.com"]
  s.homepage    = `rpm -q --define 'rhel 7' --qf "%{url}\n" --specfile #{spec_file}`.split[0]
  s.summary     = `rpm -q --define 'rhel 7' --qf "%{description}\n" --specfile #{spec_file}`.split[0]
  s.description = `rpm -q --define 'rhel 7' --qf "%{description}\n" --specfile #{spec_file}`.split[0]

  s.rubyforge_project = "openshift-freequant-account-mongo"

  s.files       = Dir[lib_dir] + Dir[bin_dir] + Dir[conf_dir] + Dir[config_dir] + Dir[app_dir]
  s.test_files  = Dir[test_dir]
  s.executables = Dir[bin_dir].map {|binary| File.basename(binary)}
  s.files       += %w(Gemfile rubygem-openshift-freequant-account-mongo.spec openshift-freequant-account-mongo.gemspec)
  s.require_paths = ["lib"]

  s.add_dependency('openshift-origin-controller')
  s.add_dependency('psych')
  s.add_dependency('parseconfig')
  s.add_development_dependency('rake')
  s.add_development_dependency('mocha')
end