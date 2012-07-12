require "cucumber/rake/task"
require "rspec/core/rake_task"

$:.unshift File.expand_path('lib', __FILE__)

Cucumber::Rake::Task.new(:cucumber) do |task|
end

namespace :cucumber do
  Cucumber::Rake::Task.new(:wip) do |task|
    task.cucumber_opts = %w{--tags @wip}
  end
end

RSpec::Core::RakeTask.new do |t|
end