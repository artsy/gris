require 'spec_helper'

describe 'Gris::Caching' do
  let(:id) { SecureRandom.random_number(500) }

  it 'uses the cache for cached_find' do
    foo = CachingHelper.cached_find(id)
    expect(foo.id).to eq(id)
    allow(Gris.cache).to receive(:fetch).and_return('cached-result')
    expect(CachingHelper.cached_find(id)).to eq('cached-result')
  end

  it 'expires cache for a given id' do
    allow(Gris.cache).to receive(:delete).with("cache_key_helper/#{id}")
    CachingHelper.expire_cache_for(id)
    expect(Gris.cache).to have_received(:delete).with("cache_key_helper/#{id}")
  end

  it 'expires cache for a given instance' do
    allow(Gris.cache).to receive(:delete).with("cache_key_helper/#{id}")
    instance = CachingHelper.new(id: id)
    instance.expire_cache
    expect(Gris.cache).to have_received(:delete).with("cache_key_helper/#{id}")
  end
end
