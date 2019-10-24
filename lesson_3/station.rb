class Station
  attr_reader :trains

  def initialize(name)
    @station_name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def trains_by_type(type)
    @trains.map { |train| train if train.type == type }
  end

  def move_train(train)
    @trains.delete train
  end
end
