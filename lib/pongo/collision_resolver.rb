require 'pongo/common/math_util'

module Pongo
  class CollisionResolver
    def self.resolve(pa, pb, normal, depth)
      mtd = normal * depth
      te = pa.elasticity + pb.elasticity
      sum_inv_mass = pa.inv_mass + pb.inv_mass

      # the total friction in a collision is combined but clamped to [0,1]
      tf = MathUtil.clamp(1 - (pa.friction + pb.friction), 0, 1)

      # get the collision components, vn and vt
      ca = pa.components(normal)
      cb = pb.components(normal)

      # calculate the coefficient of restitution as the normal component
      vn_a = (cb.vn * ((te + 1) * pa.inv_mass) + 
        (ca.vn * (pb.inv_mass - te * pa.inv_mass))) / sum_inv_mass
      vn_b = (ca.vn * ((te + 1) * pb.inv_mass) + 
        (cb.vn * (pa.inv_mass - te * pb.inv_mass))) / sum_inv_mass

      # apply friction to the tangental component
      ca.vt.mult!(tf)
      cb.vt.mult!(tf)

      # scale the mtd by the ratio of the masses. heavier particles move less 
      mtd_a = mtd * ( pa.inv_mass / sum_inv_mass)
      mtd_b = mtd * (-pb.inv_mass / sum_inv_mass)

      # add the tangental component to the normal component for the new velocity 
      vn_a.plus!(ca.vt)
      vn_b.plus!(cb.vt)

      pa.resolve_collision(mtd_a, vn_a, normal, depth, -1, pb)
      pb.resolve_collision(mtd_b, vn_b, normal, depth,  1, pa)
    end
  end
end
