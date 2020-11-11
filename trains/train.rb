# frozen_string_literal: true

require_relative '../company'
require_relative '../instance_counter'

#   Список ошибок:
#     attach: "Несоответствие типов вагона и поезда" - попытка присоединить к поезду вагон иного типа
#     attach, detach: "Управление вагоном движущегося поезда" - попытка присоединить/отсоединить вагон от движущегося поезда
#     detach: "Удаление несуществующего вагона" - попытка отцепить вагон, когда в поезде нет вагонов
#     move_forward, move_back, next_n_stations: "Отсутствует маршрут" - попытка взаимодействовать с отсутствующим маршрутом
#     move_forward, move_back: "Движение невозможно" - попытка движения по маршруту за пределы этого маршрута
#     validate_number!: "Неверный формат номера" - формат номера кода не соответствует условию

class Train
  include Company
  include InstanceCounter

  def self.find(number)
    objects.find { |train| train.number == number }
  end

  attr_reader :number
  attr_reader :vans

  def initialize(number)
    @number = number
    @speed = 0
    @vans = []
    register_instance
    self.class.objects << self
    validate!
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  def for_van(&block)
    vans.each { |van| block.call(van)}
  end

  def increase_speed(value)
    self.speed += value
  end

  def stop
    self.speed = 0
  end

  def attach(van)
    raise 'Несоответствие типов вагона и поезда' unless van.type == type
    raise 'Управление вагоном движущегося поезда' unless speed.zero?

    vans << van
  end

  def detach
    raise 'Управление вагоном движущегося поезда' unless speed.zero?
    raise 'Удаление несуществующего вагона' unless vans_count.positive?

    vans.pop
  end

  def vans_count
    vans.size
  end

  def choose_route(chosen_route)
    self.route = chosen_route
    self.station = route.stations[0]
    station.take_train(self)
  end

  def on_route?
    !route.nil?
  end

  def move_forward
    raise 'Отсутствует маршрут' unless on_route?
    raise 'Движение невозможно' if next_station.nil?

    station.send_train(self)
    self.station = next_station
    station.take_train(self)
  end

  def move_back
    raise 'Отсутствует маршрут' unless on_route?
    raise 'Движение невозможно' if prev_station.nil?

    station.send_train(self)
    self.station = prev_station
    station.take_train(self)
  end

  def current_station
    next_n_station(0)
  end

  def next_station
    next_n_station(1)
  end

  def prev_station
    next_n_station(-1)
  end

  def type; end

  protected

  @@objects = []
  class << self
    def objects
      [] if @@objects.nil?
      @@objects
    end
  end

  def validate!
    validate_number!
  end

  def validate_number!
    raise 'Неверный формат номера' unless number.downcase =~ correct_number_mask
  end

  def correct_number_mask
    /[[0-9][a-z]]{3}-?[[0-9][a-z]]{3}/
  end

  attr_writer :number, :vans
  attr_accessor :speed, :route, :station

  def next_n_station(n)
    raise 'Отсутствует маршрут' unless on_route?

    station_index = route.stations.index(station)
    if station_index.nil?
      station_index = if n >= 0
                        0
                      else
                        route.stations.size - 1
                      end
    end
    index = station_index + n
    return unless (0...route.stations.size).include?(index)

    route.stations[index]
  end
end
