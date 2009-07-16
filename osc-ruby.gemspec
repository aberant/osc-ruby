# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{osc-ruby}
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["aberant"]
  s.date = %q{2009-07-16}
  s.email = %q{qzzzq1@gmail.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["VERSION.yml", "lib/osc-ruby", "lib/osc-ruby/bundle.rb", "lib/osc-ruby/message.rb", "lib/osc-ruby/osc_argument.rb", "lib/osc-ruby/osc_types.rb", "lib/osc-ruby/packet.rb", "lib/osc-ruby/simple_client.rb", "lib/osc-ruby/simple_server.rb", "lib/osc-ruby.rb", "spec/integration", "spec/integration/send_receive_spec.rb", "spec/spec_helper.rb", "spec/unit", "spec/unit/osc_argument_spec.rb", "spec/unit/osc_types_spec.rb", "spec/unit/simple_client_spec.rb", "README"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/aberant/osc-ruby}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{inital gem}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
