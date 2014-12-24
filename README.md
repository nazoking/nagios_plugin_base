# NagiosPluginBase

Base class of nagios plugin.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nagios_plugin_base'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nagios_plugin_base

## Usage

```ruby
require 'nagios_plugin_base'
require 'open-uri'

# check is instant check method.
# argumsnts is options( nagios-plugin default options )
# block is check block.
Nagios::PluginBase.check!(:timeout,:verbose,:url) do
  # if you set verbose, you can use attr_reader :verbose
  puts "start" if verbose
  unless open(url).read =~ /Google/
    puts "document has not Google" if verbose
    # Methods critical! and warning! and ok! and unknown!,
    # print status and exit.
    critical!
  end
  puts "end" if verbose
  ok!
end
```

```bash
ruby check --url=https://www.google.com
```

## Contributing

1. Fork it ( https://github.com/nazoking/nagios_plugin_base/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
