class Station
  attr_reader :trains_list
  attr_reader :name

  def initialize(name)
    @name = name
    @trains_list = []
  end

  def take_train(train)
    trains_list << train
  end

  def send_train(train)
    trains_list.delete(train)
  end
  
  def trains_list_by_type(type) 
    trains_list.select { |train| train.type == type }
  end

end

class Route
  attr_reader :start_station
  attr_reader :finish_station

  def initialize(start_station, finish_station)
    @start_station = start_station
    @finish_station = finish_station
    @intermediate_stations = []
  end
  
  def add_station(station)
    intermediate_stations << station
  end

  def delete_station(station)
    intermediate_stations.delete(station)
  end

  def stations
    [start_station, *@intermediate_stations, finish_station]
  end
end

class Train
  attr_reader :speed
  attr_reader :type
  attr_reader :vans_count

  def initialize(number, type, vans_count)
    @number = number
    @type = type
    @vans_count = vans_count
    @speed = 0
  end

  def increase_speed(value)
    @speed += value
  end

  def stop
    @speed = 0
  end

  def attach_van
    @vans_count += 1 if speed == 0
  end

  def detach_van
    @vans_count -= 1 if speed == 0 && vans_count > 0
  end

  def choose_route(chosen_route)
    @route = chosen_route
    @station = @route.stations[0]
    @station.take_train(self)
  end
  
  def move_forward
    return if @route.nil?
    @station.send_train(self)
    @station = next_station
    @station.take_train(self)
  end

  def move_back
    return if @route.nil?
    @station.send_train(self)
    @station = prev_station
    @station.take_train(self)
  end

  def current_station
    @station if route
  end


  def next_station
	  return if @route.nil?
	  station_index = @route.stations.index(@station)
    station_index = 0 if station_index.nil?
    return if station_index == @route.stations.size - 1
    @route.stations[station_index + 1]
  end

  def prev_station
  	return if @route.nil?
	  station_index = @route.stations.index(@station)
    station_index = @route.stations.size - 1 if station_index.nil?
    return if station_index == 0
    @route.stations[station_index - 1]
  end
end