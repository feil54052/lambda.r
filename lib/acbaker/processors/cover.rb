module Acbaker
  module Processors
    class Cover < Base

      def defaults
        {"background-color" => "#FFFFFF", "gravity" => "Center"}
      end
      
      def run(image, image_spec, width=nil, height=nil)
        # resize image
        image.change_geometry("#{width}x#{height}^") do |px, py, i|
          image.resize!(px, py)
        end
        
        # crop image
        canvas = Magick::Image.new(width, height)
        if @options['background-color'] == :transparent
          canvas = canvas.matte_floodfill(1, 1)
        else
          canvas = canvas.color_floodfill(1, 1, Magick::Pixel.from_color(@options['background-color']))
        end
        
        # place image
        gravity_string = "Magick::#{@options['gravity']}Gravity"
        gravity = Object.const_get(gravity_string)
        image = canvas.composite(image, gravity, Magick::OverCompositeOp)
        
        image
      end

    end
  end
end
