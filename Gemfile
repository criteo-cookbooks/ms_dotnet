# frozen_string_literal: true

source 'https://rubygems.org'

gem 'berkshelf'

group :unit_test do
  gem 'chef', '= 14.7.17'
  gem 'chefspec', '>= 7.4.0'
  gem 'fauxhai-ng'
  gem 'rspec'
end

group :integration do
  gem 'kitchen-ec2', '>= 2.9.0'
  gem 'kitchen-inspec', '>= 2.0.0'
  gem 'test-kitchen', '>= 2.5.0'
end

group :lint do
  gem 'rubocop', '= 0.80.1'
end
