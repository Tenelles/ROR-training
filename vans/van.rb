# frozen_string_literal: true
require_relative '../company'

class Van
  include Company
  include InstanceCounter
  
  def initialize
    register_instance
  end
  def type; end
end
