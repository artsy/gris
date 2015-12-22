require 'spec_helper'

describe Gris::SeedLoader do
  context '#load_seed' do
    context 'without an existing seed file' do
      let(:loader) { Gris::SeedLoader.new('blah') }

      it 'raises a RuntimeError' do
        expect do
          loader.load_seed
        end.to raise_error(RuntimeError, "Seed file 'blah' does not exist.")
      end
    end

    context 'with an existing seed file' do
      include_context 'with a generated app'
      let(:loader) { Gris::SeedLoader.new('my_test_app/db/seeds.rb') }

      it 'does not raise an error' do
        expect do
          loader.load_seed
        end.to_not raise_error
      end
    end
  end
end
