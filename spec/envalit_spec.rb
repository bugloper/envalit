# frozen_string_literal: true

require "spec_helper"

RSpec.describe Envalit do
  it "has a version number" do
    expect(Envalit::VERSION).not_to be nil
  end

  it "exposes the Loader class" do
    expect(Envalit::Valitator).to be_a(Class)
  end
end
