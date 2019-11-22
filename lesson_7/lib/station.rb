# frozen_string_literal: true

# Класс Station (Станция):
# - Имеет название, которое указывается при ее создании
# - Может принимать поезда (по одному за раз)
# - Может возвращать список всех поездов на станции находящиеся в текущий момент
# - Может возвращать список поездов на станции по типу (см. ниже):
#   кол-во грузовых, пассажирских
# - Может отправлять поезда (по одному за раз, при этом, поезд удаляется из
#   списка поездов, находящихся на станции).
class Station
  include Validate
  include InstanceCounter
  attr_reader :trains, :name

  @stations = []

  class << self
    attr_accessor :stations
  end

  def self.all
    @stations
  end

  def initialize(name)
    @name = name
    @trains = []
    self.class.stations << self
    register_instance
    validate!
  end

  def to_s
    @name
  end

  def arrival(train)
    @trains << train
  end

  def trains_by_type(type)
    @trains.map { |train| train if train.type == type }
  end

  def departure(train)
    @trains.delete train
  end

  def each_train
    @trains.each { |train| yield(train) } if block_given?
  end

  protected

  def validate!
    raise 'Имя должно состоять минимум из 3 символов' if @name.length < 3
  end
end
