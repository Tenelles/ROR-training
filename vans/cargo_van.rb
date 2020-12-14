# frozen_string_literal: true

require_relative 'van'

#   Список ошибок:
#     fill_volume: "Недостаточно свободного объема" - попытка занять объем, не имея достаточно свободного объема
#     fill_volume: "Попытка уменьшения объема"
#     validate!: "Отрицательный объем"

class CargoVan < Van
  include InstanceCounter

  attr_reader :volume, :filled_volume

  def initialize(volume)
    super
    @volume = volume
    @filled_volume = 0
    validate!
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  def type
    :cargo
  end

  def fill_volume(volume)
    raise 'Попытка уменьшения объема' if volume.negative?
    raise 'Недостаточно свободного объема' if volume > free_volume

    self.filled_volume += volume
  end

  def free_volume
    volume - filled_volume
  end

  protected

  attr_writer :volume, :filled_volume

  def validate!
    raise 'Отрицательный объем' if volume.negative?
  end
end
