# frozen_string_literal: true

require_relative '../company'
require_relative '../instance_counter'
require_relative '../accessors'

class Van
  include Company
  include InstanceCounter
  include Accessors

  def initialize
    register_instance
  end

  def type; end
end
