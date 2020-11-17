# frozen_string_literal: true

require_relative 'data_base'

class UserInterface
  def initialize
    @db = DataBase.new
    help
  end

  def run
    loop do
      command = choose_command
      execute(command)
    end
  end

  private

  attr_accessor :db

  def choose_command
    puts 'Введите команду. Для полного списка комманд введите "?"'
    print '>>'
    gets.chomp
  end

  def help
    puts 'Список команд: '
    puts "?\t\t\tПолный список команд"
    puts "create station\t\tСоздать станцию"
    puts "create train\t\tСоздать поезд"
    puts "create route\t\tСоздать маршрут"
    puts "add station\t\tДобавить станцию к маршруту"
    puts "remove station\t\tУдалить станцию из маршрута"
    puts "choose route\t\tВыбрать маршрут для поезда"
    puts "add van\t\t\tПрицепить вагон"
    puts "remove van\t\tОтцепить вагон"
    puts "take place\t\tЗанять место в вагоне"
    puts "fill volume\t\tЗаполнить объем в вагоне"
    puts "move train\t\tПереместить поезд"
    puts "stations list\t\tСписок станций"
    puts "routes list\t\tCписок маршрутов"
    puts "station info\t\tСписок поездов на станции"
    puts "train info\t\tСписок вагонов в поезде"
    puts
  end

  def route_info(route)
    "#{route.start_station.name} --> #{route.finish_station.name}"
  end

  def get_information(message)
    puts "\t#{message}"
    print "\t>>"
    gets.chomp
  end

  def get_limited_information(message, correct_answers)
    answer = get_information(message)
    raise 'Неверный ввод' unless correct_answers.include?(answer)

    answer
  rescue RuntimeError
    puts "\tОшибка ввода! Повторите ввод."
    retry
  end

  def get_existing_station(message)
    name = get_information(message)
    station = db.station(name)
    raise 'Станция не найдена' if station.nil?

    station
  rescue RuntimeError
    puts "\tСтанция не найдена! Повторите ввод."
    retry
  end

  def get_existing_train(message)
    number = get_information(message)
    train = db.train(number)
    raise 'Поезд не найден' if train.nil?

    train
  rescue RuntimeError
    puts "\tПоезд не найден! Повторите ввод."
    retry
  end

  def get_existing_van(train, message)
    van_number = get_information(message).to_i - 1
    raise 'Вагон не найден' unless (0...train.vans.size).include?(van_number)

    train.vans[van_number]
  rescue RuntimeError
    puts "\tВагон не найден! Повторите ввод."
    retry
  end

  def get_existing_route(message)
    route_index = get_information(message).to_i - 1
    raise 'Маршрут не найден' unless (0...db.routes.size).include?(route_index)

    db.routes[route_index]
  rescue RuntimeError
    puts "\tМаршрут не найден! Повторите ввод."
    retry
  end

  def create_station
    name = get_information('Введите название станции (не менее 6 символов):')
    station = Station.new(name)
    db.stations << station
    puts "\tСтанция \"#{name}\" создана."
  rescue RuntimeError
    puts "\tНазвание станции слишком короткое! Повторите ввод."
    retry
  end

  def create_train
    type = get_limited_information('Введите тип поезда (cargo или passenger):', %w[cargo passenger])
    number = get_information('Введите номер поезда в формате ***-*** или ******, где * - латинская буква или цифра:')
    case type
    when 'cargo'
      train = CargoTrain.new(number)
    when 'passenger'
      train = PassengerTrain.new(number)
    end
    db.trains << train
    puts "\tПоезд ##{number} создан."
  rescue RuntimeError
    puts "\tНеверный формант номера поезда! Повторите ввод."
    retry
  end

  def create_route
    start_station = get_existing_station('Укажите первую станцию маршрута:')
    finish_station = get_existing_station('Укажите последнюю станцию маршрута:')

    route = Route.new(start_station, finish_station)
    db.routes << route
    puts "\tМаршрут \"#{route_info(route)}\" создан."
  rescue RuntimeError
    puts "\tОдинаковые начальная и конечная станции! Повторите ввод."
    retry
  end

  def add_station
    station = get_existing_station('Укажите станцию:')
    route = get_existing_route('Укажите номер маршрута: ')
    route.add_station(station)
    puts "\tСтанция #{station.name} была добавлена в маршрут \"#{route_info(route)}\""
  rescue RuntimeError
    puts "\tНельзя добавить станцию, которая уже есть в маршруте! Повторите ввод."
    retry
  end

  def remove_station
    station = get_existing_station('Укажите станцию:')
    route = get_existing_route('Укажите номер маршрута: ')
    puts "\tСтанция #{station.name} была удалена из маршрута \"#{route_info(route)}\""
  rescue RuntimeError
    puts "\tМаршрут не содержит данную станцию! Повторите ввод."
    retry
  end

  def choose_route
    route = get_existing_route('Укажите номер маршрута:')
    train = get_existing_train('Укажите номер поезда:')
    train.choose_route(route)
    puts "\tПоезд ##{train.number} был переведен на маршрут \"#{route_info(route)}\""
  end

  def add_van
    type = get_limited_information('Введите тип вагона (cargo или passenger):', %w[cargo passenger])
    case type
    when 'cargo'
      max_volume = get_information('Введите максимальный объем:').to_f
      van = CargoVan.new(max_volume)
    when 'passenger'
      places_count = get_information('Введите число мест:').to_i
      van = PassengerVan.new(places_count)
    end
    train = get_existing_train('Укажите номер поезда:')
    train.attach(van)
    puts "\t#{type}-вагон был добавлен к поезду № #{train.number}"
  rescue RuntimeError => e
    case e.to_s
    when 'Несоответствие типов вагона и поезда'
      puts "\tНесоответствие типов вагона и поезда! Повторите ввод."
      retry
    when 'Отрицательный объем'
      puts "\tМаксимальный объем не может быть отрицательным! Повторите ввод."
      retry
    when 'Отрицатеьное число мест'
      puts "\tЧисло мест не может быть отрицательным! Повторите ввод."
      retry
    when 'Управление вагоном движущегося поезда'
      puts "\tПопытка управления вагоном движущегося поезда! Операция не выполнена."
    end
  end

  def remove_van
    train = get_existing_train('Укажите номер поезда:')
    train.detach
    puts "\tОдин вагон был отцеплен от поезда № #{train.number}"
  rescue RuntimeError => e
    case e.to_s
    when 'Удаление несуществующего вагона'
      puts "\tПоезд не имеет вагонов!Операция не выполнена."
    when 'Управление вагоном движущегося поезда'
      puts "\tПопытка управления вагоном движущегося поезда! Операция не выполнена."
    end
  end

  def take_place
    train = get_existing_train('Укажите номер поезда:')
    van = get_existing_van(train, 'Укажите номер вагона:')
    van.take_place
    puts "\tМесто было занято успешно."
  rescue NoMethodError
    puts "\tДанная операция недоступна для вагона данного типа! Операция не выполнена."
  rescue RuntimeError
    puts "\tНедостаточно свободных мест! Операция не выполнена."
  end

  def fill_volume
    train = get_existing_train('Укажите номер поезда:')
    van = get_existing_van(train, 'Укажите номер вагона:')
    volume = get_information('Укажите добавочный объем:').to_i
    van.fill_volume(volume)
    puts "\tОбъем был добвлен успешно."
  rescue NoMethodError
    puts "\tДанная операция недоступна для вагона данного типа! Операция не выполнена."
  rescue RuntimeError
    puts "\tНевозможно добавить указанный объем! Операция не выполнена."
  end

  def move_train
    train = get_existing_train('Укажите номер поезда:')
    direction = get_limited_information('Выберите направление движения (forward или back):', %w[forward back])
    case direction
    when 'forward'
      train.move_forward
    when 'back'
      train.move_back
    end
    puts "\tПоезд ##{train.number} продвинулся по маршруту."
  rescue RuntimeError => e
    case e.to_s
    when 'Отсутствует маршрут'
      puts "\tДанный поезд не прикреплен к маршруту. Операция не выполнена."
    when 'Движение невозможно'
      puts "\tДвижение в данном направлении невозможно. Повторите ввод."
      retry
    end
  end

  def stations_list
    puts 'Список станций:'
    print_stations(db.stations)
  end

  def routes_list
    puts 'Список маршрутов:'
    print_routes(db.routes)
  end

  def print_stations(stations)
    stations.each.with_index(1) { |station, index| puts "#{index}: #{station.name}" }
  end

  def print_routes(routes)
    routes.each.with_index(1) { |route, index| puts "#{index}: #{route_info(route)}" }
  end

  def station_info
    station = get_existing_station('Укажите станцию:')

    puts "Список поездов на станции #{station.name}:"
    station.for_train { |train| puts "#{train.number}: #{train.type}, вагонов: #{train.vans.size}" }
  end

  def train_info
    train = get_existing_train('Укажите номер поезда:')

    puts "Список вагонов поезда ##{train.number}:"
    i = 0
    train.for_van do |van|
      i += 1
      case van.type
      when :cargo
        puts "#{i}: #{van.type}, свободно: #{van.free_volume} л, занято: #{van.filled_volume} л."
      when :passenger
        puts "#{i}: #{van.type}, свободно: #{van.free_places_count} мест, занято: #{van.taken_places_count} мест."
      end
    end
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
    when 'take place'
      take_place
    when 'fill volume'
      fill_volume
    when 'move train'
      move_train
    when 'stations list'
      stations_list
    when 'routes list'
      routes_list
    when 'station info'
      station_info
    when 'train info'
      train_info
    else
      puts 'Неверная команда!'
    end
  end
end
