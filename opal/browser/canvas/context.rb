module Browser; class Canvas

class Context
  include Native

  def self.implementations
	  @implementations ||= {}
  end

	def self.define(name, &block)
		implementations[name.to_s.downcase] = Class.new(Context, &block)
	end

	def self.[](name)
		implementations[name.to_s.downcase]
	end

	attr_reader :element

	def initialize(element)
		@element = element
	end

	def width
		@element['width']
	end

	def height
		@element['height']
	end
end

end; end

require 'browser/canvas/2d'
