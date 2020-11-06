# frozen_string_literal: true
require_relative 'train'

class PassengerTrain < Train
  include InstanceCounter
  def type # public, как у родителя
    :passenger
  end
end
