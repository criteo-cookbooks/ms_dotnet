# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:rspec)

task default: %i(rubocop rspec)
