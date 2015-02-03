require 'spec_helper'
require 'gris/generators/migration_generator'
require 'gris/cli'

describe Gris::Generators::MigrationGenerator do
  include_context 'with generator'
  let(:migration_filename) { 'foo' }

  before do
    allow_any_instance_of(described_class).to receive(:migration_filename).and_return(migration_filename)
  end

  describe 'AddFooToBar flew:string:index brew:integer' do
    before do
      Gris::CLI::Base.new.generate('migration', 'AddFooToBar', 'flew:string:index', 'brew:integer')
      expected_migration_file = File.join(generator_tmp_directory, 'foo.rb')
      @migration_code = File.read(expected_migration_file)
    end

    it 'creates a camelized migration class' do
      expect(@migration_code).to match(/class AddFooToBar/)
    end

    it 'adds the columns' do
      expect(@migration_code).to match(/add_column :bars, :flew, :string/)
      expect(@migration_code).to match(/add_column :bars, :brew, :integer/)
    end

    it 'adds the index on the correct column' do
      expect(@migration_code).to match(/add_index :bars, :flew/)
    end
  end

  describe 'RemoveFooFromBar flew:string brew:integer' do
    before do
      Gris::CLI::Base.new.generate('migration', 'RemoveFooFromBar', 'flew:string', 'brew:integer')
      expected_migration_file = File.join(generator_tmp_directory, 'foo.rb')
      @migration_code = File.read(expected_migration_file)
    end

    it 'creates a camelized migration class' do
      expect(@migration_code).to match(/class RemoveFooFromBar/)
    end

    it 'removes the columns' do
      expect(@migration_code).to match(/remove_column :bars, :flew, :string/)
      expect(@migration_code).to match(/remove_column :bars, :brew, :integer/)
    end
  end

  describe 'CreateJoinTableFooBar foo bar' do
    before do
      Gris::CLI::Base.new.generate('migration', 'CreateJoinTableFooBar', 'foo', 'bar')
      expected_migration_file = File.join(generator_tmp_directory, 'foo.rb')
      @migration_code = File.read(expected_migration_file)
    end

    it 'creates a camelized migration class' do
      expect(@migration_code).to match(/class CreateJoinTableFooBar/)
    end

    it 'creates the join table' do
      expect(@migration_code).to match(/create_join_table :foos, :bars/)
    end

    it 'adds placeholders for the indexing' do
      expect(@migration_code).to match(/# t.index \[:foo_id, :bar_id\]/)
      expect(@migration_code).to match(/# t.index \[:bar_id, :foo_id\]/)
    end
  end

  describe 'CreateSkrillex drops:integer hair:string:index' do
    before do
      Gris::CLI::Base.new.generate('migration', 'CreateSkrillex', 'drops:integer', 'hair:string:index')
      expected_migration_file = File.join(generator_tmp_directory, 'foo.rb')
      @migration_code = File.read(expected_migration_file)
    end

    it 'creates a camelized migration class' do
      expect(@migration_code).to match(/class CreateSkrillex/)
    end

    it 'creates the table' do
      expect(@migration_code).to match(/create_table :skrillexes/)
    end

    it 'adds the columns' do
      expect(@migration_code).to match(/t.integer :drops/)
      expect(@migration_code).to match(/t.string :hair/)
    end

    it 'adds the index on the correct column' do
      expect(@migration_code).to match(/add_index :skrillexes, :hair/)
    end
  end
end
