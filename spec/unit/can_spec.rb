# coding: utf-8

require 'spec_helper'

RSpec.describe Necromancer, 'can?' do
  it "checks if conversion is possible" do
    converter = described_class.new
    expect(converter.can?(:string, :integer)).to eq(true)
    expect(converter.can?(:unknown, :integer)).to eq(false)
  end
end
