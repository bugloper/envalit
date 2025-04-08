# frozen_string_literal: true

require_relative "envalit/version"
require_relative "envalit/loader"
require_relative "envalit/railtie" if defined?(Rails)

# Envalit is a Ruby gem for managing and validating environment variables.
#
# It provides a simple and flexible way to:
# - Register environment variables with validation rules
# - Set default values for optional variables
# - Validate variable types (string, integer, boolean, float)
# - Control validation behavior (warnings vs. strict errors)
# - Load variables from .env files
#
# @example Basic usage
#   Envalit.configure do |config|
#     config.register "DATABASE_URL",
#                    required: true,
#                    strict: true
#
#     config.register "PORT",
#                    type: :integer,
#                    default: 3000
#   end
#
#   Envalit.validate # Validates all registered variables
#
# @example Type validation
#   Envalit.configure do |config|
#     config.register "DEBUG_MODE",
#                    type: :boolean,
#                    default: false
#
#     config.register "API_TIMEOUT",
#                    type: :float,
#                    required: true
#   end
#
# @see Envalit::Loader for detailed implementation
module Envalit
  class << self
    # Configures Envalit with the given block.
    #
    # @yield [self] Yields self for configuration
    # @return [void]
    def configure
      @loader ||= Loader.new(Dir.pwd)
      yield(self)
    end

    # Registers an environment variable with validation options.
    #
    # @param key [String] The environment variable name
    # @param options [Hash] The validation options
    # @option options [Boolean] :required Whether the variable is required
    # @option options [Boolean] :strict Raise error instead of warning for missing required variables
    # @option options [Symbol] :type The variable type (:string, :integer, :boolean, :float)
    # @option options [Object] :default The default value if variable is not set
    # @option options [String] :description Description of the variable's purpose
    # @return [void]
    def register(key, options = {})
      @loader.register(key, options)
    end

    # Validates all registered environment variables.
    # Missing required variables will trigger warnings unless they are marked as strict.
    #
    # @raise [ValidationError] If a strict required variable is missing
    # @return [void]
    def validate
      @loader.validate
    end

    # Validates all registered environment variables in strict mode.
    # All missing required variables will raise an error, regardless of their strict setting.
    #
    # @raise [ValidationError] If any required variable is missing
    # @return [void]
    def validate!
      @loader.validate!
    end
  end
end
