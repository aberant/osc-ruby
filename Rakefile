require "rake/testtask"

Rake::TestTask.new(:spec) do |t| 
  t.libs << "spec"
  t.pattern = "spec/**/*_spec.rb"
  t.ruby_opts = ['--enable=frozen-string-literal']
end

task :default => :spec

require 'rdoc/task'
RDoc::Task.new do |rdoc|
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
