# frozen_string_literal: true

require_relative 'van'

class CargoVan < Van
  include InstanceCounter
  def type
    :cargo
  end
end
