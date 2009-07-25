module Pongo
  # The main engine class. 
  class APEngine
    class <<self
      attr_accessor :forces, :groups, :tile_step, :damping, :container, 
        :constraint_cycles, :constraint_collision_cycles, :logger

      alias renderer container
      alias renderer= container=

      # Initializes the engine. You must call this method prior to adding any 
      # particles or constraints.
      def setup(dt=0.25)
        @time_step = dt * dt
        @groups = []
        @forces = []
        self.damping = 1
        self.constraint_cycles = 0
        self.constraint_collision_cycles = 1
      end

      # Adds a force to all particles in the system. The forces added to the APEngine
      # class are persistent - once a force is added it is continually applied each
      # APEngine.step() cycle.
      def add_force(force)
        @forces << force
      end

      # Removes a force from the engine.
      def remove_force(force)
        @forces.remove(force)
      end

      # Removes all forces from the engine.
      def remove_all_forces
        @forces.clear
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

      def log(message, level=:info)
        @logger.send(level, message) if @logger
      end
    end
  end
end
