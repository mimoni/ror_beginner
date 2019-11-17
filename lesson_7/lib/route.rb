# Класс Route (Маршрут):
# - Имеет начальную и конечную станцию, а также список промежуточных станций.
#    Начальная и конечная станции указываютсся при создании маршрута,
#    а промежуточные могут добавляться между ними.
# - Может добавлять промежуточную станцию в список
# - Может удалять промежуточную станцию из списка
# - Может выводить список всех станций по-порядку от начальной до конечной
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
    @stations.insert(-2, station) unless @stations.include? station
  end

  def delete_station(station)
    @stations.delete(station) if @stations.first != station && @stations.last != station
  end

  def show_stations
    @stations.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end
  end

  protected

  def validate!
    raise 'Имя должно состоять минимум из 2 символов' if @name.length < 2
    raise 'Начальная и конечная станция не должны совпадать' if @stations.last == @stations.first
  end
end
