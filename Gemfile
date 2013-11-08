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

gem 'openshift-origin-common'
gem 'openshift-origin-controller'
gem 'openshift-origin-msg-broker-mcollective'
#gem 'openshift-origin-admin-console'
gem 'openshift-origin-dns-nsupdate'

gem 'netrc' # rest-client has an undeclared prereq on netrc

# Note: It should be the first in order to override some of its' stuff
gem 'openshift-origin-auth-mongo'
if ENV['BROKER_PLUGINS_SOURCE']
  gem 'openshift-freequant-account-mongo', path: File.join(ENV['BROKER_PLUGINS_SOURCE'], 'account', 'mongo')
else
  gem 'openshift-freequant-account-mongo'
end

gem 'thin'

group :development, :test do
  # The require part from http://tinyurl.com/3pf68ho
  gem 'mocha', '~> 0.13.1', :require => false
  gem 'rake', '>= 0.8.7'
  gem 'simplecov'
  gem 'cucumber'
  gem 'minitest'
  gem 'capybara', '~> 2.1.0', :require => false
  gem 'poltergeist', '~> 1.2.0', :require => false
end

gem 'rest-client', '>= 1.6.1', '<= 1.6.7', :require => 'rest-client'
