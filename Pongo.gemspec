# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{Pongo}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["ANDO Yasushi"]
  s.date = %q{2009-08-07}
  s.description = %q{Ruby version of APE (Actionscript Physics Engine)}
  s.email = %q{andyjpn@gmail.com}
  s.extra_rdoc_files = ["LICENSE"]
  s.files = ['History.txt', 'lib/pongo/abstract_collection.rb', 'lib/pongo/abstract_constraint.rb', 'lib/pongo/abstract_item.rb', 'lib/pongo/abstract_particle.rb', 'lib/pongo/angular_constraint.rb', 'lib/pongo/apengine.rb', 'lib/pongo/circle_particle.rb', 'lib/pongo/collision.rb', 'lib/pongo/collision_detector.rb', 'lib/pongo/collision_event.rb', 'lib/pongo/collision_resolver.rb', 'lib/pongo/composite.rb', 'lib/pongo/container', 'lib/pongo/container/container.rb', 'lib/pongo/container/shoes_container.rb', 'lib/pongo/group.rb', 'lib/pongo/iforce.rb', 'lib/pongo/logger/logger.rb', 'lib/pongo/logger/shoes_logger.rb', 'lib/pongo/logger/standard_logger.rb', 'lib/pongo/rectangle_particle.rb', 'lib/pongo/renderer/renderer.rb', 'lib/pongo/renderer/shoes_renderer.rb', 'lib/pongo/renderer/tk_renderer.rb', 'lib/pongo/rim_particle.rb', 'lib/pongo/spring_constraint.rb', 'lib/pongo/spring_constraint_particle.rb', 'lib/pongo/util/interval.rb', 'lib/pongo/util/math_util.rb', 'lib/pongo/util/numeric_ext.rb', 'lib/pongo/util/vector.rb', 'lib/pongo/vector_force.rb', 'lib/pongo/wheel_particle.rb', 'lib/pongo.rb', 'Manifest.txt', 'README.txt']
  #s.has_rdoc = true
  s.homepage = %q{http://github.com/technohippy/Pongo}
  #s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{pongo}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Pure Ruby Phyisics Engine.}
end

