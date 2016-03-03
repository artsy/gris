module Gris
  class SeedLoader
    def initialize(file_path)
      @seed_file = file_path
    end

    def load_seed
      raise("Seed file '#{@seed_file}' does not exist.") unless File.file?(@seed_file)
      load @seed_file
    end
  end
end
