require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

# Paths excluded from Syntax and Linting checks
exclude_paths = [
    'pkg/**/*',
    'vendor/**/*.pp',
    'spec/**/*.pp',
]

# Temporary fix for bug https://github.com/rodjek/puppet-lint/issues/331
Rake::Task[:lint].clear

# Define the Linting task
PuppetLint::RakeTask.new :lint do |config|
  config.pattern = '**/*.pp'
  config.ignore_paths = exclude_paths
  config.disable_checks = ['documentation', '80chars', 'autoloader_layout']
  config.with_filename = false
  config.fail_on_warnings = false
  config.log_format = '%{path}:%{line}:%{check}:%{KIND}:%{message}'
  config.with_context = false
end

# Exclude unwanted paths from the Syntax check
PuppetSyntax.exclude_paths = exclude_paths

desc 'Run acceptance tests'
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = 'spec/acceptance'
end

desc 'Run syntax, lint, and spec tests.'
task :test => [
    :syntax,
    :lint,
    :spec,
]
