# frozen_string_literal: true

require_relative 'station'
require_relative 'route'
require_relative 'trains/passenger_train'
require_relative 'trains/cargo_train'
require_relative 'vans/passenger_van'
require_relative 'vans/cargo_van'

class DataBase
  attr_accessor :stations, :routes, :trains, :vans

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
end
