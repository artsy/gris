require 'spec_helper'

describe 'Gris.cache' do
  before(:each) do
    @cache = Gris.cache
  end

  it 'caches things' do
    expect(@cache.read('x')).to be_nil
    @cache.write('x', 'abc')
    expect(@cache.read('x')).to eq('abc')
  end
end
