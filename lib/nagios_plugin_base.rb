require "nagios_plugin_base/version"
require 'optparse'

module Nagios
  class PluginBase
    # exit codes
    CODES=[
      "OK",
      "WARNING",
      "CRITICAL",
      "UNKNOWN"
    ]
    # well known options
    OPTOINS = {
      :hostname       => ['-H','--hostname=VAL'],
      :warning        => ['-w','--warning', 'warning threshold',Float],
      :critical       => ['-c','--critical', 'critical threshold',Float],
      :authentication => ['-a','--authentication=VAL'],
      :verbose        => ['-v','--[no-]verbose'],
      :timeout        => ['-t','--timeout=VAL',Float],
      :port           => ['-p','--port=VAL',Integer],
      :logname        => ['-l','--logname=VAL'],
      :url            => ['-u','--url'],
      :community      => ['-C','--community'],
    }

    # @method ok!
    #  Print "OK" and exit 0
    # @method warning!
    #  Print "WARNING" and exit 1
    # @method critical!
    #  Print "CRITICAL" and exit 2
    # @method warning!
    #  Print "WARNING" and exit 3
    CODES.each_with_index do |name,code|
      eval <<-CODE
        def #{name.downcase}!
          exit_ #{code}
        end
      CODE
    end

    # Print message and option helps, and exit as UNKNOWN.
    # this is default style of argument error.
    def invalid_args!(message=nil)
      puts message if message
      puts @opt.help
      unknown!
    end
    # Print status (ex: OK) and exit
    # @param [Integer] :code
    def exit_(code)
      if CODES[code]
        puts "#{CODES[code]}"
        exit code
      else
        raise "unknown exit code #{code}"
      end
    end
    # Add option to option parser and create attribute-reader to self
    # @param [Symbol] arg     Option name
    # @param [Array]  options Option arguments for optparse
    def set_default_option(arg, options)
      @opt.on(*options){|v|
        instance_variable_set("@#{arg}".to_sym, v)
      }
      eval <<-CODE
        class << self
          define_method(:#{arg}){ @#{arg} }
        end
      CODE
    end
    # set option to option parser
    # @param [Symbol] :arg option from OPTIONS
    def option(arg)
      if OPTOINS[arg]
        set_default_option(arg, OPTOINS[arg])
      else
        raise "unknwon nagios plugin option #{arg}"
      end
    end
    # @param [Array<Symbol>] args option parser arguments
    def initialize(args=[])
      @opt = OptionParser.new
      args.each{|a| option(a)}
    end
    # parse option
    # @param [Array] argv cmmand line argumetns
    def parse!(argv)
      begin
        @opt.parse!(argv)
      rescue OptionParser::InvalidOption => e
        invalid_args!(e.to_s)
      end
    end
    # Run block with timeout.
    # @yield Main check callback block.
    # @yieldreturn [Integer] exit code.
    def run
      Timeout.timeout(@timeout) do
        ret = yield
        raise "block need exit code" unless ret
        exit_(ret)
      end
    rescue Timeout::Error => e
      puts "timeout"
      critical!
    rescue => e
      puts e.class, e
      unknown!
    end
    # instant check
    def self.check!(*args,&block)
      opt = self.new(args)
      opt.parse!(ARGV)
      opt.run do |opta|
        opt.instance_eval(&block)
      end
    end
  end
end

