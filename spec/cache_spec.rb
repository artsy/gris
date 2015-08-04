require 'spec_helper'

describe 'Gris.cache' do
  let(:cache) { Gris.cache }

  it 'returns nil by default' do
    expect(cache.read('x')).to be_nil
  end

  it 'permits writing to and retrieving from cache' do
    cache.write('x', 'abc')
    expect(cache.read('x')).to eq('abc')
  end
end
