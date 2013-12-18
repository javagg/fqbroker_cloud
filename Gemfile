source 'http://rubygems.org'

gem 'rails', '~> 3.2.8'
gem 'json'
gem 'json_pure'
gem 'parseconfig', '~> 1.0.2'
gem 'xml-simple'
gem 'rack'
gem 'regin'
gem 'open4'
gem 'systemu'
gem 'mongoid'
gem 'bson'
gem 'bson_ext'
gem 'pry', :require => 'pry' if ENV['PRY']
# Fedora 19 splits psych out into its own gem.
if Gem::Specification.respond_to?(:find_all_by_name) and not Gem::Specification::find_all_by_name('psych').empty?
  gem 'psych'
end

# For performance reasons, the following scripts will not be
# refactored to use mongoid exclusively:
#  * broker-util/oo-admin-chk
#  * broker-util/oo-admin-fix-sshkeys
#  * broker-util/oo-stats
# These scripts use the OpenShift::DataStore API, and thus depend on
# the mongo rubygem:
gem 'mongo'
gem 'mcollective-client', '2.2.3'
gem 'bunny'

gem 'openshift-origin-common', path: 'vendor/gems/common'
gem 'openshift-origin-controller', path: 'vendor/gems/controller'
gem 'openshift-origin-msg-broker-mcollective', path: 'vendor/gems/plugins/msg-broker'
gem 'openshift-origin-admin-console', path: 'vendor/gems/admin-console'

#gem 'openshift-origin-dns-nsupdate', path: 'vendor/gems/plugins/dns/nsupdate'
gem 'openshift-origin-dns-dnspod', path: 'vendor/gems/plugins/dns/dnspod'

gem 'netrc' # rest-client has an undeclared prereq on netrc

gem 'openshift-origin-auth-mongo', path: 'vendor/gems/plugins/auth/mongo'

if ENV["FQ_SERVER_SRC"]
  gem 'openshift-freequant-account-mongo', path: File.join(ENV['FQ_SERVER_SRC'], 'plugins', 'account', 'mongo')
  gem 'openshift-origin-dns-dnspod', path: File.join(ENV['FQ_SERVER_SRC'], 'plugins', 'dns', 'dnspod')
else
  gem 'openshift-freequant-account-mongo', path: 'vendor/gems/plugins/account/mongo'
  gem 'openshift-origin-dns-dnspod', path: 'vendor/gems/plugins/dns/dnspod'
end

group :development, :test do
  # The require part from http://tinyurl.com/3pf68ho
  gem 'mocha', '~> 0.13.1', :require => false
  gem 'rake', '>= 0.8.7'
  gem 'simplecov'
  gem 'cucumber'
  gem 'minitest'
  #gem 'capybara', '~> 2.1.0', :require => false
  #gem 'poltergeist', '~> 1.2.0', :require => false
end

gem 'rest-client', '>= 1.6.1', '<= 1.6.7', :require => 'rest-client'

ruby '2.0.0'
