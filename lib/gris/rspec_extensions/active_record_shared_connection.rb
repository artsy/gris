module ActiveRecord
  class Base
    mattr_accessor :shared_connection
    self.shared_connection = nil

    def self.connection
      shared_connection || retrieve_connection
    end
  end
end

# Force all threads to share the same connection.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
