require 'spec_helper'
require 'gris/grape_extensions/date_time_helpers'

describe Gris::DateTimeHelpers do
  before do
    @helper = Class.new do
      include Gris::DateTimeHelpers
    end.new
  end

  it 'parses a date string' do
    MY_TIME = '2011-01-02 17:00:23 UTC'.freeze
    actual = @helper.string_to_datetime(MY_TIME)
    expect(actual.to_s).to eq(MY_TIME)
  end

  it 'converts seconds since epoch' do
    SECONDS = '1429823204'.freeze
    actual = @helper.string_to_datetime(SECONDS)
    expect(actual).to eq(Time.at(SECONDS.to_i))
  end

  it "returns '' for a blank string" do
    expect(@helper.string_to_datetime('')).to eq('')
  end

  it 'returns nil for a nil string' do
    expect(@helper.string_to_datetime(nil)).to be_nil
  end

  it 'sets the keys to be converted' do
    @helper.datetime_params :created_at, :updated_at
    expect(@helper.keys_to_convert).to eq(Set.new([:created_at, :updated_at]))
  end

  it 'converts the correct keys' do
    @helper.datetime_params :created_at, :updated_at
    params = { message: 'hi', created_at: 1_293_901_200, updated_at: 1_325_397_600 }
    @helper.process_datetime_params(params)
    expect(params[:message]).to eq('hi')
    expect(params[:created_at].strftime).to eq('2011-01-01T17:00:00+00:00')
    expect(params[:updated_at].strftime).to eq('2012-01-01T06:00:00+00:00')
  end
end
