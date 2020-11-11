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
  rescue RuntimeError
    false
  end

  def for_train(&block)
    return unless block_given?
    trains_list.each {|train| block.call(train)}
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

  MIN_NAME_LENGTH = 6

  @@objects = []
  class << self
    def objects
      @@objects
    end
  end

  def validate!
    raise 'Название станции слишком короткое' if name.length < MIN_NAME_LENGTH
  end

  attr_writer :trains_list, :name
end
