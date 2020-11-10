# frozen_string_literal: true

#   Список ошибок:
#     add_station: "Добавление уже существующей станции" - попытка добавить станцию, которая уже есть в маршруте
#     remove_station: "Удаление несуществующей станции" - попытка удалить станцию, которая нет в маршруте
#     validate!: "Одинаковые начальная и конечная станции" - машрут не может состоять из одной станции

class Route
  attr_reader :start_station, :finish_station

  def initialize(start_station, finish_station)
    @start_station = start_station
    @finish_station = finish_station
    @intermediate_stations = []
    validate!
  end

  def valid?
    validate!
    true
  rescue RuntimeError
    false
  end

  def add_station(station)
    raise 'Добавление уже существующей станции' if stations.include?(stations)

    intermediate_stations << station
  end

  def remove_station(station)
    raise 'Удаление несуществующей станции' if intermediate_stations.delete(station)
  end

  def stations
    [start_station, *@intermediate_stations, finish_station]
  end

  protected

  attr_writer :start_station, :finish_station
  attr_accessor :intermediate_stations

  def validate!
    raise 'Одинаковые начальная и конечная станции' if start_station == finish_station
  end
end
