require 'pongo/abstract_item'

module Pongo
  class AbstractCollection < AbstractItem
    attr_accessor :sprite, :particles, :constraints, :is_parented

    def initialize
      super
      self.is_parented = false
      self.particles = []
      self.constraints = []
    end

    def <<(item)
      case item
      when AbstractParticle
        add_particle(item)
      when AbstractConstraint
        add_constraint(item)
      end
    end

    def add_particle(particle)
      particle.init if parented?
      particles << particle
    end

    def remove_particle(particle)
      if particles.delete(particle)
        particle.cleanup
      end
    end

    def add_constraint(constraint)
      constraint.init if parented?
      constraints << constraint
    end

    def remove_constraint(constraint)
      if constraints.delete(constraint)
        constraint.cleanup
      end
    end

    def init
      particles.each {|p| p.init}
      constraints.each {|c| c.init}
    end

    def draw
      if renderer
        renderer.draw(self)
      else
        particles.each {|p| p.draw if p.always_redraw? or not p.fixed?}
        constraints.each {|c| c.draw if c.always_redraw? or not c.fixed?}
      end
    end
    alias paint draw

    def cleanup
      if renderer
        renderer.cleanup(self)
      else
        particles.each {|p| p.cleanup}
        constraints.each {|c| c.cleanup}
      end
    end

    def all
      particles + constraints
    end
    alias get_all all

    def parented?
      @is_parented
    end

    def integrate(dt2)
      particles.each {|p| p.update(dt2)}
    end

    def satisfy_constraints
      constraints.each {|c| c.resolve}
    end

    def collidable_particles(constraint=nil)
      particles.select do |p| 
        p.collidable? and (constraint.nil? or not constraint.is_connected_to?(p))
      end
    end

    def collidable_constraints(particle=nil)
      constraints.select do |c| 
        c.collidable? and (particle.nil? or not c.is_connected_to?(particle))
      end
    end

    def check_internal_collisions
      collidable_particles.each do |pa|
        collidable_particles.each do |pb|
          CollisionDetector.test(pa, pb)
        end

        collidable_constraints(pa).each do |c|
          c.scp.update_position
          CollisionDetector.test(pa, c.scp)
        end
      end
    end

    def check_collisions_vs_collection(collection)
      # every particle in this collection...
      collidable_particles.each do |pga|
        # ...vs every particle in the other collection
        collection.collidable_particles.each do |pgb|
          CollisionDetector.test(pga, pgb)
        end

        # ...vs every constraint in the other collection
        collection.collidable_constraints(pga).each do |cgb|
          cgb.scp.update_position
          CollisionDetector.test(pga, cgb.scp)
        end
      end

      # every constraint in this collection...
      collidable_constraints.each do |cga|
        collection.collidable_particles(cga).each do |pgb|
          cga.scp.update_position
          CollisionDetector.test(pgb, cga.scp)
        end
      end
    end
  end
end
