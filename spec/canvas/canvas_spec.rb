require 'spec_helper'
require 'browser/canvas' if RUBY_ENGINE == 'opal'

# reset between each example to insure the DOM starts clean
describe 'Browser::Canvas', js: true, no_reset: false do
  context 'Gradient' do
    matcher :draw_the_correct_image do
      match do |expected_canvas|
        # Assume the spec is delivering a square canvas and
        # each pixel is made of 4 bytes for R, G, B, and Alpha channel

        size = ((expected_canvas.length / 4)**0.5).to_i
        canvas = expected_canvas.each_slice(4).each_slice(size).to_a

        # canvas should be a diagonal line of red pixels all the way, no
        # green, and blue increasing from 0 to 255 +/- for antialiasing.
        last_blue_pixel = 0

        (size - 1).times do |i|
          pixel = canvas[i][i]
          break if pixel[0] != 255 || pixel[1] != 0
          break unless pixel[2].between?(last_blue_pixel, last_blue_pixel + 5)

          last_blue_pixel = pixel[2]
        end && last_blue_pixel.between?(254, 255)
      end
    end

    html "<canvas id='the-canvas'></canvas>"

    it 'can create a linear gradient' do
      expect do
        canvas = $document['canvas']
        context = Browser::Canvas.new(canvas)
        gradient = context.gradient(50, 50, 150, 150)
        gradient.add(0, '#ff0000')
        gradient.add(1, '#ff00ff')
        context.stroke = gradient
        context.begin
        context.line(50, 50, 150, 150)
        context.stroke
        context.close
        context.data(50, 50, 101, 101).to_a
      end.to_on_client draw_the_correct_image
    end

    it 'can use blocks and helpers to clean things up' do
      expect do
        Browser::Canvas.new($document['canvas']) do
          self.stroke = gradient(50, 50, 150, 150, 0 => '#ff0000', 1 => '#ff00ff')
          path { line(50, 50, 150, 150).stroke }
        end.data(50, 50, 101, 101).to_a
      end.to_on_client draw_the_correct_image
    end
  end
end
