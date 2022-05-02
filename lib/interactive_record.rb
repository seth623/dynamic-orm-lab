require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'pry'

class InteractiveRecord 

    def col_names_for_insert
        self.class.column_names.delete_if{ |c| c == "id" }.join(", ")
    end 

    def save

        sql = <<-SQL
        INSERT INTO #{self.table_name_for_insert} 
        (#{self.col_names_for_insert}) 
        VALUES (#{self.values_for_insert});
        SQL
         
        DB[:conn].execute(sql)

        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{self.table_name_for_insert};")[0][0]

    end 

    def self.column_names

        DB[:conn].results_as_hash = true

        sql = "PRAGMA table_info('#{self.table_name}')"

        hash_array = DB[:conn].execute(sql)

        columns = hash_array.map { |i| i["name"] }

        columns.compact
        
    end

    def self.find_by(attribute_hash)

        value = attribute_hash.values.first
        
        formatted_value = value.class == Fixnum ? value : "'#{value}'"
        
        sql = "SELECT * FROM #{self.table_name} WHERE #{attribute_hash.keys.first} = #{formatted_value}"
        
        DB[:conn].execute(sql)

      end 

    def self.find_by_name(name)
        
        sql = "SELECT * FROM #{self.table_name} WHERE name == ?;"

        DB[:conn].execute(sql, name)

    end 

    def self.table_name
        self.to_s.downcase.pluralize
    end

    def table_name_for_insert
        self.class.table_name
    end 

    def values_for_insert

        values = []

        self.class.column_names.each do |col_name|
            values << "'#{send(col_name)}'" unless send(col_name).nil?
        end 

        values.join(", ")

    end 
  
end