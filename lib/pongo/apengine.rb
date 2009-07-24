module Pongo
  class APEngine
    class <<self
      attr_accessor :forces, :groups, :tile_step, :damping, :container, :constraint_cycle, :constraint_collision_cycles, :logger
      alias renderer container
      alias renderer= container=

      def setup(dt=0.25)
        @time_step = dt * dt
        @groups = []
        @forces = []
        @damping = 1
        @constraint_cycles = 0
        @constraint_collision_cycles = 1
      end

      def add_force(force)
        @forces << force
      end

      def remove_force(force)
        @forces.remove(force)
      end

      def remove_all_forces
        @forces.clear!
      end

      def add_group(group)
        group.is_parented = true
        group.init
        @groups << group
      end

      def remove_group(group)
        if @groups.delete(group)
          group.is_parented = false
          group.cleanup
        end
      end

      def step
        integrate
        @constraint_cycles.times do
          satisfy_constraints
        end
        @constraint_collision_cycles.times do
          satisfy_constraints
          check_collisions
        end
      end

      def draw
APEngine.renderer.shoes.fill('#FFF')
APEngine.renderer.shoes.rect(
  :left => -10, 
  :top => -10, 
  :width => 600, #APEngine.renderer.shoes.witdh + 20, 
  :height => 500 #APEngine.renderer.shoes.height + 20
)
APEngine.renderer.shoes.fill('#F00')
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
        if @logger
          @logger.send(level, message)
        end
      end
    end
  end
end
