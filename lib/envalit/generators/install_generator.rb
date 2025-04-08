# frozen_string_literal: true

require "rails/generators"

module Envalit
  module Generators
    # Generator for installing Envalit configuration files in a Ruby/Rails application.
    #
    # This generator creates:
    # - An initializer file with example environment variable configurations
    # - A .env.example file with sample environment variable values
    #
    # @example Installing via Rails generator
    #   rails generate envalit:install
    #
    # @example Installing via Rake task
    #   rake envalit:install
    #
    # The generated files provide a starting point for:
    # - Configuring required environment variables
    # - Setting up type validations
    # - Defining default values
    # - Documenting environment requirements
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      desc "Creates an Envalit initializer for your application"

      # Copies the Envalit initializer template to the application.
      #
      # Creates a new initializer file at config/initializers/envalit.rb
      # with example configurations for common environment variables.
      #
      # @return [void]
      def copy_initializer
        template "envalit.rb", "config/initializers/envalit.rb"
      end

      # Copies the example environment file template.
      #
      # Creates a .env.example file in the application root
      # with sample values matching the initializer configuration.
      #
      # @return [void]
      def copy_example_env
        template "example.env", ".env.example"
      end
    end
  end
end
