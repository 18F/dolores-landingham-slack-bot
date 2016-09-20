module MigrationHelperMethods
  def execute(*args)
    ActiveRecord::Base.connection.execute(*args)
  end

  def insert(*args)
    ActiveRecord::Base.connection.insert(*args)
  end

  def sanitize(*args)
    ActiveRecord::Base.sanitize(*args)
  end
end
