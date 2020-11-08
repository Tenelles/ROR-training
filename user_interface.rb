# frozen_string_literal: true

require_relative 'data_base'

class UserInterface
  def initialize
    @db = DataBase.new
    help
  end

  def run # Метод запуска интерфейса
    loop do
      command = choose_command
      execute(command)
    end
  end

  private

  # Не стоит давать доступ к базе данных извне
  attr_accessor :db

  # Методы, осуществляющие работоспособность интерфейса. Видеть их пользователю не стоит
  def choose_command
    puts 'Введите команду. Для полного списка комманд введите "?"'
    print '>>'
    command = gets.chomp
  end

  def help
    puts 'Список команд: '
    puts "?\t\t\t\t\tПолный список команд"
    puts "create station\t\tСоздать станцию"
    puts "create train\t\tСоздать поезд"
    puts "create route\t\tСоздать маршрут"
    puts "add station\t\t\tДобавить станцию к маршруту"
    puts "remove station\t\tУдалить станцию из маршрута"
    puts "choose route\t\tВыбрать маршрут для поезда"
    puts "add van\t\t\t\tПрицепить вагон"
    puts "remove van\t\t\tОтцепить вагон"
    puts "move train\t\t\tПереместить поезд"
    puts "stations list\t\tСписок станций"
    puts "routes list\t\t\tСписок маршрутов"
    puts "trains list\t\t\tСписок поездов на станции"
    puts
  end

  def route_info(route)
    "#{route.start_station.name} --> #{route.finish_station.name}"
  end

  def get_information(message)
    puts "\t#{message}"
    print "\t>>"
    station_name = gets.chomp
  end

  def get_existing_station(message)
    name = get_information(message)
    station = db.station(name)
    if station.nil?
      puts "\tНеверная станция! Операция отклонена."
      return
    end
    station
  end

  def get_existing_train(message)
    number = get_information(message)
    train = db.train(number)
    if train.nil?
      puts "\tНеверный поезд! Операция отклонена."
      return
    end
    train
  end

  def get_existing_route(message)
    route_index = get_information(message).to_i - 1
    unless (0...db.routes.size).include?(route_index)
      puts "\tНеверный маршрут! Операция отклонена."
      return
    end
    db.routes[route_index]
  end

  def create_station
    name = get_information('Введите название станции:')
    station = Station.new(name)
    db.stations << station
    puts "\tСтанция \"#{name}\" создана."
  end

  def create_train
    number = get_information('Введите номер поезда:')
    type = get_information('Введите тип поезда (cargo или passenger):')
    case type
    when 'cargo'
      train = CargoTrain.new(number)
    when 'passenger'
      train = PassengerTrain.new(number)
    else
      puts "\tНеверный тип поезда! Поезд не был создан."
      return
    end
    db.trains << train
    puts "\tПоезд № #{number} создан."
  end

  def create_route
    start_station = get_existing_station('Укажите первую станцию маршрута:')
    return if start_station.nil?

    finish_station = get_existing_station('Укажите последнюю станцию маршрута:')
    return if finish_station.nil?

    if start_station == finish_station
      puts "\tМаршрут не может включать две одинаковые станции! Маршрут не был создан."
      return
    end
    route = Route.new(start_station, finish_station)
    db.routes << route
    puts "\tМаршрут \"#{route_info(route)}\" создан."
  end

  def add_station
    station = get_existing_station('Укажите станцию:')
    return if station.nil?

    route = get_existing_route('Укажите номер маршрута: ')
    return if route.nil?

    if route.add_station(station)
      puts "\tМаршрут уже содержит данную станцию! Операция отклонена.?"
      return
    end
    puts "\tСтанция #{station.name} была добавлена в маршрут \"#{route_info(route)}\""
  end

  def remove_station
    station = get_existing_station('Укажите станцию:')
    return if station.nil?

    route = get_existing_route('Укажите номер маршрута: ')
    return if route.nil?

    if route.remove_station(station)
      puts "\tМаршрут не содержит данную станцию! Операция отклонена."
      return
    end
    puts "\tСтанция #{station.name} была удалена из маршрута \"#{route_info(route)}\""
  end

  def choose_route
    route = get_existing_route('Укажите номер маршрута:')
    return if route.nil?

    train = get_existing_train('Укажите номер поезда:')
    return if train.nil?

    train.choose_route(route)
    puts "\tПоезд № #{train.number} был переведен на маршрут \"#{route_info(route)}\""
  end

  def add_van
    type = get_information('Введите тип вагона (cargo или passenger):')
    case type
    when 'cargo'
      van = CargoVan.new
    when 'passenger'
      van = PassengerVan.new
    else
      puts "\tНеверный тип вагона! Операция отклонена."
      return
    end
    train = get_existing_train('Укажите номер поезда:')
    return if train.nil?

    if train.attach(van)
      puts "\t#{type}-вагон был добавлен к поезду № #{train.number}"
    else
      puts "\tТип вагона не соответствует типу поезда! Операция отклонена."
    end
  end

  def remove_van
    train = get_existing_train('Укажите номер поезда:')
    return if train.nil?

    if train.vans_count.positive?
      train.detach
      puts "\tОдин вагон был отцеплен от поезда № #{train.number}"
    else
      puts "\tПоезд № #{train.number} не имеет вагонов! Операция отклонена."
    end
  end

  def move_train
    train = get_existing_train('Укажите номер поезда:')
    return if train.nil?

    unless train.on_route?
      puts "\tПоезд № #{train.number} не имеет маршрута! Операция отклонена."
      return
    end
    direction = get_information('Выберите направление движения (forward или back):')
    case direction
    when 'forward'
      train.move_forward
    when 'back'
      train.move_back
    else
      puts "\tНеверное направление! Операция отклонена."
    end
    puts "\tПоезд № #{train.number} продвинулся по маршруту."
  end

  def stations_list
    puts 'Список станций:'
    db.print_stations
  end

  def trains_list
    station = get_existing_station('Укажите станцию:')
    return if station.nil?

    puts "Список поездов на станции #{station.name}:"
    station.trains_list.each { |train| puts "№ #{train.number}: #{train.type}" }
  end

  def routes_list
    puts 'Список маршрутов:'
    db.print_routes
  end

  def execute(command)
    case command
    when '?'
      help
    when 'create station'
      create_station
    when 'create train'
      create_train
    when 'create route'
      create_route
    when 'add station'
      add_station
    when 'remove station'
      remove_station
    when 'choose route'
      choose_route
    when 'add van'
      add_van
    when 'remove van'
      remove_van
    when 'move train'
      move_train
    when 'stations list'
      stations_list
    when 'routes list'
      routes_list
    when 'trains list'
      trains_list
    else
      puts 'Неверная команда!'
    end
  end
end
