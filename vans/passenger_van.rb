# frozen_string_literal: true

require_relative 'van'

=begin
	Список ошибок:
		take_place: "Недостаточно свободных мест" - попытка занять место, когда все занято
		validate: "Отрицательное число мест"
=end

class PassengerVan < Van
  include InstanceCounter

  attr_reader :places_count
  attr_reader :free_places_count

  def initialize(count)
  	@places_count = count;
  	@free_places_count = count;
  	validate!
  end

  def valid?
  	validate!
  	true
  rescue RuntimeError
  	false
  end

  def type
    :passenger
  end

  def take_place
  	raise "Недостаточно свободных мест" if free_places_count <= 0
  	self.free_places_count -= 1;
  end

  def taken_places_count
  	places_count - free_places_count;
  end

  protected

  def validate!
  	raise "Отрицательное число мест" if places_count < 0;

  attr_writer :places_count
  attr_writer :free_places_count
end
