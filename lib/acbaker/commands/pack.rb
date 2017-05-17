command :'pack' do |c|
  c.syntax = "acbaker pack [image] [output directory]"
  c.summary = "Convert an image into a xcode asset catalogs"
  c.description = "The type will be autodetected by filename, and can be overwritten using the --type option"
  c.option '--type STRING', String, 'Specify asset pack type'
  c.option '--json STRING', String, 'Specify custom json file path'
  c.option '--gravity STRING', String, 'Specify gravity (NorthWest, North, NorthEast, West, Center, East, SouthWest, South, SouthEast)'
  c.option '--strategy STRING', String, 'Specify strategy (Cover, Contain, Center)'
  c.option '--force', String, 'Delete and recreate output directory (careful!)'
  global_option '--force'

  c.action do |args, options|
    
    # Prepare arguments
    @image = args[0]
    @output_directory = args[1]
    @type = options.type
    @json = options.json
    @gravity = options.gravity
    @strategy = options.strategy
    @force = options.force
    
    # Validate
    validate_image_magick!
    validate_image!
    validate_json!
    validate_type!
    validate_gravity!
    validate_strategy!
    
    validate_output_directory!

    # Initialize packer
    asset_pack = Acbaker::AssetPack.new(@type, {
      json: JSON.parse(File.open(@json).read),
      gravity: @gravity,
      strategy: @strategy
    })
    
    # Pack assets    
    bar = ProgressBar.new(asset_pack.images.size)
    bar.show
    asset_pack.process(@image, @output_directory) do |path, progress|
      bar.increment
    end

    say_ok 'Your assets were successfully packed!'

  end

  private

  def validate_image_magick!
    abort('You need to install Image Magick! Check http://www.imagemagick.org for instructions.') unless system("which convert > /dev/null 2>&1")
  end

  def validate_image!
    
    # validate image is set
    abort("Error: no image specified.") if @image.nil?
    
    # validate image exists
    abort("Error: can't find the image you specified. #{@image}") unless File.exist?(@image) and File.file?(@image)    
    
  end
  
  def validate_type!
    if not @type
      # Detect from image
      token = @image.split('/')[-1].split('.')[0].downcase.to_sym
      @type = {
        appicon: :AppIcon,
        launchimage: :LaunchImage,
        icon: :AppIcon,
        launch: :LaunchImage
      }[token]
    end
    
    if not @type and @output_directory
      # Detect from directory
      token = @output_directory.gsub('.', '').downcase.to_sym
      @type = {
        appiconappiconset: :AppIcon,
        appicon: :AppIcon,
        launchimagelaunchimage: :LaunchImage,
        launchimage: :LaunchImage
      }[token]
    end
    
    # Fill json
    if @type and not @json
      if File.file?("lib/acbaker/config/#{@type}.json")
        @json = "lib/acbaker/config/#{@type}.json"
      end
    end
    
    abort "error: no JSON configuration found" if not @json
    abort("error: Could not detect asset type.") if not @type
  end
  
  def validate_gravity!
    if not @gravity
      @gravity = "Center"
    end
    abort("error: Invalid gravity specified.") if not ["NorthWest", "North", "NorthEast", "West", "Center", "East", "SouthWest", "South", "SouthEast"].include?(@gravity)
  end

  def validate_strategy!
    if not @strategy
      @strategy = "Cover"
    end
    
    # try to instantiate strategy class
    begin
      Object.const_get("Acbaker::Processors::#{@strategy}")
    rescue Exception => e
      abort("error: Invalid strategy specified.")
    end
  end

  
  def validate_json!
    if @json
      abort("error: JSON file not found.") if not File.exist?(@json) or not File.file?(@json)
      begin
        JSON.parse(File.open(@json).read)
      rescue Exception => e
        abort("error: invalid JSON file: #{@json}")
      end
      @type = :Custom if not @type
    end
  end

  def validate_output_directory!
    if not @output_directory
      @output_directory = {
        AppIcon: "AppIcon.appiconset",
        LaunchImage: "LaunchImage.launchimage"
      }[@type]
    end

    # Create custom output directory if type is set
    @output_directory = "#{@type}.imageset"  if not @output_directory and @type
    
    abort("Error: No output directory specified or detected.") if @output_directory.nil?
    parent_directory = File.expand_path(@output_directory).split("/")[0..-2].join("/")    
    abort("Error: Parent directory '#{parent_directory}' does not exist.") unless File.exist?(parent_directory) and File.directory?(parent_directory)    
    
    # Prepare output directory
    if @force
      FileUtils.rm_rf(@output_directory) if File.directory?(@output_directory)
    end
    FileUtils.mkdir(@output_directory) if not File.directory?(@output_directory)
  end

end