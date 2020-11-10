# frozen_string_literal: true

require_relative 'van'

=begin
	Список ошибок:
		fill_volume: "Недостаточно свободного объема" - попытка занять объем, не имея достаточно свободного объема
		fill_volume: "Попытка уменьшения объема"
		validate!: "Отрицательный объем"
=end

class CargoVan < Van
  include InstanceCounter

  attr_reader :volume
  attr_reader :filled_volume

  def initialize(volume)
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
  	raise 'Попытка уменьшения объема' if volume < 0
  	raise 'Недостаточно свободного объема' if volume > free_volume
  	self.filled_volume += volume
  end

  def free_volume
  	volume - filled_volume
  end

  protected

  attr_writer :volume
  attr_writer :filled_volume

  def validate!
  	raise 'Отрицательный объем' if volume < 0
  end

end
