# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances
      instances_count
    end

    def add_instance
      self.instances_count ||= 0
      puts 's'
      self.instances_count += 1
    end

    protected

    attr_accessor :instances_count
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.add_instance
    end
  end
end
