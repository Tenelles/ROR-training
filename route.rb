class Route
  # Станции в составе маршрута вполне используются в других методах
  attr_reader :start_station
  attr_reader :finish_station, :intermediate_stations

  def initialize(start_station, finish_station)
    @start_station = start_station
    @finish_station = finish_station
    @intermediate_stations = []
  end

  def add_station(station) # public, т.к. используется в интерфейсе
    return false if station == start_station || station == finish_station

    intermediate_stations << station
    true
  end

  def remove_station(station) # public, т.к. используется в интерфейсе
    return false unless intermediate_stations.include?(station)

    intermediate_stations.delete(station)
    true
  end

  def stations # public, т.к. используется в интерфейсе
    [start_station, *intermediate_stations, finish_station]
  end

  def info # public, т.к. используется в интерфейсе
    "#{start_station.name} --> #{finish_station.name}"
  end

  private

  # Возможность менять маршрут напрямую следует ограничить
  attr_writer :start_station
  attr_writer :finish_station, :intermediate_stations
end