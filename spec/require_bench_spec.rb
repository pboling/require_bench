# frozen_string_literal: true

RSpec.describe RequireBench do
  let(:skipped_library) { 'cmath'}
  let(:logged_library) { 'date'}
  let(:other_library) { 'forwardable' }
  let(:req) { require(library) }
  let(:quiet_req) { quietly { require(library) } }
  let(:log_match) { /\[RequireBench\]\s+\d\.\d+ #{library}/i }

  it 'has a version number' do
    expect(RequireBench::VERSION).not_to be nil
  end

  # These specs will test the results of requiring three classes that are not loaded by default:
  #   Set, Date, Forwardable, and OpenStruct
  after do
    Object.send(:remove_const, :CMath) rescue NameError
    Object.send(:remove_const, :Date) rescue NameError
    Object.send(:remove_const, :Forwardable) rescue NameError
    Object.send(:remove_const, :OpenStruct) rescue NameError
  end

  context 'when skipped' do
    let(:library) { skipped_library }
    it 'does not break require' do
      quiet_req
      expect(CMath.sqrt(9)).to eq(3)
    end

    it 'does not log require' do
      output = capture(:stdout) { req }
      expect(output).not_to match(log_match)
    end

    it 'does track timings of other libraries' do
      quietly { require other_library }
      expect(RequireBench::TIMINGS).to have_key(other_library)
    end

    it 'tracks timing of other libraries as a Float' do
      quietly { require other_library }
      expect(RequireBench::TIMINGS[other_library]).to be_a(Float)
    end

    it 'does not track timings of skipped library' do
      quiet_req
      expect(RequireBench::TIMINGS).not_to have_key(library)
    end
  end

  context 'when not skipped' do
    let(:library) { logged_library }
    it 'does not break require' do
      quiet_req
      expect(Date.new(2018, 12, 15)).to be_a(Date)
    end

    it 'does log require' do
      output = capture(:stdout) { req }
      expect(output).to match(log_match)
    end

    it 'does track timings' do
      quiet_req
      expect(RequireBench::TIMINGS).to have_key(logged_library)
    end

    it 'tracks timing as a Float' do
      expect(RequireBench::TIMINGS[logged_library]).to be_a(Float)
    end
  end
end
