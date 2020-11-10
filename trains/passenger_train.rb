# frozen_string_literal: true

require_relative 'train'

class PassengerTrain < Train
  def type
    :passenger
  end
end
