# frozen_string_literal: true

require_relative 'train'

class CargoTrain < Train
  def type # public, как у родителя
    :cargo
  end
end
