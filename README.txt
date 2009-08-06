= Pongo

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

== EXECUTE SAMPLES:

* ruby sample/tk/robotdemo.rb
* shoes sample/shoes/robotdemo.rb
* shoes sample/shoes/cardemo.rb

== SYNOPSIS:

  require 'pongo'
  require 'pongo/container/shoes_container'

  include Pongo

  Shoes.app :width => 500, :height => 350 do
    APEngine.setup :gravity => 2, :container => Container::ShoesContainer.new(self)

    APEngine.create_group do |g|
      g.circle(245, 100, 10)
      g.rectangle(250, 250, 300, 50, :fixed => true)
    end

    animate(60) do |anim|
      APEngine.next_frame
    end
  end

== REQUIREMENTS:

* Shoes2 ( http://shoooes.net/ )

== INSTALL:

* sudo gem install technohippy-Pongo

== IMAGES:

* http://www.flickr.com/photos/24557420@N05/3366850475/
* http://www.aa.alles.or.jp/~palette/icon/icon.html

== LICENSE:

(The MIT License)

Copyright (c) 2009 Ando Yasushi

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
