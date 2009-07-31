$: << File.expand_path(File.dirname(__FILE__))

require 'pongo/abstract_collection'
require 'pongo/abstract_constraint'
require 'pongo/abstract_item'
require 'pongo/abstract_particle'
require 'pongo/angular_constraint'
require 'pongo/apengine'
require 'pongo/circle_particle'
require 'pongo/collision'
require 'pongo/collision_detector'
require 'pongo/collision_event'
require 'pongo/collision_resolver'
require 'pongo/composite'
require 'pongo/group'
require 'pongo/iforce'
require 'pongo/rectangle_particle'
require 'pongo/rim_particle'
require 'pongo/spring_constraint'
require 'pongo/spring_constraint_particle'
require 'pongo/vector_force'
require 'pongo/wheel_particle'

require 'pongo/util/interval'
require 'pongo/util/math_util'
require 'pongo/util/numeric_ext'
require 'pongo/util/vector'

module Pongo
  VERSION = '0.1.0'
  class SubclassResponsibilityError < StandardError; end
  class UnknownItemError < StandardError; end
end
