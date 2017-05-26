#!/usr/bin/ruby1.8
      

class Aargvark
  attr_accessor :argument_pool, :letter_array, :noarg_count, :matches, :aliens

  def initialize(argv, all_args)
    @argv = argv
    @argument_pool = []
    @letter_array = []
    @matches = []

    all_args.each {|i| @argument_pool << Argument.new(i)}
    @noarg_count = [0,0,0]
    @argument_pool.each do |i|
      if i.noarg
        @noarg_count[0] += 1 if i.required
        @noarg_count[1] += 1
      end
    end
    get_matches
  end

  def get_matches
    # Add all present argument letters and aliases to the letter_array array
    @argument_pool.each do |arg|
      @letter_array << arg.letter
      if arg.alias
        @letter_array << arg.alias
      end
    end

    @argv.each do |s|
      if s.is_arg? || s.is_alias?
        unless @letter_array.index(s)
          type = s.is_arg? ? "Argument" : "Alias"
          raise ArgumentError, "#{type} #{s} was entered, but is not valid."
        end
      end
    end
    
    @argument_pool.each do |arg|
      
      if arg.letter
        letter_pos = @argv.index(arg.letter)
        if letter_pos
          subarg_pos = letter_pos + 1
        end
      end

      if arg.alias
        alias_pos = @argv.index(arg.alias)
        if alias_pos
          subarg_pos = alias_pos + 1
        end
      end

      if ! letter_pos && ! alias_pos && ! arg.noarg && arg.required
        error = "The use of argument \"#{arg.letter}\" "
        error += arg.alias ? "or its alias \"#{arg.alias}\" are" : "is"
        error += " required when running this script.\nPlease make sure that "
        error += arg.alias ? "either of these are" : "this is"
        error += " called when running the script from the commandline."
        
        raise ArgumentError, error
      end

      #need script to input the values for the :noarg arguments based on the end of
      #the sub-arguments for the last argument in the argv array
      if arg.noarg
        last_arg = @argv.collect {|e| e.scan(/^-[a-z]$|^--[a-z\-]+$/)}.flatten.pop
        arg_obj = spit_argument(last_arg)
        last_arg_pos = @argv.rindex(last_arg)
        diff = @argv.size - last_arg_pos
      end

      if letter_pos || alias_pos
        if @argv.rindex(arg.letter) != letter_pos || @argv.rindex(arg.alias) != alias_pos
          raise ArgumentError, "Argument \"#{arg.letter}\" was called twice from the commandline.  "+
                               "Each argument should only be called once."
        end

        # Raise an error if both an argument and its alias are called from the
        # command line
        if letter_pos && alias_pos
          raise ArgumentError, "Argument \"#{arg.letter}\" and alias \"#{arg.alias}\" were both" +
                               " called from the command line.  Please use only the letter" +
                               " argument or the alias, not both."
        end

        alien_pos = subarg_pos
        alien_count = 0
        if @argv[alien_pos] != nil
          while ! @argv[alien_pos].is_arg? && ! @argv[alien_pos].is_alias?
            argv_diff = @argv.size - alien_pos
            break if @noarg_count[0] <= argv_diff && argv_diff <= @noarg_count[1]
            alien_pos += 1
            alien_count += 1
            break if ! @argv[alien_pos]
          end
        end
        
        min = arg.subarg_range[0]
        max = arg.subarg_range[1]
        if alien_count < min || max < alien_count
          error = "#{alien_count} sub-arguments have been given for argument #{arg.letter}.\n" +
                  "The current parameters for #{arg.letter} specify that you use "          
          error += min == max ? "exactly #{min}" : "between #{min} and #{max}"
          error += " sub-arguments.  \nPlease double-check your " +
          "input array and ensure the correct number of sub-arguments."

          raise ArgumentError, error
        end
        
        @matches << arg.letter
        if arg.sub_args
          arg.sub_args.each do |subarg_array|
            required = subarg_array[0]
            type = subarg_array[1]
            if required == false
              if @argv[subarg_pos].class.to_s == type.to_s.capitalize && @letter_array.index(@argv[subarg_pos]) == nil
                @matches << @argv[subarg_pos]
              end
            elsif required == true
              if @argv[subarg_pos].class.to_s == type.to_s.capitalize && @letter_array.index(@argv[subarg_pos]) == nil
                @matches << @argv[subarg_pos]
              else
                raise ArgumentError, "\"#{@argv[subarg_pos]}\" is not a valid sub-argument for argument #{arg.letter}.\n" +
                                     "A valid sub-argument of type #{type.to_s.capitalize} must be entered in this position."
              end
            end
            subarg_pos += 1
          end
        end
      end
    end
  end

  def spit_argument(in_arg)
    if ! in_arg.is_arg? && ! in_arg.is_alias?
      raise ArgumentError, "#{in_arg} is not a valid argument request for spit_argument.  The \"letter\" " +
                           "variable should be either an argument or an alias."
    end
    @argument_pool.each do |a|
      return a if a.letter == in_arg || a.alias == in_arg
    end
  end
  
  def matches
    puts @matches
  end

  class Argument
    attr_accessor :letter, :noarg, :alias, :required, :sub_args, :subarg_range

    def initialize (arg_array)
      @sub_args = []
      @subarg_range = [0,0]

      if arg_array.class != Array
        if arg_array.class == String
          if arg_array.is_arg?
            @letter = arg_array
          end 
        else
          raise ArgumentError, "\"#{arg_array}\" is not a valid argument.  Arguments and the details" +
                               " thereof must be entered as an Array in the format:" +
                               "[\"-n\", \"--argument-alias\", [true/false, :string/:integer/:float], etc...]"
        end
      else
        if arg_array[0].is_arg?
          @letter = arg_array[0]
        elsif arg_array[0].is_noarg?
          @noarg = true
        else
          raise ArgumentError, "The first item in each Argument array must be either a lowercase letter preceded by" +
                             " a hyphen or the symbol :noarg.  Please go back and make sure that your argument arrays conform to" +
                             " these standards."
        end
      end

      if arg_array.size > 1
        
        #If the second item in an argument array is an alias, set the alias for the
        #argument as that value.
        if arg_array[1].is_alias?
          @alias = arg_array[1]
        end

        if arg_array[1] == :required || arg_array[2] == :required
          @required = true
        else
          @required = false
        end
        
        first_subarg = 1
        if @alias
          first_subarg += 1
        end

        if @required
          first_subarg += 1
        end
        
        first_subarg.upto(arg_array.size - 1) do |x|
          if arg_array[x].is_subarg?
            @sub_args << arg_array[x]
          end
        end
      end

      @sub_args.each do |subarg|
        @subarg_range[0] += 1 if subarg.to_s == "true"
        @subarg_range[1] += 1
      end

    end
  end
end


class String

  def is_arg?
    match(/^-[A-Za-z{1}]$/)
  end
   
  def is_alias?
    match(/^--[A-Za-z\-]+$/)
  end

  def is_noarg?
    return false
  end

end

class Symbol

  def is_arg?
    return false
  end

  def is_alias?
    return false
  end

  def is_noarg?
    return self == :noarg ? true : false
  end

end


public
def is_subarg?(throw_errors = true)
  if self.class != Array
    return false
    if throw_errors
      raise ArgumentError, "Sub-arguments must be entered as an array, in the format:"
                           + "[true/false, :string/:integer/:float]"
    end
  else
    has_true_false = self[0].to_s.match(/^true|false$/)
    result = self[1].to_s.match(/^string|integer|float$/)
    has_subarg_type = result && self[1].class == Symbol ? true : false
    if ! has_true_false
      return false
      if throw_errors
        raise ArgumentError, "The first value in each sub-argument array must be either 'true' or 'false'"
      end
    elsif ! has_subarg_type
      return false
      if throw_errors
        raise ArgumentError, "The second value in each sub-argument array must be either :string, :integer or :float"
      end
    else
      return true
    end
  end
end

  

