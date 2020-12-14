# frozen_string_literal: true

require_relative 'van'

#   Список ошибок:
#     take_place: "Недостаточно свободных мест" - попытка занять место, когда все занято
#     validate: "Отрицательное число мест"

class PassengerVan < Van
  include InstanceCounter

  attr_reader :places_count, :free_places_count

  def initialize(count)
    super
    @places_count = count
    @free_places_count = count
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
    raise 'Недостаточно свободных мест' if free_places_count <= 0

    self.free_places_count -= 1
  end

  def taken_places_count
    places_count - free_places_count
  end

  protected

  def validate!
    raise 'Отрицательное число мест' if places_count.negative?
  end

  attr_writer :places_count, :free_places_count
end
