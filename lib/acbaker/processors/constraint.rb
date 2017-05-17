module Acbaker
  module Processors
    class Constraint < Base
      
      def run(image, image_spec, width=nil, height=nil)
        # resize image
        image.change_geometry("#{width}x#{height}") do |px, py, i|
          image.resize!(px, py)
          image_spec['size'] = "#{px}x#{py}"
        end
        
        image
      end

    end
  end
end
