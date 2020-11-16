# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      raise TypeError unless name.is_a?(Symbol)

      var_name = "@#{name}".to_sym
      var_history_name = "#{var_name}_history".to_sym
      define_singleton_method("#{name}_history".to_sym) { instance_variable_get(var_history_name) }
      define_singleton_method(name) { instance_variable_get(var_name) }
      define_singleton_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        history = instance_variable_get(var_history_name)
        history ||= []
        history << value
        instance_variable_set(var_history_name, history)
      end
    end
  end

  def strong_attr_accessor(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      self.class.define_method(name) { instance_variable_get(var_name) }
      self.class.define_method("#{name}_set".to_sym) do |value, type|
        raise ArgumentError unless value.is_a?(type)

        instance_variable_set(var_name, value)
      end
    end
  end
end
