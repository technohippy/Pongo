require 'pongo/renderer/shoes_renderer'
require 'pongo/logger/shoes_logger'

module Pongo
  module Container
    class ShoesContainer
      attr_accessor :renderer, :logger

      def initialize(shoes)
        @renderer = Renderer::ShoesRenderer.new(shoes)
        @logger = Logger::ShoesLogger.new(shoes)
      end
    end
  end
end
