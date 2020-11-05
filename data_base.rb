require_relative 'station'
require_relative 'route'
require_relative 'trains/train'
require_relative 'trains/passenger_train'
require_relative 'trains/cargo_train'
require_relative 'vans/van'
require_relative 'vans/passenger_van'
require_relative 'vans/cargo_van'

class DataBase
  # Все public, т. к. все данные и методы созданы для удобной работы и хранения данных интерфейса
  attr_accessor :stations
  attr_accessor :routes, :trains, :vans

  def initialize
    @stations = []
    @routes = []
    @trains = []
    @vans = []
  end

  def station(name)
    stations.find { |station| station.name == name }
  end

  def train(number)
    trains.find { |train| train.number == number }
  end

  def print_stations
    i = 1
    stations.each do |station|
      puts "#{i}: #{station.name}"
      i += 1
    end
  end

  def print_routes
    i = 1
    routes.each do |route|
      puts "#{i}: #{route.info}"
      i += 1
    end
  end
end
