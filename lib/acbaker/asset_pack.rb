require 'json'
require 'rmagick'

module Acbaker
  class AssetPack
    attr_reader :type, :images, :processors
    
    def initialize(type, options={})
      @type = type
      @processors = []
      if options[:json]
        @json_data = options[:json]
      else
        @json_file = File.join(File.dirname(File.expand_path(__FILE__)), "config", "#{type.to_s}.json")
        @json_data = JSON.parse(File.open(@json_file).read)
      end
      @images = @json_data['images']
      @options = self.defaults().merge(options)
    end
    
    def defaults
      {json: false, gravity: 'Center', strategy: 'Cover'}
    end
    
    def process(source_image_file, target_directory, &block)
  
      # Define variables
      json_output_file = File.join(target_directory, "Contents.json")
  
      # Get processors
      if @json_data['processors'] and @json_data['processors'].length
        @json_data['processors'].each do |processor_spec|
          @processors.push(Object.const_get(processor_spec['type']).new(self, processor_spec['config']))
        end
      else
        @processors = [Object.const_get("Acbaker::Processors::#{@options[:strategy]}").new(self)]
      end
  
      # Loop through images
      @json_data['images'].each_with_index.map do |image_spec, index|
        
        image_size_present = image_spec['size']
        image = Magick::ImageList.new(source_image_file)
        image_spec['size'] = "#{image.columns.to_s}x#{image.rows.to_s}" unless image_size_present

        # Get size
        scale = image_spec['scale'].gsub('x', '').to_i
        if image_size_present
          (width_str, height_str) = image_spec['size'].split('x')
          width = width_str.to_i * scale
          height = height_str.to_i * scale
        else
          width = image.columns
          height = image.rows
        end
        size_max = [width, height].max
        base_width = width / scale
        base_height = height / scale

        # Get version
        if image_spec['minimum-system-version'].nil?
          version = 'ios56'
        elsif image_spec['minimum-system-version'] == '8.0'
          version = 'ios8'
        elsif image_spec['minimum-system-version'] == '7.0'
          version = 'ios78'
        else
          version = 'ios56'
        end
    
        # process image
        @processors.each do |processor|
          image = processor.run(image, image_spec, width, height)
        end
        
        # Generate filename
        if image_spec["filename"]
          filename = image_spec["filename"]
        else
          filename_array = []
          filename_array.push(@type)
          filename_array.push(image_spec['idiom']) if image_spec['idiom']
          filename_array.push(image_spec['orientation']) if image_spec['orientation']
          filename_array.push(version)
    
          # Add subtype
          if image_spec['subtype']
            if image_spec['subtype'] == '736h'
              filename_array.push('retina-hd-55')
            elsif image_spec['subtype'] == '667h'
              filename_array.push('retina-hd-47')
            else
              filename_array.push(image_spec['subtype'])
            end
          end
    
          # Add extent
          filename_array.push(image_spec['extent']) if image_spec['extent']
    
          # Add size
          filename_array.push(image_spec['size'])
    
          if scale > 1
            filename = "#{filename_array.join('-')}@#{scale}x.png"
          else
            filename = "#{filename_array.join('-')}.png"
          end
        end

        # save image
        image.write("#{target_directory}/#{filename}")
        
        # Trigger Callback proc
        block.call("#{target_directory}/#{filename}", index+1) if not block.nil?
    
        # Update json data
        image_spec['filename'] = filename
      end

      # Save Contents.json
      @json_data.delete('processors')
      File.open(json_output_file,"w") do |f|
        f.write(JSON.pretty_generate(@json_data))
      end
  
      true
    end
    
  end
end
