class Station
  include InstanceCounter
  attr_reader :trains

  @stations = []

  class << self
    attr_accessor :stations
  end

  def self.all
    @stations
  end

  def initialize(name)
    @station_name = name
    @trains = []
    self.class.stations << self
    register_instance
  end

  def to_s
    @name
  end

  def add_train(train)
    @trains << train
  end

  def trains_by_type(type)
    @trains.map { |train| train if train.type == type }
  end

  def move_train(train)
    @trains.delete(train)
  end
end
