module Validation

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    
    def validate(name, validation_type, *args)
      self.validates ||= []
      self.validates << [validation_type, name, args]
    end

  	attr_accessor :validates
  end

  module InstanceMethods
    
    def validate_precence(var)
      raise "#{var} is nil" if instance_variable_get("@#{var}".to_sym).nil?
      raise "#{var} is empty" if instance_variable_get("@#{var}".to_sym) == ''
    end

    def validate_format(var,mask)
      raise "#{var} is incorrect" unless instance_variable_get("@#{var}".to_sym) =~ Regexp.new(mask)
    end

    def validate_type(var,type)
      raise "#{var} is not #{type}" unless instance_variable_get("@#{var}".to_sym).is_a?(type)
    end

   	def validate!
   	  return if self.class.validates.nil?
   	  self.class.validates.each do |args|
      	  send "validate_#{args[0]}", args[1], *args[2]

   	  rescue => e
   	  	raise "#{args[0]}:#{args[1]} didn't validate: #{e.inspect}"
   	  end
   	end

   	def valid?
   	  validate!
   	  true
   	rescue
   	  false
   	end
   
  end

end