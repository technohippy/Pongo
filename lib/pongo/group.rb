module Pongo
  # The Group class can contain Particles, Constraints, and Composites. Groups can be 
  # assigned to be checked for collision with other Groups or internally. 
  class Group < AbstractCollection
    attr_accessor :composites, :collision_list, :collide_internal

    def initialize(collide_internal=false)
      super()
      @composites = []
      @collision_list = []
      self.collide_internal = collide_internal
    end

    def init
      super
      @composites.each {|c| c.init}
    end

    def collide_internal!
      @collide_internal = true
    end

    def <<(item)
      case item
      when Composite
        add_composite(item)
      when Group
        add_collidable(item)
      when Array
        add_collidable_list(item)
      else
        super
      end
    end

    def add_composite(c)
      @composites << c
      c.is_parented = true
      c.init if @is_parented
    end

    def remove_composite(c)
      if @composites.delete(c)
        c.is_parented = false
        c.cleanup
      end
    end

    def draw
      super
      @composites.each {|c| c.draw}
    end

    def add_collidable(g)
      @collision_list << g
    end

    def remove_collidable(g)
      @collision_list.delete(g)
    end

    def add_collidable_list(list)
      list.each {|g| @collision_list << g}
    end

    def get_all
      @particles + @constraints + @composites
    end
    alias all get_all

    def clieanup
      super
      @composites.each {|c| c.cleanup}
    end

    def integrate(dt2)
      super
      @composites.each {|cmp| cmp.integrate(dt2)}
    end

    def satisfy_constraints
      super
      @composites.each {|cmp| cmp.satisfy_constraints}
    end

    def check_collisions
      check_collision_group_internal if @collide_internal
      @collision_list.each {|g| check_collision_vs_group(g) if g}
    end

    def check_collision_group_internal
      # check collisions not in composites
      check_internal_collisions

      # for every composite in this Group..
      valid_composites.each do |ca|
        # .. vs non composite particles and constraints in this group
        ca.check_collisions_vs_collection(self)

        # ...vs every other composite in this Group
        valid_composites.each do |cb|
          ca.check_collisions_vs_collection(cb)
        end
      end
    end

    def check_collision_vs_group(g)
      # check particles and constraints not in composites of either group
      check_collisions_vs_collection(g)

      # for every composite in this group..
      valid_composites.each do |c|
        # check vs the particles and constraints of g
        c.check_collisions_vs_collection(g)

        # check vs composites of g
        g.valid_composites.each do |g|
          c.check_collections_vs_collection(g)
        end
      end

      # check particles and constraints of this group vs the composites of g
      g.valid_composites.each do |gc|
        check_collisions_vs_collection(gc)
      end
    end

    def valid_composites
      @composites.select{|c| not c.nil?}
    end
  end
end
