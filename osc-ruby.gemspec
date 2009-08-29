# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{osc-ruby}
  s.version = "0.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["aberant"]
  s.date = %q{2009-08-29}
  s.email = %q{qzzzq1@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "VERSION.yml", "lib/osc-ruby", "lib/osc-ruby/address_pattern.rb", "lib/osc-ruby/bundle.rb", "lib/osc-ruby/client.rb", "lib/osc-ruby/core_ext", "lib/osc-ruby/core_ext/numeric.rb", "lib/osc-ruby/core_ext/object.rb", "lib/osc-ruby/core_ext/time.rb", "lib/osc-ruby/message.rb", "lib/osc-ruby/network_packet.rb", "lib/osc-ruby/osc_argument.rb", "lib/osc-ruby/osc_packet.rb", "lib/osc-ruby/osc_types.rb", "lib/osc-ruby/packet.rb", "lib/osc-ruby/server.rb", "lib/osc-ruby.rb", "spec/builders", "spec/builders/message_builder.rb", "spec/integration", "spec/spec_helper.rb", "spec/unit", "spec/unit/address_pattern_spec.rb", "spec/unit/message_bundle_spec.rb", "spec/unit/message_spec.rb", "spec/unit/network_packet_spec.rb", "spec/unit/osc_argument_spec.rb", "spec/unit/osc_complex_packets_spec.rb", "spec/unit/osc_simple_packets_spec.rb", "spec/unit/osc_types_spec.rb"]
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
