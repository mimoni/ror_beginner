# frozen_string_literal: true

class Route
  include Validate
  include InstanceCounter
  attr_reader :stations, :name

  validate :name, :presence
  validate :stations, :custom, lambda { |stations|
    raise 'Начальная и конечная станция не должны совпадать' if stations.last == stations.first
  }

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
end
