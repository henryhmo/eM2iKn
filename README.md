# EM2iKn

Allows you to take an HQMF definition for a quality measure or a phenotype, and generates a KNIME workflow that can execute against an i2b2 instance.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'eM2iKn'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install eM2iKn

## Usage

To run from the command line:

```rake phema:generate[path,name,output_dir]```

Where path is the path to the HQMF file representing your phenotype or quality measures, name is what you would like to name the resulting workflow, and output_dir is the directory where the workflow should be generated.

E.g.:

```rake phema:generate[./example/input.xml,Example,./tmp]```

Will create a new workflow in ./tmp/Example which is based on the data elements and logic in ./example/input.xml.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/phema/eM2iKn.

