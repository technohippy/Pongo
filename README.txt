= pongo

* http://github.com/technohippy/Pongo/

== DESCRIPTION:

Ruby port of APE (Actionscript Physics Engine)

== FEATURES/PROBLEMS:

* CircleParticles
* RectangleParticles
* WheelParticles
* SpringConstraints
* Grouping
* Collision

see also: http://www.cove.org/ape/index.htm

== SYNOPSIS:

  require 'pongo'
  require 'pongo/renderer/shoes_renderer'
  require 'pongo/logger/shoes_logger'

  include Pongo
  Shoes.app :width => 500, :height => 350 do
    APEngine.renderer = Renderer::ShoesRenderer.new(self)
    APEngine.logger = Logger::ShoesLogger.new(self)
    APEngine.setup
    APEngine.add_force VectorForce.new(false, 0, 2)

    default_group = Group.new
    default_group.collide_internal = true

    ball = CircleParticle.new(245, 100, 10)
    default_group.add_particle(ball)

    ground = RectangleParticle.new(250, 250, 300, 50, 0, true)
    ground.always_redraw!
    default_group.add_particle(ground)

    APEngine.add_group(default_group)

    animate(60) do |anim|
      APEngine.step
      APEngine.draw
    end
  end

== REQUIREMENTS:

* Shoes2 ( http://shoooes.net/ )

== INSTALL:

* sudo gem install pongo

== LICENSE:

(The MIT License)

Copyright (c) 2009 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
