require 'spec_helper'

describe 'Gris::CacheKey' do
  it 'raises an error when cache_key is called on a blank object' do
    @foo = CacheKeyHelper.new
    expect { @foo.cache_key }.to raise_error(NotImplementedError)
  end

  it 'returns a value for cache_key' do
    @foo = CacheKeyHelper.new(id: SecureRandom.random_number(500))
    expect(@foo.cache_key).to eq("cache_key_helper/#{@foo.id}")
  end

  it 'returns a value for cache_key_for' do
    id = SecureRandom.random_number(500)
    expect(CacheKeyHelper.cache_key_for(id)).to eq("cache_key_helper/#{id}")
  end

  it 'uses the cache for cached_find' do
    id = SecureRandom.random_number(500)
    foo = CacheKeyHelper.cached_find(id)
    expect(foo.id).to eq(id)
    allow(Gris.cache).to receive(:fetch).and_return('cached-result')
    expect(CacheKeyHelper.cached_find(id)).to eq('cached-result')
  end
end
