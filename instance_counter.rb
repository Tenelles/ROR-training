module InstanceCounter

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
    base.instances_count = 0
  end

  def self.ancestors
    instances_count = 0
  end

  module ClassMethods
    def instances
      self.instances_count
    end
    attr_accessor :instances_count
  end

  module InstanceMethods
    protected
    def register_instance
      self.class.instances_count += 1
    end
  end
  
  
end