require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'interactive_record.rb'

class Student < InteractiveRecord

    self.column_names.each do |c|
        attr_accessor c.to_sym
    end

    def initialize(args = {})
        
        args.each do |property, value|
            self.send("#{property}=", value)
        end 

    end 

end
