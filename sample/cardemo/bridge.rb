require 'pongo/group'
require 'pongo/circle_particle'
require 'pongo/spring_constraint'

class Bridge < Pongo::Group
  include Pongo

  def initialize(col_b, col_c, col_d)
    super()

    bx = 170
    by = 40
    bsize = 51.5
    yslope = 2.4
    particle_size = 4

    bridge_paa = CircleParticle.new(bx, by, particle_size, :fixed => true)
bridge_paa.user_data[:name] = 'bridge_paa'
    add_particle(bridge_paa)

    bx += bsize
    by += yslope
    bridge_pa = CircleParticle.new(bx, by, particle_size)
bridge_pa.user_data[:name] = 'bridge_pa'
    add_particle(bridge_pa)

    bx += bsize
    by += yslope
    bridge_pb = CircleParticle.new(bx, by, particle_size)
bridge_pb.user_data[:name] = 'bridge_pb'
    add_particle(bridge_pb)

    bx += bsize
    by += yslope
    bridge_pc = CircleParticle.new(bx, by, particle_size)
bridge_pc.user_data[:name] = 'bridge_pc'
    add_particle(bridge_pc)

    bx += bsize
    by += yslope
    bridge_pd = CircleParticle.new(bx, by, particle_size)
bridge_pd.user_data[:name] = 'bridge_pd'
    add_particle(bridge_pd)

    bx += bsize
    by += yslope
    bridge_pdd = CircleParticle.new(bx, by, particle_size, :fixed => true)
bridge_pdd.user_data[:name] = 'bridge_pdd'
    add_particle(bridge_pdd)

    bridge_conn_a = SpringConstraint.new(bridge_paa, bridge_pa,
      :stiffness => 0.9, :collidable => true, :rect_height => 10, :rect_scale => 0.8)
    bridge_conn_a.fixed_end_limit = 0.25
    add_constraint(bridge_conn_a)

    bridge_conn_b = SpringConstraint.new(bridge_pa, bridge_pb,
      :stiffness => 0.9, :collidable => true, :rect_height => 10, :rect_scale => 0.8)
    add_constraint(bridge_conn_b)

    bridge_conn_c = SpringConstraint.new(bridge_pb, bridge_pc,
      :stiffness => 0.9, :collidable => true, :rect_height => 10, :rect_scale => 0.8)
    add_constraint(bridge_conn_c)

    bridge_conn_d = SpringConstraint.new(bridge_pc, bridge_pd,
      :stiffness => 0.9, :collidable => true, :rect_height => 10, :rect_scale => 0.8)
    add_constraint(bridge_conn_d)

    bridge_conn_e = SpringConstraint.new(bridge_pd, bridge_pdd,
      :stiffness => 0.9, :collidable => true, :rect_height => 10, :rect_scale => 0.8)
    bridge_conn_e.fixed_end_limit = 0.25
    add_constraint(bridge_conn_e)
  end
end
