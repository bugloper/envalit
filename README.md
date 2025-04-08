# Envalit

[![Gem Version](https://badge.fury.io/rb/envalit.svg)](https://badge.fury.io/rb/envalit)
[![Build Status](https://github.com/bugloper/envalit/workflows/Ruby%20Setup/badge.svg)](https://github.com/bugloper/envalit/actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Envalit is a powerful Ruby gem for managing and validating environment variables in your applications. It provides a flexible way to ensure all required environment variables are present and correctly typed, with options for warnings or strict validation.

## Features

- 🔍 **Type Validation**: Support for string, integer, boolean, and float types
- 🚨 **Validation Modes**: Choose between warning or strict error modes
- 📝 **Default Values**: Set fallback values for optional variables
- 📚 **Documentation**: Add descriptions to document your environment variables
- 🌈 **Colored Output**: Clear, colorized error messages for better visibility
- 🚀 **Rails Integration**: Easy setup with Rails generator
- 📁 **Dotenv Integration**: Automatic loading of `.env` files
- 💡 **Helpful Errors**: Clear error messages with fix suggestions

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'envalit'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install envalit
```

### Rails Setup

If you're using Rails, you can use our generator to quickly set up your environment configuration:

```bash
$ rails generate envalit:install
```

This will:
1. Create `config/initializers/envalit.rb` with example configurations
2. Create `.env.example` with sample environment variables

## Usage

### Basic Configuration

```ruby
require 'envalit'

Envalit.configure do |config|
  # Required variable with type validation
  config.register "DATABASE_URL",
                 required: true,
                 strict: true,
                 description: "PostgreSQL connection URL"

  # Optional variable with default value
  config.register "PORT",
                 type: :integer,
                 default: 3000,
                 description: "Application port number"

  # Boolean flag
  config.register "DEBUG_MODE",
                 type: :boolean,
                 default: false,
                 description: "Enable debug mode"
end

# Normal validation (warns about missing variables)
Envalit.validate

# Strict validation (raises errors for missing variables)
Envalit.validate!
```

### Validation Modes

Envalit provides two validation modes:

1. **Normal Mode** (`validate`):
   - Warns about missing required variables
   - Raises errors only for variables marked as `strict: true`
   - Good for development environments

```ruby
Envalit.validate # Prints warnings but doesn't halt execution
```

2. **Strict Mode** (`validate!`):
   - Raises errors for any missing required variables
   - Ignores the `strict` setting
   - Recommended for production environments

```ruby
Envalit.validate! # Raises ValidationError if any required variables are missing
```

### Type Validation

Envalit supports multiple data types:

```ruby
Envalit.configure do |config|
  # String (default)
  config.register "API_KEY",
                 required: true

  # Integer
  config.register "PORT",
                 type: :integer,
                 default: 3000

  # Boolean
  config.register "CACHE_ENABLED",
                 type: :boolean,
                 default: true

  # Float
  config.register "TIMEOUT",
                 type: :float,
                 required: true,
                 default: 5.5
end
```

### Rails Integration

In your Rails application, create an initializer:

```ruby
# config/initializers/envalit.rb
Envalit.configure do |config|
  # Critical Variables
  config.register "SECRET_KEY_BASE",
                 required: true,
                 strict: true

  # Optional Settings
  config.register "CACHE_TTL",
                 type: :integer,
                 default: 3600,
                 description: "Cache time-to-live in seconds"
end

# Validate based on environment
if Rails.env.production?
  Envalit.validate! # Strict validation in production
else
  Envalit.validate  # Normal validation in development/test
end
```

### Error Messages

Envalit provides clear, colorized error messages:

```
Missing required environment variables:
  - DATABASE_URL
    Type: string
    Description: PostgreSQL connection URL

To fix this:
1. Create a .env file in your project root if it doesn't exist
2. Copy values from .env.example to your .env file:
   cp .env.example .env
3. Update the values in your .env file with your actual configuration
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bugloper/envalit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
