class Station
  include Validate
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

  protected

  def validate!
    raise 'Имя должно состоять минимум из 3 символов' if @name.length < 3
  end
end
