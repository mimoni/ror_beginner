# frozen_string_literal: true

class Station
  include Validate
  include InstanceCounter
  attr_reader :trains, :name

  validate :name, :presence

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
end
