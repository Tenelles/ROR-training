# frozen_string_literal: true
require_relative 'van'

class CargoVan < Van
  include InstanceCounter
  def type # public, как у родителя
    :cargo
  end
end
