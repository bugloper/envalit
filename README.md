# Envalit

[![Gem Version](https://badge.fury.io/rb/envalit.svg)](https://badge.fury.io/rb/envalit)
[![Build Status](https://github.com/bugloper/envalit/workflows/Ruby%20Setup/badge.svg)](https://github.com/bugloper/envalit/actions)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Envalit is a powerful Ruby gem for managing and validating environment variables in your applications. It provides a flexible way to ensure all required environment variables are present and correctly typed, with options for warnings or strict validation.

## Features

- Simple and expressive configuration API
- Type validation (string, integer, boolean, float)
- Default values for optional variables
- Automatic loading from `.env` files
- Configurable validation modes (warn vs. strict)
- Rails generator for easy setup
- Comprehensive documentation

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

### Rails Generator

Envalit provides a Rails generator to quickly set up your environment configuration:

```bash
$ rails generate envalit:install
```

This will:
1. Create `config/initializers/envalit.rb` with example configurations
2. Create `.env.example` with sample environment variables
3. Add common environment variables with type validation
4. Set up strict validation for critical variables

The generated files provide a starting point that you can customize for your application's needs.

## Usage

### Basic Configuration

```ruby
require 'envalit'

Envalit.configure do |config|
  # Database Configuration
  config.register "DATABASE_URL",
                 required: true,
                 strict: true,
                 description: "PostgreSQL connection URL"

  # Application Settings
  config.register "PORT",
                 type: :integer,
                 default: 3000,
                 description: "Application port number"

  # Feature Flags
  config.register "DEBUG_MODE",
                 type: :boolean,
                 default: false,
                 description: "Enable debug mode"
end

# Validate environment variables
Envalit.validate  # Warns about missing variables
Envalit.validate! # Raises errors for any missing required variables
```

### Validation Modes

Envalit provides two validation modes:

```ruby
# Normal validation (validate)
Envalit.validate
# - Warns about missing required variables that aren't marked as strict
# - Raises errors only for variables marked as strict: true
# - Good for development environments

# Strict validation (validate!)
Envalit.validate!
# - Always raises errors for any missing required variables
# - Ignores the strict setting and treats all required variables as strict
# - Good for production environments
```

### Type Validation

Envalit supports multiple data types:

```ruby
Envalit.configure do |config|
  # Integer validation
  config.register "PORT",
                 type: :integer,
                 default: 3000

  # Boolean validation
  config.register "CACHE_ENABLED",
                 type: :boolean,
                 default: true

  # Float validation
  config.register "TIMEOUT",
                 type: :float,
                 required: true,
                 default: 5.5

  # String validation (default)
  config.register "API_KEY",
                 required: true
end
```

### Rails Integration

#### Using the Generator

Generate the initializer and example environment file:

```bash
$ rails generate envalit:install
```

This creates:
- `config/initializers/envalit.rb` - Configuration file
- `.env.example` - Example environment variables

#### In a Rails Initializer

```ruby
# config/initializers/envalit.rb
Envalit.configure do |config|
  # Critical Variables (Strict Mode)
  config.register "SECRET_KEY_BASE",
                 required: true,
                 strict: true

  # Database Configuration
  config.register "DATABASE_URL",
                 required: true,
                 description: "PostgreSQL connection URL"

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

### Rake Task Integration

```ruby
# lib/tasks/envalit.rake
namespace :envalit do
  desc "Validate environment variables"
  task validate: :environment do
    Envalit.configure do |config|
      # Production Critical Variables
      if Rails.env.production?
        config.register "DATABASE_URL", required: true, strict: true
        config.register "REDIS_URL", required: true, strict: true
      end

      # Common Variables
      config.register "APP_HOST", required: true
      config.register "PORT", type: :integer, default: 3000
    end

    # Use appropriate validation mode
    if Rails.env.production?
      Envalit.validate!
    else
      Envalit.validate
    end
  end
end
```

### Configuration Options

Each environment variable can be registered with the following options:

- `required: true/false` - Whether the variable must be present
- `strict: true/false` - Raise error instead of warning for missing required variables
- `type: :string/:integer/:boolean/:float` - Variable type validation
- `default: value` - Default value if not set
- `description: "text"` - Documentation for the variable

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bugloper/envalit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
