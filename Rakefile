require 'spec/rake/spectask'


task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.warning = false
  t.rcov = false
  t.spec_opts = ["--colour"]
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "osc-ruby"
    gem.summary = %Q{inital gem}
    gem.email = "qzzzq1@gmail.com"
    gem.homepage = "http://github.com/aberant/osc-ruby"
    gem.authors = ["aberant"]
    gem.files = FileList['Rakefile', 'examples/**/*', 'lib/**/*'].to_a
    gem.test_files = FileList['spec/**/*.rb']
    gem.rubyforge_project = "osc-ruby"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end