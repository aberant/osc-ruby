Gem::Specification.new do |gem|
  gem.name = "osc-ruby"
  gem.version   = File.read('VERSION')

  gem.summary = "a ruby client for the OSC protocol"
  gem.description = "This OSC gem originally created by Tadayoshi Funaba has been updated for ruby 1.9/JRuby compatibility"

  gem.authors = "Colin Harris"
  gem.email = "qzzzq1@gmail.com"
  gem.homepage = "http://github.com/aberant/osc-ruby"

  gem.has_rdoc = true

  gem.files = Dir['Rakefile', 'VERSION', 'LICENSE', 'examples/**/*', 'lib/**/*']
  gem.test_files = Dir['spec/**/*.rb']
end
