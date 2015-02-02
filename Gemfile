source 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 3.7.0'
  gem 'puppet-lint'
  gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem 'puppet-syntax'
  gem 'puppetlabs_spec_helper'
end

group :development do
  gem 'minitest', '~>4.0'
  gem 'minitest-reporters'
  gem 'beaker', '~> 1.20.1'
  gem 'beaker-rspec'
  gem 'vagrant-wrapper'
end
