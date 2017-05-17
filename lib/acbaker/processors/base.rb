module Acbaker
  module Processors
    class Base
      attr_accessor :asset_pack, :options
      
      def defaults
        {}
      end
      
      def initialize(asset_pack, options={})
        @asset_pack = asset_pack
        @options = options ? defaults.merge(options) : defaults
      end
      
      def run(image, image_spec, width=nil, height=nil)
        throw "Acbaker::Processors::Base should be extended"
      end

    end
  end
end
