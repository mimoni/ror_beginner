class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
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
end
