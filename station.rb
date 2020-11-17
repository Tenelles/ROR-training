# frozen_string_literal: true

#   Список ошибок:
#     validate!: "Название станции слишком короткое"

require_relative 'validation'

class Station
  include Validation

  attr_reader :trains_list, :name

  def self.all
    objects
  end

  def initialize(name)
    @name = name
    @trains_list = []
    self.class.objects << self
    self.class.validate(:name, :precence)
    self.class.validate(:name, :type, String)
    self.class.validate(:name, :format, /......+/.source)
    validate!
  end

  def for_train(&block)
    return unless block_given?

    trains_list.each { |train| block.call(train) }
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
  class << self
    def objects
      @@objects
    end
  end

  attr_writer :trains_list, :name
end
