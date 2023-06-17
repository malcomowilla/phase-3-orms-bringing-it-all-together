



class Dog
  attr_accessor :name, :breed, :id
  def initialize(name:, breed:, id:nil)
    @name = name
    @breed = breed
    @id = id
  end
def self.drop_table
  sql = <<-SQL
    DROP TABLE IF EXISTS dogs
  SQL
  DB[:conn].execute(sql)
end

def self.create_table
  sql=<<-SQL
CREATE TABLE IF NOT EXITS
dogs
(id INTEGER PRIMARY KEY
name TEXT
breed TEXT)
  SQL
  DB[:conn].execute(sql)
end

def save
  sql = <<-SQL
INSERT INTO dogs
(name, breed)
VALUES
(?, ?)
  SQL
  DB[:conn].execute(sql, self.name, self.breed)
  self.id = DB[:conn].execute("SELECT  last_insert_row(id) FROM dogs")[0][0]
  self
end

def create_table(name:, breed:)
  dog = Dog.new(name:name, breed:breed)
  dog.save
end
def self.new_from_db(row)
  self.new(id:row[0], name:row[1], breed:row[2])
  self
end
def self.all
  sql = <<-SQL
SELECT * 
FROM dogs
  SQL
  DB[:conn].execute(sql).map do |row|
    self.new_from_db(row)
  end
end

def self.find_by_name(name)
  sql = <<-SQL
SELECT * 
FROM dogs
WHERE name = ?
LIMIT 
1
SQL
DB[:conn].execute(sql, name).map do |row|
  self.new_from_db(row)
end.first
end

def find(id)
  sql = <<-SQL
SELECT * 
FROM dogs
WHERE id = ?
LIMIT
1
  SQL
  DB[:conn].execute(sql, id).map do |row|
    self.new_from_db(row)
  end.first
end
def self.find_or_create_by(name:, breed:)
  dog = find_name_and_breed(name, breed)
  if dog
    dog
  else
    create_table(name:name, breed:breed)
  end
end


def self.find_name_and_breed(name:, breed:)
 sql = <<-SQL
SELECT * 
FROM dogs
WHERE 
dogs.name = ?
dogs.breed = ?
SQL

DB[:conn].execute(sql, name, breed).map do |row|
  self.new_from_db(row)
end.first
end

def self.update(id:, name:)
  sql = <<-SQL
UPDATE dogs
SET name = ?
WHERE id = ?

  SQL
  DB[:conn].execute(sql, id, name)
end


end






































# class Dog
#   attr_accessor :name, :breed, :id

#   def initialize(name:, breed:, id: nil)
#     @id = id
#     @name = name
#     @breed = breed
#   end

#   def self.create_table
#     sql =  <<-SQL
#       CREATE TABLE IF NOT EXISTS dogs (
#         id INTEGER PRIMARY KEY,
#         name TEXT,
#         breed TEXT
#         )
#     SQL
#     DB[:conn].execute(sql)
#   end

#   def self.drop_table
#     sql = "DROP TABLE IF EXISTS dogs"
#     DB[:conn].execute(sql)
#   end

#   def save
#     if self.id
#       self.update
#     else
#       sql = <<-SQL
#         INSERT INTO dogs (name, breed)
#         VALUES (?, ?)
#       SQL
#       DB[:conn].execute(sql, self.name, self.breed)
#       self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
#     end
#     self
#   end

#   def self.create(name:, breed:)
#     dog = Dog.new(name: name, breed: breed)
#     dog.save
#   end

#   def self.new_from_db(row)
#     self.new(id: row[0], name: row[1], breed: row[2])
#   end

#   def self.all
#     sql = <<-SQL
#       SELECT *
#       FROM dogs;
#     SQL

#     DB[:conn].execute(sql).map do |row|
#       self.new_from_db(row)
#     end
#   end

#   def self.find_by_name(name)
#     sql = <<-SQL
#       SELECT *
#       FROM dogs
#       WHERE dogs.name = ?
#       LIMIT 1;
#     SQL

#     DB[:conn].execute(sql, name).map do |row|
#       self.new_from_db(row)
#     end.first
#   end

#   def self.find(id)
#     sql = <<-SQL
#       SELECT *
#       FROM dogs
#       WHERE dogs.id = ?
#       LIMIT 1;
#     SQL

#     DB[:conn].execute(sql, id).map do |row|
#       self.new_from_db(row)
#     end.first
#   end
# end
