# frozen_string_literal: true

RSpec.describe RequireBench do
  it 'has a version number' do
    expect(RequireBench::VERSION).not_to be nil
  end

  it 'does not break require' do
    # date is not already loaded!
    expect(require('date')).to eq(true)
    expect(Date.new(2018, 12, 15)).to be_a(Date)
  end

  context 'TIMINGS' do
    it 'tracks' do
      # rspec is already loaded!
      expect(RequireBench::TIMINGS).to have_key('rspec')
      # set is already loaded!
      expect(require('set')).to eq(false)
      expect(RequireBench::TIMINGS).to have_key('set')
      expect(RequireBench::TIMINGS['set']).to be_a(Float)
      expect(RequireBench::TIMINGS['rspec']).to be_a(Float)
    end
  end
end
