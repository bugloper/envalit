# frozen_string_literal: true

require "rails/generators"

module Envalit
  class Railtie < Rails::Railtie # rubocop:disable Style/Documentation
    generators do
      require_relative "generators/install_generator"
      Rails::Generators.hide_namespaces "envalit"
      Rails::Generators::Base.include Envalit::Generators
    end
  end
end
