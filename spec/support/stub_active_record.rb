module ActiveRecord
  class RecordNotFound < StandardError
  end

  class Migrator
    class_attribute :current_version
    self.current_version = 'awww-yeah'
  end
end
