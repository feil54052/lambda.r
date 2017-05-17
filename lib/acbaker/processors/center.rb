require 'pry'

module Acbaker
  module Processors
    class Center < Base

      def defaults
        {"max-width" => "50%", "background-color" => "#FFFFFF", "gravity" => "Center"}
      end
            
      def run(image, image_spec, width=nil, height=nil)
        transform_width = width.to_f
        transform_height = height.to_f
        target_ratio = transform_width / transform_height
        image_ratio = image.rows.to_f / image.columns.to_f
        
        # calculate dimensions
        if @options['max-width']
          if @options['max-width'][-1] == "%"
            rel_width = (@options['max-width'][0..-2].to_f / 100)
            transform_width = transform_width * rel_width
          else
            transform_width = @options['max-width'].to_f
          end
          transform_height = transform_width * image_ratio
        end
        
        # resize image
        image.resize!(transform_width.to_i, transform_height.to_i)
        
        # create canvas
        canvas = Magick::Image.new(width, height)
        if @options['background-color'] == :transparent
          canvas = canvas.matte_floodfill(1, 1)
        else
          canvas = canvas.color_floodfill(1, 1, Magick::Pixel.from_color(@options['background-color']))
        end
        
        # place image
        image = canvas.composite(image, Magick::CenterGravity, Magick::OverCompositeOp)
        
        image
      end

    end
  end
end
