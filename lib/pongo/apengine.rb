require 'pongo/group'
module Pongo
  # The main engine class. 
  class PhysicsEngine
    attr_accessor :forces, :groups, :tile_step, :damping, :container, 
      :constraint_cycles, :constraint_collision_cycles, :renderer, :logger

    def container=(c)
      @container = c
      @renderer = c.renderer
      @logger = c.logger
    end

    # Initializes the engine. You must call this method prior to adding any 
    # particles or constraints.
    def setup(options={}) #dt=0.25)
      options = {
        :dt => 0.25, :damping => 1, :constraint_cycles => 0, 
        :constraint_collision_cycles => 1
      }.update(options.is_a?(Numeric) ? {:dt => options} : options)

      @time_step = options[:dt] * options[:dt]
      @groups = []
      @forces = []
      self.damping = options[:damping]
      self.constraint_cycles = options[:constraint_cycles]
      self.constraint_collision_cycles = options[:constraint_collision_cycles] 

      self.container = options[:container] if options[:container]
      self.renderer = options[:renderer] if options[:renderer]
      self.logger = options[:logger] if options[:logger]
      self.gravity = options[:gravity] if options[:gravity]
    end
    alias init setup

    # Adds a force to all particles in the system. The forces added to the APEngine
    # class are persistent - once a force is added it is continually applied each
    # APEngine.step() cycle.
    def add_force(force)
      @forces << force
    end

    def gravity=(val)
      case val
      when Numeric
        add_force(VectorForce.new(false, 0, val))
      when Array
        add_force(VectorForce.new(false, *val))
      when VectorForce
        add_force(val)
      else
        raise ArgumentError
      end
    end

    # Removes a force from the engine.
    def remove_force(force)
      @forces.remove(force)
    end

    # Removes all forces from the engine.
    def remove_all_forces
      @forces.clear
    end

    def build_group(collide_internal=false)
      group = Group.new(collide_internal)
      @groups << group
      group
    end

    # Adds a Group to the engine.
    def add_group(group)
      @groups << group
      group.is_parented = true
      group.init
    end

    # Removes a Group from the engine.
    def remove_group(group)
      if @groups.delete(group)
        group.is_parented = false
        group.cleanup
      end
    end

    # The main step function of the engine. This method should be called
    # continously to advance the simulation. The faster this method is 
    # called, the faster the simulation will run. Usually you would call
    # this in your main program loop. 
    def step
      integrate
      constraint_cycles.times do
        satisfy_constraints
      end
      constraint_collision_cycles.times do
        satisfy_constraints
        check_collisions
      end
    end

    # Calling this method will in turn call each Group's paint() method.
    # Generally you would call this method after stepping the engine in
    # the main program cycle.
    def draw
      @groups.each {|g| g.draw}
    end
    alias paint draw

    def integrate
      @groups.each {|g| g.integrate(@time_step)}
    end

    def satisfy_constraints
      @groups.each {|g| g.satisfy_constraints}
    end

    def check_collisions
      @groups.each {|g| g.check_collisions}
    end

    def <<(item)
      if item.is_a?(Group)
        add_group(item)
      else
        if @groups.empty?
          @groups << Group.new(true) 
          @groups.first.is_parented = true
          @groups.first.init
        end
        @groups.last << item
      end
    end

    def create_group(collide_internal=true, &block)
      @groups << Group.new(collide_internal)
      block.call(@groups.last) if block
      @groups.last
    end

    def next_frame(options={})
      options[:before].call if options[:before]
      step
      draw
      options[:after].call if options[:after]
    rescue
      log($!)
      raise $!
    end

    def log(message, level=:info)
      message = message.message + "\n" + message.backtrace.join("\n") if message.is_a?(Error)
      @logger.send(level, message) if @logger
    end
  end
  APEngine = PhysicsEngine.new
end
