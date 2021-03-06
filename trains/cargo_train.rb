# frozen_string_literal: true

require_relative 'train'

class CargoTrain < Train

  validate :number, :precence
  validate :number, :type, String
  validate :number, :format, /\A[[0-9]|[a-z]]{3}-?[[0-9]|[a-z]]{3}\z/

  def type
    :cargo
  end
end
