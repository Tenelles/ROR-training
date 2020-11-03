class Station
  attr_reader :trains_list # Из ТЗ
  attr_reader :name        # Для вывода станций в методе класса Route

  def initialize(name)
    @name = name
    @trains_list = []
  end

  # Принятие одного поезда на стацию
  def take_train(train)
    trains_list << train
  end

  # Отправка конкретного поезда со станции, если таковой на ней имеется
  def send_train(train)
    trains_list.delete(train)
  end
  
  # Список поездов с указанным типом
  def trains_list_by_type(type) # 
    trains_list.select { |train| train.type == type }
  end

end

class Route
  #Для комфортной работы класса Train
  attr_reader :start_station
  attr_reader :finish_station

  def initialize(start_station, finish_station)
    @start_station = start_station
    @finish_station = finish_station
    @intermediate_stations = []
  end
  
  # Добавление указанной промежуточной станции
  def add_station(station)
    intermediate_stations << station
  end

  # Удаление указанной станции из списка промежуточных, если она там имеется
  def delete_station(station)
    intermediate_stations.delete(station)
  end

  def to_a
    [].concate([start_station], @intermediate_stations, [finish_station])
  end

  # Вывод всех станций по порядку следования
  def print
    puts "^ #{start_station.name}"
    intermediate_stations.each { |station| puts "! #{station.name}" }
    puts "- #{finish_station.name}"
  end
end

class Train
  attr_reader :speed # По ТЗ
  attr_reader :type # Для работы методов класса Station
  attr_reader :vans_count # По ТЗ

  def initialize(number, type, vans_count)
    @number = number
    @type = type
    @vans_count = vans_count
    @speed = 0
    @route
    @station
  end

  # Увеличить скорость на value
  def increase_speed(value)
    @speed += value
  end

  # Обнулить скорость
  def stop
    @speed = 0
  end

  # Увеличить кол-во вагонов, если поезд стоит
  def attach_van
    @vans_count += 1 if speed == 0
  end

  # Уменьшить кол-во вагонов, если поезд стоит
  def detach_van
    @vans_count -= 1 if speed == 0 && vans_count > 0
  end

  # Переключиться на указанный маршрут
  def choose_route(chosen_route)
    @route = chosen_route
    @station = @route.to_a[0]
    @station.take_train(self)
  end
  
  # Продвинуться по маршруту вперед, если не в конце пути
<<<<<<< Updated upstream
  def move_forward
    unless @route.nil?
      unless @station == @route.finish_station
        station_index = @route.to_a.index(station)
        station_index = 0 if station_index.nil? # Обработка удаления из маршрута станции, на которой есть поезд, следующий по данному маршруту
=======
  def move_forward_on_route
    unless @route.nil?
      station_index = @route.to_a.index(station)
      station_index = 0 if station_index.nil? # Обработка удаления из маршрута станции, на которой есть поезд, следующий по данному маршруту
      unless @station == @route.finish_station
>>>>>>> Stashed changes
        @route.to_a[station_index].send_train(self)
        station_index += 1
        @station = @route.to_a[station_index]
        @route.to_a[station_index].take_train(self)
      end
    end
  end

<<<<<<< Updated upstream
  def move_back
    unless @route.nil?
      unless @station == @route.start_station
        station_index = @route.to_a.index(station)
        station_index = 0 if station_index.nil? # Обработка удаления из маршрута станции, на которой есть поезд, следующий по данному маршруту
        @route.to_a[station_index].send_train(self)
        station_index += 1
=======
  # Продвинуться по маршруту назад, если не в начале пути
  def move_back_on_route
    unless @route.nil?
      station_index = @route.to_a.index(station)
      station_index = 0 if station_index.nil? # Обработка удаления из маршрута станции, на которой есть поезд, следующий по данному маршруту
      unless @station == @route.start_station
        @route.to_a[station_index].send_train(self)
        station_index -= 1
>>>>>>> Stashed changes
        @station = @route.to_a[station_index]
        @route.to_a[station_index].take_train(self)
      end
    end
  end

<<<<<<< Updated upstream
  def current_station
    @route[@position_in_route] unless @route.nil?
  end

  def next_station
    unless @route.nil?
      @route[@position_in_route + 1] unless @position_in_route == @route.size - 1
    end
  end

  def prev_station
    unless @route.nil?
      @route[@position_in_route - 1] unless @position_in_route == 0
=======
  def current_station_on_route
    @station unless @route.nil?
  end

  def next_station_on_route
	unless @route.nil?
	  station_index = @route.to_a.index(station)
      station_index = 0 if station_index.nil?
      @route[station_index + 1] unless station_index == @route.size - 1
    end
  end

  def prev_station_on_route
	unless @route.nil?
	  station_index = @route.to_a.index(station)
      station_index = 0 if station_index.nil?
      @route[station_index - 1] unless station_index == 0
>>>>>>> Stashed changes
    end
  end
end