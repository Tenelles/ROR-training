# frozen_string_literal: true

require_relative 'van'

class PassengerVan < Van
  include InstanceCounter
  def type
    :passenger
  end
end
