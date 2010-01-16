require 'spec/rake/spectask'

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.libs << 'lib'
  t.warning = false
  t.rcov = false
  t.spec_opts = ["--colour"]
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "osc-ruby #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end


begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "osc-ruby"
    gem.description = "a ruby client for the OSC protocol"
    gem.summary = %Q{inital gem}
    gem.email = "qzzzq1@gmail.com"
    gem.homepage = "http://github.com/aberant/osc-ruby"
    gem.authors = ["aberant"]
    gem.files = FileList['Rakefile', 'examples/**/*', 'lib/**/*'].to_a
    gem.test_files = FileList['spec/**/*.rb']
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

  Jeweler::GemcutterTasks.new

rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end