# frozen_string_literal: true

RSpec.describe RequireBench do
  subject(:version) { described_class::VERSION }
  it 'is not nil' do
    expect(version).not_to be nil
  end

  it 'has a number' do
    expect(version).to match(/\A\d+\.\d+\.\d+-?\w*\z/)
  end
end
