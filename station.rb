# frozen_string_literal: true

class Station
  attr_reader :trains_list, :name

  def self.all
    ObjectSpace.each_object(Station).to_a
  end

  def initialize(name)
    @name = name
    @trains_list = []
  end

  def take_train(train) # public, т.к. используется в реализации класса train
    trains_list << train
  end

  def send_train(train) # public, т.к. используется в реализации класса train
    trains_list.delete(train)
  end

  def trains_list_by_type(type)
    trains_list.select { |train| train.type == type }
  end

  private

  attr_writer :trains_list, :name
end
