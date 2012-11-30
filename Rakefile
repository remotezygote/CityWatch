require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

desc "Run specs"
task :spec do
	RSpec::Core::RakeTask.new(:spec) do |t|
		t.pattern = './lib/spec/**/*_spec.rb'
	end
end