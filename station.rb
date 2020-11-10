# frozen_string_literal: true

#   Список ошибок:
#     validate!: "Название станции слишком короткое"

class Station
  attr_reader :trains_list, :name

  def self.all
    objects
  end

  def initialize(name)
    @name = name
    @trains_list = []
    self.class.objects << self
    validate!
  end

  def valid?
    validate!
    true
  rescue RuntimeError => e
    false
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

  protected

  @@objects = []
  def self.objects
    @@objects
  end

  def validate!
    raise 'Название станции слишком короткое' if name.length < min_name_length
  end

  def min_name_length
    6
  end

  attr_writer :trains_list, :name
end
