# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc "Run the test suite and code style checks"
task default: %i[spec rubocop]

desc "Prepare for release"
task :prepare_release do
  puts "\n== Checking git status =="
  status = `git status --porcelain`
  if status.empty?
    puts "Working directory is clean"
  else
    abort "Error: There are uncommitted changes. Please commit or stash them first."
  end

  puts "\n== Running tests =="
  Rake::Task["spec"].invoke

  puts "\n== Running RuboCop =="
  Rake::Task["rubocop"].invoke

  puts "\n== Checking version =="
  version = Envalit::VERSION
  puts "Current version: #{version}"

  puts "\n== Checking CHANGELOG.md =="
  changelog = File.read("CHANGELOG.md")
  abort "Error: Version #{version} not found in CHANGELOG.md" unless changelog.include?(version)
  puts "CHANGELOG.md contains version #{version}"

  puts "\nAll checks passed! You can now run 'rake release'"
end

# Override the release task to run checks first
Rake::Task["release"].enhance(["prepare_release"])
