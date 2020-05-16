# -*- encoding: utf-8 -*-
# stub: foundation-rails 6.6.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "foundation-rails".freeze
  s.version = "6.6.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Yetinauts".freeze]
  s.date = "2020-03-30"
  s.description = "Foundation on Sass/Compass".freeze
  s.email = ["contact@get.foundation".freeze]
  s.homepage = "https://get.foundation".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.6".freeze
  s.summary = "Foundation on Sass/Compass".freeze

  s.installed_by_version = "2.7.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sass>.freeze, [">= 3.3.0"])
      s.add_runtime_dependency(%q<railties>.freeze, [">= 3.1.0"])
      s.add_runtime_dependency(%q<sprockets-es6>.freeze, [">= 0.9.0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_development_dependency(%q<capybara>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.2"])
      s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
      s.add_development_dependency(%q<bootsnap>.freeze, [">= 0"])
      s.add_development_dependency(%q<listen>.freeze, [">= 0"])
    else
      s.add_dependency(%q<sass>.freeze, [">= 3.3.0"])
      s.add_dependency(%q<railties>.freeze, [">= 3.1.0"])
      s.add_dependency(%q<sprockets-es6>.freeze, [">= 0.9.0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_dependency(%q<capybara>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.2"])
      s.add_dependency(%q<appraisal>.freeze, [">= 0"])
      s.add_dependency(%q<bootsnap>.freeze, [">= 0"])
      s.add_dependency(%q<listen>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<sass>.freeze, [">= 3.3.0"])
    s.add_dependency(%q<railties>.freeze, [">= 3.1.0"])
    s.add_dependency(%q<sprockets-es6>.freeze, [">= 0.9.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
    s.add_dependency(%q<capybara>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.2"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
    s.add_dependency(%q<bootsnap>.freeze, [">= 0"])
    s.add_dependency(%q<listen>.freeze, [">= 0"])
  end
end
