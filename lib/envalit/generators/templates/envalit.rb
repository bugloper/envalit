# frozen_string_literal: true

# Envalit Configuration
# This file contains the configuration for your environment variables.
# You can specify requirements, types, and other validations for each variable.

Envalit.configure do |config|
  # # Database Configuration
  # config.register "DATABASE_URL",
  #                 required: true,
  #                 strict: true, # Will raise an error if missing
  #                 description: "PostgreSQL connection URL"

  # # Application Settings
  # config.register "APP_HOST",
  #                 required: true,
  #                 default: "localhost",
  #                 description: "Application host name"

  # config.register "PORT",
  #                 required: true,
  #                 type: :integer,
  #                 default: 3000,
  #                 description: "Port number for the application"

  # # API Keys and Secrets
  # config.register "SECRET_KEY_BASE",
  #                 required: true,
  #                 strict: true,
  #                 description: "Rails secret key base"

  # config.register "API_KEY",
  #                 required: false, # Optional variable
  #                 description: "External API key"

  # # Feature Flags
  # config.register "ENABLE_FEATURE_X",
  #                 type: :boolean,
  #                 default: false,
  #                 description: "Enable experimental feature X"

  # # Email Configuration
  # config.register "SMTP_SERVER",
  #                 required: true,
  #                 description: "SMTP server hostname"

  # config.register "SMTP_PORT",
  #                 required: true,
  #                 type: :integer,
  #                 default: 587,
  #                 description: "SMTP server port"

  # # Cache Configuration
  # config.register "REDIS_URL",
  #                 required: false,
  #                 default: "redis://localhost:6379/0",
  #                 description: "Redis connection URL"

  # Add your own environment variables here
  # Example:
  # config.register "YOUR_ENV_VAR",
  #                required: true|false,
  #                strict: true|false,
  #                type: :string|:integer|:boolean|:float,
  #                default: "default_value",
  #                description: "Description of the variable"
end

# Validate environment variables based on environment
if Rails.env.production?
  # In production, use validate! to ensure all required variables are present
  Envalit.validate!
else
  # In development and test, use validate to warn about missing variables
  Envalit.validate
end
