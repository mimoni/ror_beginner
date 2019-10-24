class Train
  attr_reader :speed, :amount_train_carriage

  def initialize(number, type, amount_train_carriage = 0)
    @number = number
    @type = type
    @amount_train_carriage = amount_train_carriage
    @speed = 0
  end

  def increase_speed(speed)
    @speed += speed
  end

  def stop
    @speed = 0
  end

  def attach_carriage
    @amount_train_carriage += 1 if @speed.zero?
  end

  def detach_carriage
    @amount_train_carriage -= 1 if @speed.zero? && @amount_train_carriage.positive?
  end

  def set_route(route)
    @route = route
    @current_station = @route.stations.first
  end

  def move_forward
    @index_current_station = next_station if @route.stations.size - 1 > get_index_station
  end

  def move_backward
    @index_current_station = previous_station unless get_index_station.zero?
  end

  def previous_station
    @route.stations.index[get_index_station - 1]
  end

  def current_station
    @current_station
  end

  def next_station
    @route.stations.index[get_index_station + 1]
  end

  def get_index_station
    @route.stations.index(@current_station)
  end
end
