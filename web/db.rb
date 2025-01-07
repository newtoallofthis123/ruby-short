# frozen_string_literal: true

require 'sqlite3'

# Db Stuff
class Db
  def initialize(name = 'exp.db')
    @name = name
    @db = SQLite3::Database.new @name
    prepare
  end

  def prepare
    @db.execute <<-SQL
    create table if not exists urls (
      id text primary key,
      url text,
      created_at text
    );
    SQL
  end

  def insert(id, url, created_at = Time.now)
    @db.execute('insert into urls (id, url, created_at) VALUES (?, ?, ?);', [id, url, created_at])
    id
  end

  def get(id)
    res = @db.execute("select * from urls where id = '#{id}';")
    return false if res.empty?

    res[0]
  end
end
