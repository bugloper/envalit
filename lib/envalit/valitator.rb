# frozen_string_literal: true

require "dotenv"

module Envalit
  # The Loader class handles environment variable registration, validation, and type checking.
  #
  # This class is responsible for:
  # - Managing the schema of environment variables
  # - Loading variables from .env files
  # - Validating variable presence and types
  # - Handling default values
  # - Providing warnings or errors for missing variables
  #
  # @example Basic usage with type validation
  #   loader = Loader.new(Rails.root)
  #   loader.register("PORT", type: :integer, default: 3000)
  #   loader.register("DEBUG", type: :boolean, default: false)
  #   loader.validate
  #
  # @example Strict validation with required variables
  #   loader = Loader.new(Dir.pwd)
  #   loader.register("API_KEY", required: true, strict: true)
  #   loader.register("API_URL", required: true)
  #   # Will raise ValidationError if API_KEY is missing
  #   # Will warn if API_URL is missing
  #   loader.validate
  #
  # @api private
  class Valitator
    # Valid types for environment variables
    VALID_TYPES = %i[string integer boolean float].freeze

    # ANSI color codes for error formatting
    ERROR_COLOR = "\e[1;91m" # bright red and bold
    RESET_COLOR = "\e[0m"
    HIGHLIGHT_COLOR = "\e[1m" # bold

    # Initializes a new Loader instance.
    #
    # @param app_root [String] The root directory path where .env files are located
    # @param app_root [String, nil] The root directory path where .env files are located. Defaults to Dir.pwd
    def initialize(app_root = Dir.pwd)
      @app_root      = app_root
      @schema        = {}
      @dotenv_loaded = false
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
    #
    # @raise [ArgumentError] If an invalid type is specified
    # @return [void]
    def register(key, options = {})
      validate_options(options)
      set_default_value(key, options[:default]) if options.key?(:default)
      @schema[key] = options
    end

    # Validates all registered environment variables.
    #
    # This method:
    # - Loads variables from .env file if not already loaded
    # - Checks for missing required variables
    # - Validates variable types
    # - Raises errors for strict violations
    # - Warns about non-strict violations
    #
    # @param strict [Boolean] Whether to enforce strict mode for all required variables
    # @raise [ValidationError] If a strict required variable is missing
    # @raise [ValidationError] If a variable's value doesn't match its specified type
    # @return [void]
    def validate(strict: false)
      load_dotenv unless @dotenv_loaded
      check_missing_variables(strict)
      check_invalid_types
    end

    # Validates all registered environment variables in strict mode.
    # All missing required variables will raise an error, regardless of their strict setting.
    #
    # @raise [ValidationError] If any required variable is missing
    # @return [void]
    def validate!
      validate(strict: true)
    end

    # Loads environment variables from a .env file.
    #
    # @return [void]
    def load
      load_dotenv
    end

    private

    # Validates the options passed to register.
    #
    # @param options [Hash] The options to validate
    # @raise [ArgumentError] If an invalid type is specified
    # @return [void]
    def validate_options(options)
      type = options[:type]
      return unless type

      normalized_type = type.to_s.downcase.to_sym
      return if VALID_TYPES.include?(normalized_type)

      raise ArgumentError,
            "#{ERROR_COLOR}Invalid type: #{type}. Valid types are: #{VALID_TYPES.join(', ')}#{RESET_COLOR}"
    end

    # Sets the default value for an environment variable if it's not already set.
    #
    # @param key [String] The environment variable name
    # @param default [Object] The default value
    # @return [void]
    def set_default_value(key, default)
      return if ENV.key?(key)

      case default
      when true, false
        default.to_s
      end
      ENV[key] = default.to_s
    end

    # Checks for missing required variables and handles them according to their strict setting.
    #
    # @param strict [Boolean] Whether to enforce strict mode for all required variables
    # @return [void]
    def check_missing_variables(strict = false) # rubocop:disable Style/OptionalBooleanParameter
      missing_vars = @schema.select { |key, opts| opts[:required] && ENV[key].nil? }
      return if missing_vars.empty?

      message = "#{ERROR_COLOR}Missing required environment variables:#{RESET_COLOR}\n"
      missing_vars.each do |key, opts|
        message += "#{HIGHLIGHT_COLOR}  - #{key}#{RESET_COLOR}\n"
        message += "    Type: #{opts[:type]}\n" if opts[:type]
        message += "    Description: #{opts[:description]}\n" if opts[:description]
      end

      message += "\n#{HIGHLIGHT_COLOR}To fix this:#{RESET_COLOR}\n"
      message += "1. Create a .env file in your project root if it doesn't exist\n"

      if File.exist?(".env.example")
        message += "2. Copy values from .env.example to your .env file:\n"
        message += "   #{HIGHLIGHT_COLOR}cp .env.example .env#{RESET_COLOR}\n"
        message += "3. Update the values in your .env file with your actual configuration"
      else
        message += "2. Add the missing variables to your .env file:\n"
        missing_vars.each_key do |key|
          message += "   #{HIGHLIGHT_COLOR}#{key}=your_#{key.downcase}_here#{RESET_COLOR}\n"
        end
      end

      raise ValidationError, message if strict || missing_vars.any? { |_, opts| opts[:strict] }

      warn message
    end

    # Validates the types of all environment variables against their schema.
    #
    # @raise [ValidationError] If a variable's value doesn't match its specified type
    # @return [void]
    def check_invalid_types
      invalid_vars = @schema.select do |key, opts|
        next false if ENV[key].nil? || !opts[:type]

        type = opts[:type].to_s.downcase.to_sym
        case type
        when :integer
          !ENV[key].match?(/\A-?\d+\z/)
        when :float
          !ENV[key].match?(/\A-?\d*\.?\d+\z/)
        when :boolean
          !%w[true false].include?(ENV[key].downcase)
        else
          false
        end
      end

      return if invalid_vars.empty?

      key, opts = invalid_vars.first
      raise ValidationError, "#{ERROR_COLOR}Invalid type for #{key}: expected #{opts[:type]}#{RESET_COLOR}"
    end

    # Loads environment variables from a .env file.
    #
    # @return [void]
    def load_dotenv
      dotenv_path = File.join(@app_root, ".env")
      Dotenv.load(dotenv_path) if File.exist?(dotenv_path)
      @dotenv_loaded = true
    end
  end

  # Error raised when environment variable validation fails
  class ValidationError < StandardError; end
end
