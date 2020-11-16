module Validation

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    
    def validate(name, validation_type, *args)
      raise TypeError unless name.is_a?(Symbol)
      raise TypeError unless validation_type.is_a?(Symbol)
      self.validates ||= []
      self.validates << [name, validation_type, args]
      method_name = "validate_#{name}_#{validation_type}".to_sym
      case validation_type
      when :precence
        define_method(method_name) do
          raise "#{name} is nil" if instance_variable_get("@#{name}".to_sym).nil?
          raise "#{name} is empty" if instance_variable_get("@#{name}".to_sym) == ''
      	end
      when :format
        define_method(method_name) do |mask|
          raise "#{name} is incorrect" unless instance_variable_get("@#{name}".to_sym) =~ mask
      	end
      when :type
        define_method(method_name) do |type|
          raise "#{name} is not #{args[0]}" unless instance_variable_get("@#{name}".to_sym).is_a?(type)
      	end
      end
    end

  	attr_accessor :validates
  end

  module InstanceMethods
    
   	def validate!
   	  return if self.class.validates.nil?
   	  self.class.validates.each do |args|
   	  	if args[2] == [] || args[2].nil?
   	  		eval("validate_#{args[0]}_#{args[1]}") 
   	  	else
   	  		eval("validate_#{args[0]}_#{args[1]}(#{args[2].join(", ")})")
   	  	end

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