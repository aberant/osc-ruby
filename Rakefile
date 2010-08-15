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

require 'rake/packagetask'
require 'rake/gempackagetask'

### Task: gem
gemspec = Gem::Specification.new do |gem|
  gem.name = "osc-ruby"
  gem.version   = File.read('VERSION')

  gem.summary = "a ruby client for the OSC protocol"
  gem.description = "This OSC gem originally created by Tadayoshi Funaba has been updated for ruby 1.9/JRuby compatibility"

  gem.authors = "Colin Harris"
  gem.email = "qzzzq1@gmail.com"
  gem.homepage = "http://github.com/aberant/osc-ruby"

  gem.has_rdoc = true

  gem.files = FileList['Rakefile', 'VERSION', 'LICENSE', 'examples/**/*', 'lib/**/*'].to_a
  gem.test_files = FileList['spec/**/*.rb']
end

Rake::GemPackageTask.new( gemspec ) do |task|
  task.gem_spec = gemspec
  task.need_tar = false
  task.need_tar_gz = true
  task.need_tar_bz2 = true
  task.need_zip = true
end