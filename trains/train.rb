class Train
  attr_reader :number # public, используется для вывода

  def initialize(number)
    @number = number
    @speed = 0
    @vans = []
  end

  def increase_speed(value)
    self.speed += value
  end

  def stop
    self.speed = 0
  end

  def attach(van) # public, используется в интерфейсе
    if van.type == type && speed == 0
      vans << van
      true
    else
      false
    end
  end

  def detach # public, используется в интерфейсе
    vans.pop if speed == 0
  end

  def vans_count # public, используется в интерфейсе
    vans.size
  end

  def choose_route(chosen_route) # public, используется в интерфейсе
    self.route = chosen_route
    self.station = route.stations[0]
    station.take_train(self)
  end

  def on_route? # public, используется в интерфейсе
    !route.nil?
  end

  def move_forward # public, используется в интерфейсе
    return unless on_route?
    return if next_station.nil?

    station.send_train(self)
    self.station = next_station
    station.take_train(self)
  end

  def move_back # public, используется в интерфейсе
    return unless on_route?
    return if prev_station.nil?

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

  def type # public, используется для взаимодействия с вагонами
    :none
  end

  private

  attr_writer :number # Не стоит позволять менять номер поезда извне
  # Переменные, о которых извне лучше не знать
  attr_accessor :speed
  attr_accessor :route, :station, :vans

  def next_n_station(n)  # private, т.к. вспомогательная функция, есть 2 ее public-модификации
    return unless on_route?

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
