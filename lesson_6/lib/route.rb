class Route
  include Validate
  include InstanceCounter
  attr_reader :stations, :name

  def initialize(name, first_station, last_station)
    @name = name
    @stations = [first_station, last_station]
    register_instance
    validate!
  end

  def to_s
    @name
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def delete_station(station)
    @stations.delete(station) if @stations.first != station && @stations.last != station
  end

  def show_stations
    @stations.each_with_index do |station, index|
      puts "№#{index + 1}: #{station}"
    end
  end

  protected

  def validate!
    raise 'Имя должно состоять минимум из 2 символов' if @name.length < 2
    raise 'Начальная и конечная станция не должны совпадать' if @stations.last == @stations.first
  end
end
